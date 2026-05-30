import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from './pages/home';
import Register from './pages/register';
import RegisterSkill from './pages/register-skill';
import Login from './pages/login';
import Vagas from './pages/vagas';
import UpdateSkill from './pages/update-skill';

function AppRouter() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/register" element={<Register />} />
        <Route path="/register-skill" element={<RegisterSkill />} />
        <Route path="/login" element={<Login />} />
        <Route path="/vagas" element={<Vagas />} />
        <Route path="/update-skill" element={<UpdateSkill />} />
      </Routes>
    </BrowserRouter>
  );
}

export default AppRouter;
