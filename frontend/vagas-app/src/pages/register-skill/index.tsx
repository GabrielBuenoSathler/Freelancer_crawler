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
    <div style={styles.container}>
      <h2>Cadastro de Skills</h2>

      <form onSubmit={handleSubmit} style={styles.form}>
        <div style={styles.field}>
          <label style={styles.label}>Nível</label>
          <div style={styles.radioGroup}>
            {NIVEIS.map((op) => (
              <label key={op} style={styles.radioLabel}>
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

        <div style={styles.field}>
          <label style={styles.label}>Localização</label>
          <select
            value={localizacao}
            onChange={(e) => setLocalizacao(e.target.value)}
            style={styles.select}
          >
            <option value="">Selecione...</option>
            {LOCALIZACOES.map((op) => (
              <option key={op} value={op}>
                {op}
              </option>
            ))}
          </select>
        </div>

        <div style={styles.field}>
          <label style={styles.label}>Idiomas</label>
          <div style={styles.checkboxGroup}>
            {IDIOMAS_OPCOES.map((op) => (
              <label key={op} style={styles.checkboxLabel}>
                <input
                  type="checkbox"
                  checked={idiomas.includes(op)}
                  onChange={() => setIdiomas(toggleItem(idiomas, op))}
                />
                {op}
              </label>
            ))}
          </div>
        </div>

        <div style={styles.field}>
          <label style={styles.label}>Skills</label>
          <div style={styles.checkboxGroup}>
            {SKILLS_OPCOES.map((op) => (
              <label key={op} style={styles.checkboxLabel}>
                <input
                  type="checkbox"
                  checked={skills.includes(op)}
                  onChange={() => setSkills(toggleItem(skills, op))}
                />
                {op}
              </label>
            ))}
          </div>
        </div>

        <button type="submit" style={styles.button}>
          Cadastrar
        </button>
      </form>
    </div>
  );
}

const styles: Record<string, React.CSSProperties> = {
  container: {
    maxWidth: 480,
    margin: "40px auto",
    padding: 20,
    border: "1px solid #ddd",
    borderRadius: 8,
    fontFamily: "Arial",
  },
  form: {
    display: "flex",
    flexDirection: "column",
    gap: 16,
  },
  field: {
    display: "flex",
    flexDirection: "column",
    gap: 6,
  },
  label: {
    fontWeight: "bold",
  },
  radioGroup: {
    display: "flex",
    gap: 16,
  },
  radioLabel: {
    display: "flex",
    alignItems: "center",
    gap: 4,
    cursor: "pointer",
  },
  select: {
    padding: "6px 8px",
    borderRadius: 4,
    border: "1px solid #ccc",
    fontSize: 14,
  },
  checkboxGroup: {
    display: "flex",
    flexWrap: "wrap",
    gap: 10,
  },
  checkboxLabel: {
    display: "flex",
    alignItems: "center",
    gap: 4,
    cursor: "pointer",
  },
  button: {
    marginTop: 10,
    padding: 10,
    backgroundColor: "#007bff",
    color: "#fff",
    border: "none",
    borderRadius: 5,
    cursor: "pointer",
  },
};

export default RegisterSkill;
