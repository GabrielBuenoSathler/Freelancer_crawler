import { useState } from "react";
import { useNavigate } from "react-router-dom";

const API = import.meta.env.VITE_API_URL ?? "";

function Register() {
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      // Step 1: Create user
      const signupResponse = await fetch(`${API}/users/`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          username,
          email,
          password,
        }),
      });

      if (!signupResponse.ok) {
        throw new Error("Erro ao cadastrar usuário");
      }

      // Step 2: Auto-login user
      const loginResponse = await fetch(`${API}/token`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({
          username: email,
          password,
        }),
      });

      if (!loginResponse.ok) {
        throw new Error("Erro ao fazer login");
      }

      const loginData = await loginResponse.json();
      localStorage.setItem("access_token", loginData.access_token);
      localStorage.setItem("email", email);

      navigate("/register-skill");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Erro ao cadastrar");
      console.error(err);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div style={styles.container}>
      <div style={styles.card}>
        <h2 style={styles.title}>Cadastro</h2>

        <form onSubmit={handleSubmit} style={styles.form}>
          <div style={styles.field}>
            <label style={styles.label}>Nome</label>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Digite seu nome"
              style={styles.input}
              required
            />
          </div>

          <div style={styles.field}>
            <label style={styles.label}>Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="seu@email.com"
              style={styles.input}
              required
            />
          </div>

          <div style={styles.field}>
            <label style={styles.label}>Senha</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Crie uma senha segura"
              style={styles.input}
              required
            />
          </div>

          {error && <p style={styles.error}>{error}</p>}

          <button
            type="submit"
            style={styles.button}
            disabled={loading}
          >
            {loading ? "Cadastrando..." : "Cadastrar"}
          </button>
        </form>

        <p style={styles.link}>
          Já tem conta? <a href="/login" style={styles.anchor}>Faça login</a>
        </p>
      </div>
    </div>
  );
}

const styles: Record<string, React.CSSProperties> = {
  container: {
    minHeight: "100vh",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    background: "linear-gradient(135deg, #0d0b1e 0%, #1a0b3b 50%, #0e1b2e 100%)",
    padding: "20px",
    fontFamily: "'Segoe UI', system-ui, sans-serif",
  },
  card: {
    background: "rgba(255,255,255,0.05)",
    border: "1px solid rgba(139,92,246,0.28)",
    borderRadius: 16,
    padding: "40px",
    width: "100%",
    maxWidth: 400,
    backdropFilter: "blur(12px)",
  },
  title: {
    fontSize: 28,
    fontWeight: 700,
    color: "#ffffff",
    margin: "0 0 32px",
    textAlign: "center",
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
    fontSize: 13,
    fontWeight: 600,
    color: "rgba(255,255,255,0.75)",
    textTransform: "uppercase",
    letterSpacing: "0.5px",
  },
  input: {
    padding: "10px 12px",
    borderRadius: 8,
    border: "1px solid rgba(139,92,246,0.3)",
    background: "rgba(255,255,255,0.08)",
    color: "#ffffff",
    fontSize: 14,
    fontFamily: "inherit",
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
  error: {
    color: "#ff6b6b",
    fontSize: 13,
    margin: 0,
  },
  link: {
    textAlign: "center",
    fontSize: 13,
    color: "rgba(255,255,255,0.6)",
    margin: "24px 0 0",
  },
  anchor: {
    color: "#7c3aed",
    textDecoration: "none",
    fontWeight: 600,
  },
};

export default Register;
