from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from sqlalchemy import text
import numpy as np
import pickle
import os
import threading

from connect import engine

# =====================================
# CONFIG
# ======================================

MODEL_NAME = "all-MiniLM-L6-v2"
# caminho absoluto: o cache nao depende do diretorio de onde o processo roda
CACHE_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "vaga_embeddings.pkl")

_cache_lock = threading.Lock()

_model = None

def get_model():
    global _model
    if _model is None:
        print("🔹 Carregando modelo...")
        _model = SentenceTransformer(MODEL_NAME)
    return _model

# ======================================
# BUSC
# ======================================

def vagas_to_emb(limit=50):

    query = text("""
        SELECT
            titulo,
            descricao,
            link,
            plataforma

        FROM freelas
        WHERE descricao IS NOT NULL
        AND plataforma IS NOT NULL

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

    # lock: evita que varias requests regenerem os embeddings ao mesmo tempo
    with _cache_lock:
        return _gerar_embeddings_vagas(vagas)


def _gerar_embeddings_vagas(vagas):

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

                links_cache = {vaga["link"] for vaga in vagas_cache}
                links_atuais = {vaga["link"] for vaga in vagas}

                if links_cache == links_atuais:
                    print("✅ Cache válido")
                    return vagas_cache

                print("⚠ Cache desatualizado, regenerando embeddings...")

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

def gerar_embedding_usuario(user):

    texto = perfil_to_text(user)

    embedding = get_model().encode(
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

def mostrar_resultados(resultados):

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
# WARMUP
# ======================================

def warmup():
    """Carrega o modelo e gera o cache de embeddings antecipadamente,
    para que /match_vagas nao pague esse custo na primeira request."""

    print("🔹 Warmup: carregando modelo...")
    get_model()

    try:
        vagas = vagas_to_emb()
        gerar_embeddings_vagas(vagas)
        print("✅ Warmup concluído")
    except Exception as e:
        # banco pode nao estar pronto ainda; a request regenera se precisar
        print(f"⚠ Warmup de embeddings falhou: {e}")


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
