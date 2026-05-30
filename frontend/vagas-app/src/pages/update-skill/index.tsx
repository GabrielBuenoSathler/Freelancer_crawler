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

function splitList(value: string | null | undefined): string[] {
  if (!value) return [];
  return value.split(",").map((v) => v.trim()).filter(Boolean);
}

const API = import.meta.env.VITE_API_URL ?? "";

interface Profile {
  username?: string;
  nivel?: string;
  localizacao?: string;
  idiomas?: string;
  skill?: string;
}

function UpdateSkill() {
  const navigate = useNavigate();
  const [nivel, setNivel] = useState("");
  const [localizacao, setLocalizacao] = useState("");
  const [idiomas, setIdiomas] = useState<string[]>([]);
  const [skills, setSkills] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem("access_token");
    if (!token) {
      navigate("/");
      return;
    }

    fetch(`${API}/profile`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then((res) => {
        if (res.status === 401) {
          localStorage.removeItem("access_token");
          navigate("/");
          return null;
        }
        if (!res.ok) throw new Error("Erro ao carregar perfil");
        return res.json() as Promise<Profile[]>;
      })
      .then((data) => {
        if (!data) return;
        const p = data[0];
        if (!p) {
          // Sem perfil ainda: redireciona para a criação
          navigate("/register-skill");
          return;
        }
        setNivel(p.nivel ?? "");
        setLocalizacao(p.localizacao ?? "");
        setIdiomas(splitList(p.idiomas));
        setSkills(splitList(p.skill));
      })
      .catch(() => alert("Não foi possível carregar seu perfil."))
      .finally(() => setLoading(false));
  }, [navigate]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();

    const email = localStorage.getItem("email") ?? "";
    const token = localStorage.getItem("access_token") ?? "";

    if (!token) {
      alert("Você precisa estar logado para atualizar o perfil");
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

    setSaving(true);
    try {
      const response = await fetch(`${API}/user_profile/`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(dados),
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.detail || "Erro ao atualizar dados");
      }

      alert("Perfil atualizado com sucesso!");
      navigate("/vagas");
    } catch (error) {
      console.error("Erro ao atualizar dados:", error);
      alert(error instanceof Error ? error.message : "Erro ao atualizar dados");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div style={s.page}>
      <div style={{ ...s.orb, top: -120, left: -120, width: 450, height: 450, background: "rgba(124,58,237,0.28)" }} />
      <div style={{ ...s.orb, bottom: -80, right: 60, width: 320, height: 320, background: "rgba(109,40,217,0.22)" }} />
      <div style={{ ...s.orb, top: "38%", right: -80, width: 280, height: 280, background: "rgba(139,92,246,0.16)" }} />

      <div style={s.container}>
        <div style={s.header}>
          <div style={s.logoCircle}>
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M12 20h9" />
              <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z" />
            </svg>
          </div>
          <h1 style={s.title}>Atualizar perfil</h1>
          <p style={s.subtitle}>Ajuste suas skills e preferências para melhorar os matches.</p>
        </div>

        {loading ? (
          <div style={s.centered}>
            <div style={s.spinner} />
            <p style={s.stateText}>Carregando perfil...</p>
          </div>
        ) : (
          <form onSubmit={handleSubmit} style={s.card}>
            <div style={s.field}>
              <label style={s.label}>Nível</label>
              <div style={s.radioGroup}>
                {NIVEIS.map((op) => (
                  <label key={op} style={s.radioLabel}>
                    <input
                      type="radio"
                      name="nivel"
                      value={op}
                      checked={nivel === op}
                      onChange={() => setNivel(op)}
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
                  <option key={op} value={op}>
                    {op}
                  </option>
                ))}
              </select>
            </div>

            <div style={s.field}>
              <label style={s.label}>Idiomas</label>
              <div style={s.checkboxGroup}>
                {IDIOMAS_OPCOES.map((op) => (
                  <label key={op} style={idiomas.includes(op) ? s.chipActive : s.chip}>
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
              <div style={s.checkboxGroup}>
                {SKILLS_OPCOES.map((op) => (
                  <label key={op} style={skills.includes(op) ? s.chipActive : s.chip}>
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

            <div style={s.actions}>
              <button type="button" style={s.btnGhost} onClick={() => navigate("/vagas")}>
                Cancelar
              </button>
              <button type="submit" style={s.btn} disabled={saving}>
                {saving ? "Salvando..." : "Salvar alterações"}
              </button>
            </div>
          </form>
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
    maxWidth: 620,
    padding: "48px 20px 60px",
    position: "relative",
    zIndex: 1,
  },
  header: {
    textAlign: "center",
    marginBottom: 36,
  },
  logoCircle: {
    width: 64,
    height: 64,
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
    borderRadius: 18,
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
    fontSize: 14,
    fontWeight: 600,
    color: "rgba(255,255,255,0.78)",
  },
  radioGroup: {
    display: "flex",
    gap: 18,
    flexWrap: "wrap",
  },
  radioLabel: {
    display: "flex",
    alignItems: "center",
    gap: 6,
    cursor: "pointer",
    color: "rgba(255,255,255,0.78)",
    fontSize: 14,
  },
  select: {
    padding: "10px 12px",
    borderRadius: 8,
    border: "1px solid rgba(255,255,255,0.14)",
    background: "rgba(255,255,255,0.07)",
    color: "#ffffff",
    fontSize: 14,
    outline: "none",
  },
  checkboxGroup: {
    display: "flex",
    flexWrap: "wrap",
    gap: 10,
  },
  chip: {
    display: "inline-flex",
    alignItems: "center",
    padding: "7px 14px",
    borderRadius: 20,
    border: "1px solid rgba(255,255,255,0.16)",
    background: "rgba(255,255,255,0.05)",
    color: "rgba(255,255,255,0.7)",
    fontSize: 13.5,
    cursor: "pointer",
    userSelect: "none",
    transition: "all 0.15s",
  },
  chipActive: {
    display: "inline-flex",
    alignItems: "center",
    padding: "7px 14px",
    borderRadius: 20,
    border: "1px solid rgba(139,92,246,0.7)",
    background: "rgba(124,58,237,0.28)",
    color: "#ffffff",
    fontSize: 13.5,
    cursor: "pointer",
    userSelect: "none",
    transition: "all 0.15s",
  },
  hiddenInput: {
    position: "absolute",
    opacity: 0,
    width: 0,
    height: 0,
  },
  actions: {
    display: "flex",
    gap: 12,
    marginTop: 6,
  },
  btn: {
    flex: 1,
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    gap: 8,
    padding: "12px 20px",
    background: "linear-gradient(135deg, #7c3aed, #6d28d9)",
    border: "none",
    borderRadius: 8,
    color: "#ffffff",
    fontSize: 15,
    fontWeight: 600,
    cursor: "pointer",
    boxShadow: "0 4px 22px rgba(124,58,237,0.42)",
  },
  btnGhost: {
    flex: "0 0 auto",
    padding: "12px 20px",
    background: "transparent",
    border: "1px solid rgba(255,255,255,0.2)",
    borderRadius: 8,
    color: "rgba(255,255,255,0.7)",
    fontSize: 15,
    fontWeight: 500,
    cursor: "pointer",
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
    marginTop: 44,
    fontSize: 13,
    color: "rgba(255,255,255,0.32)",
  },
};

export default UpdateSkill;
