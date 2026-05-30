import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";

const API = import.meta.env.VITE_API_URL ?? "";

interface Freela {
  titulo: string;
  plataforma: string | null;
  descricao: string | null;
}

function VagaCard({ vaga }: { vaga: Freela }) {
  return (
    <div style={s.card}>
      <div style={s.cardTop}>
        {vaga.plataforma && <span style={s.badge}>{vaga.plataforma}</span>}
      </div>

      <h3 style={s.cardTitle}>{vaga.titulo}</h3>

      {vaga.descricao && <p style={s.cardDesc}>{vaga.descricao}</p>}
    </div>
  );
}

function Vagas() {
  const [vagas, setVagas] = useState<Freela[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();

  function handleLogout() {
    localStorage.removeItem("access_token");
    localStorage.removeItem("email");
    navigate("/login");
  }

  useEffect(() => {
    const token = localStorage.getItem("access_token");
    if (!token) {
      navigate("/");
      return;
    }

    fetch(`${API}/match_vagas`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then((res) => {
        if (res.status === 401) {
          localStorage.removeItem("access_token");
          navigate("/");
          return null;
        }
        if (res.status === 400) {
          navigate("/register-skill");
          return null;
        }
        if (!res.ok) throw new Error("Erro ao carregar vagas");
        return res.json() as Promise<Freela[]>;
      })
      .then((data) => { if (data) setVagas(data); })
      .catch((err: Error) => setError(err.message))
      .finally(() => setLoading(false));
  }, [navigate]);

  return (
    <div style={s.page}>
      <div style={{ ...s.orb, top: -120, left: -120, width: 450, height: 450, background: "rgba(124,58,237,0.28)" }} />
      <div style={{ ...s.orb, bottom: -80, right: 60, width: 320, height: 320, background: "rgba(109,40,217,0.22)" }} />
      <div style={{ ...s.orb, top: "38%", right: -80, width: 280, height: 280, background: "rgba(139,92,246,0.16)" }} />

      <div style={s.container}>
        <div style={s.header}>
          <div style={s.logoCircle}>
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2.5" strokeLinecap="round">
              <circle cx="11" cy="11" r="8" />
              <line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
          </div>
          <h1 style={s.title}>Vagas para você</h1>
          <p style={s.subtitle}>Oportunidades que combinam com o seu perfil.</p>
          <div style={s.headerActions}>
            <button style={s.editBtn} onClick={() => navigate("/update-skill")}>
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M12 20h9" />
                <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z" />
              </svg>
              Editar perfil
            </button>
            <button style={s.logoutBtn} onClick={handleLogout}>
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
                <polyline points="16 17 21 12 16 7" />
                <line x1="21" y1="12" x2="9" y2="12" />
              </svg>
              Sair
            </button>
          </div>
        </div>

        {loading && (
          <div style={s.centered}>
            <div style={s.spinner} />
            <p style={s.stateText}>Buscando vagas...</p>
          </div>
        )}

        {!loading && error && (
          <div style={s.centered}>
            <p style={{ ...s.stateText, color: "rgba(248,113,113,0.9)" }}>{error}</p>
          </div>
        )}

        {!loading && !error && vagas.length === 0 && (
          <div style={s.centered}>
            <p style={s.stateText}>Nenhuma vaga encontrada para o seu perfil.</p>
          </div>
        )}

        {!loading && !error && vagas.length > 0 && (
          <div style={s.grid}>
            {vagas.map((vaga, i) => (
              <VagaCard key={i} vaga={vaga} />
            ))}
          </div>
        )}

        <footer style={s.footer}>© 2024 Freelance Finder. Todos os direitos reservados.</footer>
      </div>
    </div>
  );
}

const s: Record<string, React.CSSProperties> = {
  page: {
    minHeight: "100vh",
    width: "100%",
    background: "linear-gradient(135deg, #0d0b1e 0%, #1a0b3b 50%, #0e1b2e 100%)",
    display: "flex",
    justifyContent: "center",
    position: "relative",
    overflow: "hidden",
    fontFamily: "'Segoe UI', system-ui, sans-serif",
  },
  orb: {
    position: "absolute",
    borderRadius: "50%",
    filter: "blur(90px)",
    pointerEvents: "none",
  },
  container: {
    width: "100%",
    maxWidth: 960,
    padding: "48px 20px 60px",
    position: "relative",
    zIndex: 1,
  },
  header: {
    textAlign: "center",
    marginBottom: 44,
  },
  logoCircle: {
    width: 68,
    height: 68,
    borderRadius: "50%",
    background: "linear-gradient(135deg, #7c3aed, #6d28d9)",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    margin: "0 auto 18px",
    boxShadow: "0 0 40px rgba(124,58,237,0.55)",
  },
  title: {
    fontSize: 38,
    fontWeight: 700,
    color: "#ffffff",
    margin: "0 0 12px",
    letterSpacing: "-0.5px",
  },
  subtitle: {
    fontSize: 15,
    color: "rgba(255,255,255,0.58)",
    lineHeight: 1.7,
    margin: 0,
  },
  headerActions: {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    gap: 12,
    marginTop: 18,
    flexWrap: "wrap",
  },
  editBtn: {
    display: "inline-flex",
    alignItems: "center",
    gap: 7,
    padding: "9px 18px",
    background: "rgba(124,58,237,0.18)",
    border: "1px solid rgba(139,92,246,0.45)",
    borderRadius: 8,
    color: "rgba(196,181,253,1)",
    fontSize: 14,
    fontWeight: 500,
    cursor: "pointer",
  },
  logoutBtn: {
    display: "inline-flex",
    alignItems: "center",
    gap: 7,
    padding: "9px 18px",
    background: "rgba(248,113,113,0.12)",
    border: "1px solid rgba(248,113,113,0.45)",
    borderRadius: 8,
    color: "rgba(252,165,165,1)",
    fontSize: 14,
    fontWeight: 500,
    cursor: "pointer",
  },
  grid: {
    display: "grid",
    gridTemplateColumns: "repeat(auto-fill, minmax(280px, 1fr))",
    gap: 20,
  },
  card: {
    background: "rgba(255,255,255,0.05)",
    border: "1px solid rgba(139,92,246,0.28)",
    borderRadius: 16,
    padding: "24px 22px",
    backdropFilter: "blur(12px)",
    display: "flex",
    flexDirection: "column",
    gap: 12,
    transition: "border-color 0.2s",
  },
  cardTop: {
    display: "flex",
    alignItems: "center",
    justifyContent: "space-between",
    gap: 8,
  },
  badge: {
    fontSize: 11.5,
    fontWeight: 600,
    color: "rgba(167,139,250,1)",
    background: "rgba(124,58,237,0.2)",
    border: "1px solid rgba(139,92,246,0.4)",
    borderRadius: 20,
    padding: "3px 10px",
    textTransform: "uppercase",
    letterSpacing: "0.05em",
  },
  cardTitle: {
    fontSize: 16,
    fontWeight: 600,
    color: "#ffffff",
    margin: 0,
    lineHeight: 1.45,
  },
  cardDesc: {
    fontSize: 13.5,
    color: "rgba(255,255,255,0.52)",
    margin: 0,
    lineHeight: 1.6,
    display: "-webkit-box",
    WebkitLineClamp: 3,
    WebkitBoxOrient: "vertical",
    overflow: "hidden",
  },
  centered: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    justifyContent: "center",
    minHeight: 200,
    gap: 16,
  },
  stateText: {
    fontSize: 15,
    color: "rgba(255,255,255,0.45)",
    margin: 0,
  },
  spinner: {
    width: 36,
    height: 36,
    border: "3px solid rgba(139,92,246,0.25)",
    borderTop: "3px solid #7c3aed",
    borderRadius: "50%",
    animation: "spin 0.8s linear infinite",
  },
  footer: {
    textAlign: "center",
    marginTop: 56,
    fontSize: 13,
    color: "rgba(255,255,255,0.32)",
  },
};

export default Vagas;
