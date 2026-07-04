from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from sqlalchemy import text
import numpy as np
import pickle
import os
from collections.abc import Mapping
from typing import Any
from connect import engine

# =====================================
# CONFIG
# ======================================

MODEL_NAME = "all-MiniLM-L6-v2"
CACHE_FILE = "vaga_embeddings.pkl"

_model: SentenceTransformer | None = None

def get_model() -> SentenceTransformer:
    global _model
    if _model is None:
        print("🔹 Carregando modelo...")
        _model = SentenceTransformer(MODEL_NAME)
    return _model

# ======================================
# BUSC
# ======================================

def vagas_to_emb(limit: int = 500) -> list[dict[str, Any]]:

    query = text("""
        SELECT
            titulo,
            descricao,
            link,
            plataforma

        FROM freelas
        WHERE descricao IS NOT NULL
        AND plataforma IS NOT NULL
        AND created_at >= NOW() - INTERVAL '1 day'
        ORDER BY created_at DESC
        LIMIT :limit

    """)

    vagas = []

    with engine.connect() as conn:

        result = conn.execute(
            query,
            {"limit": limit}
        )

        for row in result.mappings():

            descricao = row["descricao"]

            if not descricao:
                continue

            vagas.append({
                "titulo": row["titulo"],
                "descricao": descricao.strip(),
                "link" : row["link"],
                "plataforma":row["plataforma"]

            })

    return vagas


# ======================================
# PERFIL -> TEXTO
# ======================================

def perfil_to_text(user: Mapping[str, Any]) -> str:

    print("USER:", user)

    # se vier lista
    if isinstance(user["skill"], list):
        skill = " ".join(user["skill"])

    # se vier string do banco
    else:
        skill = str(user["skill"])

    texto = f"""
    Skill: {skill}
    """

    return texto.strip()


# ======================================
# GERAR EMBEDDINGS VAGAS
# ======================================

def gerar_embeddings_vagas(vagas: list[dict[str, Any]]) -> list[dict[str, Any]]:

    if os.path.exists(CACHE_FILE):

        print("🔹 Carregando embeddings do cache...")

        try:

            with open(CACHE_FILE, "rb") as f:
                vagas_cache = pickle.load(f)

            if (
                isinstance(vagas_cache, list)
                and len(vagas_cache) > 0
                and "embedding" in vagas_cache[0]
            ):

                print("✅ Cache válido")
                return vagas_cache

        except Exception as e:
            print(f"⚠ Erro ao carregar cache: {e}")

    print("🔹 Gerando embeddings...")

    textos = [vaga["descricao"] for vaga in vagas]

    embeddings = get_model().encode(
        textos,
        batch_size=32,
        convert_to_numpy=True,
        show_progress_bar=True
    )

    for i, vaga in enumerate(vagas):
        vaga["embedding"] = embeddings[i]

    with open(CACHE_FILE, "wb") as f:
        pickle.dump(vagas, f)

    print("✅ Cache salvo")

    return vagas


# ======================================
# EMBEDDING USUÁRIO
# ======================================

def gerar_embedding_usuario(user: Mapping[str, Any]) -> np.ndarray:

    texto = perfil_to_text(user)

    embedding = get_model().encode(
        texto,
        convert_to_numpy=True
    )

    return embedding


# ======================================
# MATCH
# ======================================

def calcular_match_vagas(
    user_embedding: np.ndarray,
    vagas: list[dict[str, Any]],
    top_k: int = 10,
) -> list[dict[str, Any]]:

    vaga_embeddings = np.array([
        vaga["embedding"]
        for vaga in vagas
    ])

    scores = cosine_similarity(
        [user_embedding],
        vaga_embeddings
    )[0]

    resultados = []

    for i, vaga in enumerate(vagas):

        resultados.append({
            "titulo": vaga["titulo"],
            "descricao": vaga["descricao"],
            "plataforma": vaga["plataforma"],
            "link": vaga["link"],
            "score": float(scores[i])
        })

    resultados.sort(
        key=lambda x: x["score"],
        reverse=True
    )

    return resultados[:top_k]


# ======================================
# OUTPUT
# ======================================

def mostrar_resultados(resultados: list[dict[str, Any]]) -> None:

    print("\n========== RESULTADOS ==========\n")
    for i, vaga in enumerate(resultados, start=1):

        print(f"#{i}")
        print(f"Título: {vaga['titulo']}")
        print(f"Plataforma: {vaga['plataforma']}")
        print(f"Score: {vaga['score']:.4f}")
        print()
        print(f"Descrição:\n{vaga['descricao'][:300]}")
        print("-" * 60)


# ======================================
# PIPELINE
# ======================================

def match_vagas(user: Mapping[str, Any]) -> list[dict[str, Any]]:

    print("🔹 Buscando vagas...")

    vagas = vagas_to_emb()

    print(f"✅ {len(vagas)} vagas encontradas")

    vagas = gerar_embeddings_vagas(vagas)

    print("🔹 Gerando embedding do usuário...")

    user_embedding = gerar_embedding_usuario(user)

    print("🔹 Fazendo match...")

    resultados = calcular_match_vagas(
        user_embedding,
        vagas
    )

    mostrar_resultados(resultados)

    return resultados
