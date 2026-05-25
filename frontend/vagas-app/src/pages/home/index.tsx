import { useState } from "react";
import { useNavigate } from "react-router-dom";

const API = import.meta.env.VITE_API_URL ?? "";

function Home() {
  const navigate = useNavigate();

  const [loginEmail, setLoginEmail] = useState("");
  const [loginPassword, setLoginPassword] = useState("");
  const [showLoginPwd, setShowLoginPwd] = useState(false);
  const [loginLoading, setLoginLoading] = useState(false);

  const [registerEmail, setRegisterEmail] = useState("");
  const [registerPassword, setRegisterPassword] = useState("");
  const [showRegisterPwd, setShowRegisterPwd] = useState(false);
  const [registerLoading, setRegisterLoading] = useState(false);

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault();
    setLoginLoading(true);
    try {
      const body = new URLSearchParams();
      body.append("username", loginEmail);
      body.append("password", loginPassword);

      const res = await fetch(`${API}/token`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body,
      });

      if (!res.ok) throw new Error("Credenciais inválidas");

      const data = await res.json();
      localStorage.setItem("access_token", data.access_token);
      localStorage.setItem("email", loginEmail);
      navigate("/vagas");
    } catch {
      alert("E-mail ou senha incorretos.");
    } finally {
      setLoginLoading(false);
    }
  }

  async function handleRegister(e: React.FormEvent) {
    e.preventDefault();
    setRegisterLoading(true);
    try {
      const username = registerEmail.split("@")[0];
      const res = await fetch(`${API}/users/`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, email: registerEmail, password: registerPassword }),
      });

      if (!res.ok) throw new Error("Erro ao criar conta");

      // Auto-login after registration
      const loginRes = await fetch(`${API}/token`, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          username: registerEmail,
          password: registerPassword,
        }),
      });

      if (!loginRes.ok) throw new Error("Erro ao fazer login");

      const loginData = await loginRes.json();
      localStorage.setItem("access_token", loginData.access_token);
      localStorage.setItem("email", registerEmail);

      navigate("/register-skill");
    } catch {
      alert("Erro ao criar conta. Tente novamente.");
    } finally {
      setRegisterLoading(false);
    }
  }

  return (
    <div style={s.page}>
      <div style={{ ...s.orb, top: -120, left: -120, width: 450, height: 450, background: "rgba(124,58,237,0.28)" }} />
      <div style={{ ...s.orb, bottom: -80, right: 60, width: 320, height: 320, background: "rgba(109,40,217,0.22)" }} />
      <div style={{ ...s.orb, top: "38%", right: -80, width: 280, height: 280, background: "rgba(139,92,246,0.16)" }} />

      <div style={s.container}>
        {/* Header */}
        <div style={s.header}>
          <div style={s.logoCircle}>
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2.5" strokeLinecap="round">
              <circle cx="11" cy="11" r="8" />
              <line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
          </div>
          <h1 style={s.title}>Freelance Finder</h1>
          <p style={s.subtitle}>
            Encontre oportunidades freelance que combinem com seu talento<br />
            e leve sua carreira para o próximo nível.
          </p>
        </div>

        {/* Cards */}
        <div style={s.cards}>
          {/* Login */}
          <div style={s.card}>
            <div style={s.cardIconCircle}>
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2" strokeLinecap="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                <circle cx="12" cy="7" r="4" />
              </svg>
            </div>
            <h2 style={s.cardTitle}>Login</h2>
            <p style={s.cardSubtitle}>Bem-vindo de volta! Faça login para continuar.</p>

            <form onSubmit={handleLogin} style={s.form}>
              <div style={s.field}>
                <label style={s.label}>E-mail</label>
                <input
                  type="email"
                  value={loginEmail}
                  onChange={(e) => setLoginEmail(e.target.value)}
                  placeholder="seu@email.com"
                  required
                  style={s.input}
                />
              </div>

              <div style={s.field}>
                <label style={s.label}>Senha</label>
                <div style={s.inputWrap}>
                  <input
                    type={showLoginPwd ? "text" : "password"}
                    value={loginPassword}
                    onChange={(e) => setLoginPassword(e.target.value)}
                    placeholder="Sua senha"
                    required
                    style={{ ...s.input, paddingRight: 42 }}
                  />
                  <button type="button" onClick={() => setShowLoginPwd(!showLoginPwd)} style={s.eyeBtn}>
                    {showLoginPwd ? (
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94" />
                        <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19" />
                        <line x1="1" y1="1" x2="23" y2="23" />
                      </svg>
                    ) : (
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                        <circle cx="12" cy="12" r="3" />
                      </svg>
                    )}
                  </button>
                </div>
              </div>

              <a href="#" style={s.forgot}>Esqueceu sua senha?</a>

              <button type="submit" style={s.btn} disabled={loginLoading}>
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round">
                  <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4" />
                  <polyline points="10 17 15 12 10 7" />
                  <line x1="15" y1="12" x2="3" y2="12" />
                </svg>
                {loginLoading ? "Entrando..." : "Entrar"}
              </button>
            </form>
          </div>

          {/* Register */}
          <div style={s.card}>
            <div style={s.cardIconCircle}>
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2" strokeLinecap="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                <circle cx="12" cy="7" r="4" />
              </svg>
            </div>
            <h2 style={s.cardTitle}>Criar conta</h2>
            <p style={s.cardSubtitle}>Crie sua conta e comece a encontrar projetos.</p>

            <form onSubmit={handleRegister} style={s.form}>
              <div style={s.field}>
                <label style={s.label}>E-mail</label>
                <input
                  type="email"
                  value={registerEmail}
                  onChange={(e) => setRegisterEmail(e.target.value)}
                  placeholder="seu@email.com"
                  required
                  style={s.input}
                />
              </div>

              <div style={s.field}>
                <label style={s.label}>Senha</label>
                <div style={s.inputWrap}>
                  <input
                    type={showRegisterPwd ? "text" : "password"}
                    value={registerPassword}
                    onChange={(e) => setRegisterPassword(e.target.value)}
                    placeholder="Mínimo de 6 caracteres"
                    required
                    minLength={6}
                    style={{ ...s.input, paddingRight: 42 }}
                  />
                  <button type="button" onClick={() => setShowRegisterPwd(!showRegisterPwd)} style={s.eyeBtn}>
                    {showRegisterPwd ? (
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94" />
                        <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19" />
                        <line x1="1" y1="1" x2="23" y2="23" />
                      </svg>
                    ) : (
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                        <circle cx="12" cy="12" r="3" />
                      </svg>
                    )}
                  </button>
                </div>
              </div>

              <button type="submit" style={{ ...s.btn, marginTop: 16 }} disabled={registerLoading}>
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round">
                  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                  <circle cx="12" cy="7" r="4" />
                </svg>
                {registerLoading ? "Criando..." : "Criar conta"}
              </button>

              <p style={s.terms}>
                Ao criar uma conta, você concorda com nossos{" "}
                <a href="#" style={s.termsLink}>Termos de Uso</a> e{" "}
                <a href="#" style={s.termsLink}>Política de Privacidade</a>.
              </p>
            </form>
          </div>
        </div>

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
    alignItems: "center",
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
    maxWidth: 920,
    padding: "48px 20px",
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
  cards: {
    display: "flex",
    gap: 24,
    justifyContent: "center",
    flexWrap: "wrap",
  },
  card: {
    flex: "1 1 340px",
    maxWidth: 420,
    background: "rgba(255,255,255,0.05)",
    border: "1px solid rgba(139,92,246,0.28)",
    borderRadius: 18,
    padding: "32px 28px",
    backdropFilter: "blur(12px)",
  },
  cardIconCircle: {
    width: 50,
    height: 50,
    borderRadius: "50%",
    background: "rgba(124,58,237,0.28)",
    border: "1px solid rgba(139,92,246,0.45)",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    marginBottom: 16,
  },
  cardTitle: {
    fontSize: 22,
    fontWeight: 600,
    color: "#ffffff",
    margin: "0 0 6px",
  },
  cardSubtitle: {
    fontSize: 13.5,
    color: "rgba(255,255,255,0.52)",
    margin: "0 0 24px",
    lineHeight: 1.55,
  },
  form: {
    display: "flex",
    flexDirection: "column",
    gap: 14,
  },
  field: {
    display: "flex",
    flexDirection: "column",
    gap: 6,
  },
  label: {
    fontSize: 13.5,
    fontWeight: 500,
    color: "rgba(255,255,255,0.72)",
  },
  inputWrap: {
    position: "relative",
  },
  input: {
    width: "100%",
    padding: "10px 14px",
    background: "rgba(255,255,255,0.07)",
    border: "1px solid rgba(255,255,255,0.14)",
    borderRadius: 8,
    color: "#ffffff",
    fontSize: 14,
    outline: "none",
    boxSizing: "border-box",
    transition: "border-color 0.2s",
  },
  eyeBtn: {
    position: "absolute",
    right: 12,
    top: "50%",
    transform: "translateY(-50%)",
    background: "none",
    border: "none",
    cursor: "pointer",
    color: "rgba(255,255,255,0.45)",
    padding: 0,
    display: "flex",
    alignItems: "center",
  },
  forgot: {
    fontSize: 13,
    color: "rgba(167,139,250,0.88)",
    textDecoration: "none",
    textAlign: "right",
    display: "block",
    marginTop: -4,
  },
  btn: {
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
  terms: {
    fontSize: 12,
    color: "rgba(255,255,255,0.4)",
    textAlign: "center",
    lineHeight: 1.65,
    margin: "4px 0 0",
  },
  termsLink: {
    color: "rgba(167,139,250,0.78)",
    textDecoration: "underline",
  },
  footer: {
    textAlign: "center",
    marginTop: 44,
    fontSize: 13,
    color: "rgba(255,255,255,0.32)",
  },
};

export default Home;
