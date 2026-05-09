import { useState } from "react";

function Form_Skill() {
  const [username, setUsername] = useState("");
  const [nivel, setNivel] = useState("");
  const [localizacao, setLocalizacao] = useState("");
  const [idiomas, setIdiomas] = useState("");
  const [skill, setSkill] = useState("");

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();

    const dados = {
      username,
      nivel,
      localizacao,
      idiomas,
      skill,
    };

    try {
      const response = await fetch("http://127.0.0.1:8000/user_profile", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(dados),
      });

      const data = await response.json();

      console.log("Resposta do backend:", data);
      alert("Dados enviados com sucesso!");
    } catch (error) {
      console.error("Erro ao enviar dados:", error);
      alert("Erro ao enviar dados");
    }

    // limpar formulário
    setUsername("");
    setNivel("");
    setLocalizacao("");
    setIdiomas("");
    setSkill("");
  }

  return (
    <div style={styles.container}>
      <h2>Cadastro de Skills</h2>

      <form onSubmit={handleSubmit} style={styles.form}>
        <div style={styles.field}>
          <label>Username</label>
          <input
            type="text"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            placeholder="Digite o username"
          />
        </div>

        <div style={styles.field}>
          <label>Nível</label>
          <input
            type="text"
            value={nivel}
            onChange={(e) => setNivel(e.target.value)}
            placeholder="Ex: Júnior, Pleno, Sênior"
          />
        </div>

        <div style={styles.field}>
          <label>Localização</label>
          <input
            type="text"
            value={localizacao}
            onChange={(e) => setLocalizacao(e.target.value)}
            placeholder="Ex: Brasil"
          />
        </div>

        <div style={styles.field}>
          <label>Idiomas</label>
          <input
            type="text"
            value={idiomas}
            onChange={(e) => setIdiomas(e.target.value)}
            placeholder="Ex: Português, Inglês"
          />
        </div>

        <div style={styles.field}>
          <label>Skill</label>
          <input
            type="text"
            value={skill}
            onChange={(e) => setSkill(e.target.value)}
            placeholder="Ex: Python, React"
          />
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
    maxWidth: 400,
    margin: "40px auto",
    padding: 20,
    border: "1px solid #ddd",
    borderRadius: 8,
    fontFamily: "Arial",
  },
  form: {
    display: "flex",
    flexDirection: "column",
    gap: 12,
  },
  field: {
    display: "flex",
    flexDirection: "column",
    gap: 4,
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

export default Form_Skill;
