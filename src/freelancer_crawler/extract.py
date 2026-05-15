from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from sqlalchemy import text
import numpy as np
import pickle
import os

from connect import engine

# =====================================
# CONFIG
# ======================================

MODEL_NAME = "all-MiniLM-L6-v2"
CACHE_FILE = "vaga_embeddings.pkl"

print("🔹 Carregando modelo...")
model = SentenceTransformer(MODEL_NAME)


# ======================================
# BUSCAR VAGAS
# ======================================

def vagas_to_emb(limit=100):

    query = text("""
        SELECT
            titulo,
            descricao
        FROM freelas
        WHERE descricao IS NOT NULL
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
                "descricao": descricao.strip()
            })

    return vagas


# ======================================
# PERFIL -> TEXTO
# ======================================

def perfil_to_text(user):

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

def gerar_embeddings_vagas(vagas):

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

    embeddings = model.encode(
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

def gerar_embedding_usuario(user):

    texto = perfil_to_text(user)

    embedding = model.encode(
        texto,
        convert_to_numpy=True
    )

    return embedding


# ======================================
# MATCH
# ======================================

def calcular_match_vagas(user_embedding, vagas, top_k=10):

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

def mostrar_resultados(resultados):

    print("\n========== RESULTADOS ==========\n")

    for i, vaga in enumerate(resultados, start=1):

        print(f"#{i}")
        print(f"Título: {vaga['titulo']}")
        print(f"Score: {vaga['score']:.4f}")
        print(f"Descrição:\n{vaga['descricao'][:300]}")
        print("-" * 60)


# ======================================
# PIPELINE
# ======================================

def match_vagas(user):

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
