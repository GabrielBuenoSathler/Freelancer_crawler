from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
import os
import pickle

# ======================================
# 🔹 1. Config
# ======================================
MODEL_NAME = "all-MiniLM-L6-v2"
CACHE_FILE = "vaga_embeddings.pkl"

# carregar modelo (1x só)
model = SentenceTransformer(MODEL_NAME)


# ======================================
# 🔹 2. Dados (mock ou banco)
# ======================================
vagas = [
    {"id": 1, "descricao": "Desenvolvedor Python com experiência em APIs REST, Docker e AWS"},
    {"id": 2, "descricao": "Frontend React com conhecimento em CSS, HTML e JavaScript"},
    {"id": 3, "descricao": "Engenheiro de dados com Spark, Hadoop e Python"},
]


user = {
    "skills": ["python", "docker", "aws"],
    "nivel": "pleno"
}


# ======================================
# 🔹 3. Transformar usuário em texto
# ======================================
def perfil_to_text(user):
    return f"skills: {' '.join(user['skills'])} nivel: {user['nivel']}"


# ======================================
# 🔹 4. Gerar embeddings das vagas (BATCH + CACHE)
# ======================================
def gerar_embeddings_vagas(vagas):
    
    # 🔥 Se já existe cache, usa
    if os.path.exists(CACHE_FILE):
        print("🔹 Carregando embeddings do cache...")
        with open(CACHE_FILE, "rb") as f:
            return pickle.load(f)
    
    print("🔹 Gerando embeddings das vagas...")
    
    textos = [v["descricao"] for v in vagas]
    
    embeddings = model.encode(
        textos,
        batch_size=32,
        show_progress_bar=True
    )
    
    # salvar no cache
    for i, vaga in enumerate(vagas):
        vaga["embedding"] = embeddings[i]
    
    with open(CACHE_FILE, "wb") as f:
        pickle.dump(vagas, f)
    
    return vagas


# ======================================
# 🔹 5. Gerar embedding do usuário
# ======================================
def embed_user(user):
    texto = perfil_to_text(user)
    return model.encode(texto)


# ======================================
# 🔹 6. Match vetorizado (rápido)
# ======================================
def match_vagas(user_emb, vagas):
    
    # matriz de embeddings
    vaga_embeddings = np.array([v["embedding"] for v in vagas])
    
    # similaridade em lote
    scores = cosine_similarity([user_emb], vaga_embeddings)[0]
    
    resultados = []
    
    for i, vaga in enumerate(vagas):
        resultados.append({
            "vaga_id": vaga["id"],
            "descricao": vaga["descricao"],
            "score": float(scores[i])
        })
    
    # ordenar
    return sorted(resultados, key=lambda x: x["score"], reverse=True)


# ======================================
# 🔹 7. Pipeline completo
# ======================================
def run():
    global vagas
    
    # embeddings das vagas (cache)
    vagas = gerar_embeddings_vagas(vagas)
    
    # embedding do usuário
    user_emb = embed_user(user)
    
    # match
    resultados = match_vagas(user_emb, vagas)
    
    # output
    print("\n🔎 RESULTADOS:\n")
    
    for r in resultados:
        print(f"Vaga {r['vaga_id']} | Score: {r['score']:.4f}")
        print(r["descricao"])
        print("-" * 50)


# ======================================
# 🔹 8. Executar
# ======================================
if __name__ == "__main__":
    run()







































































































