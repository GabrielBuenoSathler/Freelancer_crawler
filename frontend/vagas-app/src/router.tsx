
import { BrowserRouter, Routes, Route } from "react-router-dom";
import App from './App.tsx'; 
import Form from './Form.tsx';
import Form_Skill from './Form_Skill.tsx'

function AppRouter() { // Nome alterado para evitar conflito
  return (
    <BrowserRouter>
      <Routes> {/* O correto é Routes, não Router */}
        <Route path="/" element={<App />} />
        <Route path="/Form" element={<Form />} />  
        <Route path="/Form_Skill" element={<Form_Skill />} />
      </Routes>
    </BrowserRouter>
  );
}
  
export default AppRouter;
