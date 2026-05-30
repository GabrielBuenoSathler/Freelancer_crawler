import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";

const NIVEIS = ["Júnior", "Pleno", "Sênior"];

const LOCALIZACOES = ["Brasil", "Estados Unidos", "Portugal", "Argentina", "Remoto"];

const IDIOMAS_OPCOES = ["Português", "Inglês", "Espanhol", "Francês", "Alemão"];

const SKILLS_OPCOES = [
  "Python", "JavaScript", "TypeScript", "React", "Node.js",
  "Java", "C#", "Go", "PHP", "Vue.js", "Angular", "SQL",
];

function toggleItem(list: string[], item: string): string[] {
  return list.includes(item) ? list.filter((i) => i !== item) : [...list, item];
}

const API = import.meta.env.VITE_API_URL ?? "";

function RegisterSkill() {
  const navigate = useNavigate();
  const [nivel, setNivel] = useState("");
  const [localizacao, setLocalizacao] = useState("");
  const [idiomas, setIdiomas] = useState<string[]>([]);
  const [skills, setSkills] = useState<string[]>([]);

  useEffect(() => {
    const token = localStorage.getItem("access_token");
    const email = localStorage.getItem("email");

    if (!token || !email) {
      navigate("/");
    }
  }, [navigate]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();

    const email = localStorage.getItem("email") ?? "";
    const token = localStorage.getItem("access_token") ?? "";

    if (!token) {
      alert("Você precisa estar logado para criar um perfil");
      return;
    }

    if (!email) {
      alert("Erro: email não encontrado");
      return;
    }

    if (!nivel || !localizacao || idiomas.length === 0 || skills.length === 0) {
      alert("Por favor, preencha todos os campos");
      return;
    }

    const dados = {
      username: email,
      nivel,
      localizacao,
      idiomas: idiomas.join(", "),
      skill: skills.join(", "),
    };

    try {
      const response = await fetch(`${API}/user_profile/`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(dados),
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.detail || "Erro ao enviar dados");
      }

      const data = await response.json();
      console.log("Resposta do backend:", data);
      alert("Perfil criado com sucesso! Agora você pode ver as vagas.");
      // Navigate to vagas page
      window.location.href = "/vagas";
    } catch (error) {
      console.error("Erro ao enviar dados:", error);
      alert(error instanceof Error ? error.message : "Erro ao enviar dados");
    }

    setNivel("");
    setLocalizacao("");
    setIdiomas([]);
    setSkills([]);
  }

  return (
    <div style={s.page}>
      <div style={{ ...s.orb, top: -120, left: -120, width: 450, height: 450, background: "rgba(124,58,237,0.28)" }} />
      <div style={{ ...s.orb, bottom: -80, right: 60, width: 320, height: 320, background: "rgba(109,40,217,0.22)" }} />
      <div style={{ ...s.orb, top: "38%", right: -80, width: 280, height: 280, background: "rgba(139,92,246,0.16)" }} />

      <div style={s.container}>
        <div style={s.header}>
          <div style={s.logoCircle}>
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M12 20h9" />
              <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z" />
            </svg>
          </div>
          <h1 style={s.title}>Cadastro de Skills</h1>
          <p style={s.subtitle}>Conte um pouco sobre você para encontrarmos as melhores vagas.</p>
        </div>

        <form onSubmit={handleSubmit} style={s.card}>
          <div style={s.field}>
            <label style={s.label}>Nível</label>
            <div style={s.chipGroup}>
              {NIVEIS.map((op) => (
                <label key={op} style={nivel === op ? { ...s.chip, ...s.chipActive } : s.chip}>
                  <input
                    type="radio"
                    name="nivel"
                    value={op}
                    checked={nivel === op}
                    onChange={() => setNivel(op)}
                    style={s.hiddenInput}
                  />
                  {op}
                </label>
              ))}
            </div>
          </div>

          <div style={s.field}>
            <label style={s.label}>Localização</label>
            <select
              value={localizacao}
              onChange={(e) => setLocalizacao(e.target.value)}
              style={s.select}
            >
              <option value="">Selecione...</option>
              {LOCALIZACOES.map((op) => (
                <option key={op} value={op} style={s.option}>
                  {op}
                </option>
              ))}
            </select>
          </div>

          <div style={s.field}>
            <label style={s.label}>Idiomas</label>
            <div style={s.chipGroup}>
              {IDIOMAS_OPCOES.map((op) => (
                <label key={op} style={idiomas.includes(op) ? { ...s.chip, ...s.chipActive } : s.chip}>
                  <input
                    type="checkbox"
                    checked={idiomas.includes(op)}
                    onChange={() => setIdiomas(toggleItem(idiomas, op))}
                    style={s.hiddenInput}
                  />
                  {op}
                </label>
              ))}
            </div>
          </div>

          <div style={s.field}>
            <label style={s.label}>Skills</label>
            <div style={s.chipGroup}>
              {SKILLS_OPCOES.map((op) => (
                <label key={op} style={skills.includes(op) ? { ...s.chip, ...s.chipActive } : s.chip}>
                  <input
                    type="checkbox"
                    checked={skills.includes(op)}
                    onChange={() => setSkills(toggleItem(skills, op))}
                    style={s.hiddenInput}
                  />
                  {op}
                </label>
              ))}
            </div>
          </div>

          <button type="submit" style={s.button}>
            Cadastrar
          </button>
        </form>
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
    maxWidth: 560,
    padding: "48px 20px 60px",
    position: "relative",
    zIndex: 1,
  },
  header: {
    textAlign: "center",
    marginBottom: 32,
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
    fontSize: 34,
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
  card: {
    background: "rgba(255,255,255,0.05)",
    border: "1px solid rgba(139,92,246,0.28)",
    borderRadius: 16,
    padding: "32px 28px",
    backdropFilter: "blur(12px)",
    display: "flex",
    flexDirection: "column",
    gap: 22,
  },
  field: {
    display: "flex",
    flexDirection: "column",
    gap: 10,
  },
  label: {
    fontSize: 13,
    fontWeight: 600,
    color: "rgba(255,255,255,0.75)",
    textTransform: "uppercase",
    letterSpacing: "0.5px",
  },
  chipGroup: {
    display: "flex",
    flexWrap: "wrap",
    gap: 10,
  },
  chip: {
    display: "inline-flex",
    alignItems: "center",
    padding: "8px 16px",
    borderRadius: 20,
    border: "1px solid rgba(139,92,246,0.35)",
    background: "rgba(255,255,255,0.05)",
    color: "rgba(255,255,255,0.7)",
    fontSize: 13.5,
    fontWeight: 500,
    cursor: "pointer",
    userSelect: "none",
    transition: "all 0.15s",
  },
  chipActive: {
    background: "rgba(124,58,237,0.28)",
    border: "1px solid rgba(167,139,250,0.9)",
    color: "#ffffff",
  },
  hiddenInput: {
    position: "absolute",
    opacity: 0,
    width: 0,
    height: 0,
  },
  select: {
    padding: "11px 12px",
    borderRadius: 8,
    border: "1px solid rgba(139,92,246,0.3)",
    background: "rgba(255,255,255,0.08)",
    color: "#ffffff",
    fontSize: 14,
    fontFamily: "inherit",
    cursor: "pointer",
  },
  option: {
    background: "#1a0b3b",
    color: "#ffffff",
  },
  button: {
    marginTop: 8,
    padding: "12px 16px",
    backgroundColor: "#7c3aed",
    color: "#fff",
    border: "none",
    borderRadius: 8,
    cursor: "pointer",
    fontWeight: 600,
    fontSize: 14,
  },
};

export default RegisterSkill;
