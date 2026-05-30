--
-- PostgreSQL database dump
--

\restrict Pw3H26gxLfInCDXPZgLAXhafEAW4RpiVleOUP8ISEdRoVPbYPkqBJ1GWhhY2DOa

-- Dumped from database version 15.18
-- Dumped by pg_dump version 15.18

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.user_profile DROP CONSTRAINT IF EXISTS user_profile_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.user_profile DROP CONSTRAINT IF EXISTS user_profile_pkey;
ALTER TABLE IF EXISTS ONLY public.freelas DROP CONSTRAINT IF EXISTS freelas_titulo_key;
ALTER TABLE IF EXISTS ONLY public.freelas DROP CONSTRAINT IF EXISTS freelas_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN user_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_profile ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.freelas ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_user_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.user_profile_id_seq;
DROP TABLE IF EXISTS public.user_profile;
DROP SEQUENCE IF EXISTS public.freelas_id_seq;
DROP TABLE IF EXISTS public.freelas;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: freelas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.freelas (
    id integer NOT NULL,
    titulo character varying(500) NOT NULL,
    link character varying(500),
    plataforma character varying(100),
    descricao text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: freelas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.freelas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.freelas_id_seq OWNED BY public.freelas.id;


--
-- Name: user_profile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_profile (
    id integer NOT NULL,
    user_id integer,
    username character varying(255),
    nivel character varying(100),
    localizacao character varying(255),
    idiomas character varying(255),
    skill character varying(255)
);


--
-- Name: user_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_profile_id_seq OWNED BY public.user_profile.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL
);


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: freelas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelas ALTER COLUMN id SET DEFAULT nextval('public.freelas_id_seq'::regclass);


--
-- Name: user_profile id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_profile ALTER COLUMN id SET DEFAULT nextval('public.user_profile_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: freelas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.freelas (id, titulo, link, plataforma, descricao, created_at) FROM stdin;
5689	Desenvolvedor Unity: Protótipo de jogo 2D (shoot 'em up)	https://www.99freelas.com.br/project/desenvolvedor-unity-prototipo-de-jogo-2d-shoot-apos-em-up-757051?fs=t	99Freelas	\N	2026-05-30 18:41:02.677457
7	Plataforma SaaS multi-cidades e multi-lojas para delivery	https://www.99freelas.com.br/project/plataforma-saas-multi-cidades-e-multi-lojas-para-delivery-756895?fs=t	99Freelas	\N	2026-05-29 21:50:13.043001
8	Criação de plataforma de cursos	https://www.99freelas.com.br/project/criacao-de-plataforma-de-cursos-756891?fs=t	99Freelas	\N	2026-05-29 21:50:13.044668
9	Criar landing page de portfólio	https://www.99freelas.com.br/project/criar-landing-page-de-portfolio-756875?fs=t	99Freelas	\N	2026-05-29 21:50:13.046352
11	Sistema de coleta e organização de dados para laudos imobiliários	https://www.99freelas.com.br/project/sistema-de-coleta-e-organizacao-de-dados-para-laudos-imobiliarios-756873?fs=t	99Freelas	\N	2026-05-29 21:50:13.050767
10	Criar agente de IA multifuncional para projeto educacional	https://www.99freelas.com.br/project/criar-agente-de-ia-multifuncional-para-projeto-educacional-756877?fs=t	99Freelas	\N	2026-05-29 21:50:13.048448
5690	Criação de landing pages e sites para médicos e clínicas	https://www.99freelas.com.br/project/criacao-de-landing-pages-e-sites-para-medicos-e-clinicas-757042?fs=t	99Freelas	\N	2026-05-30 18:41:02.679442
5683	Realizar acessos via PROX	https://www.99freelas.com.br/project/realizar-acessos-via-prox-757113?fs=t	99Freelas	\N	2026-05-30 18:41:02.664021
3706	Automação Completa do Crm Kommo para Otimização de Processos	https://www.workana.com/job/automacao-completa-do-crm-kommo-para-otimizacao-de-processos	Workana	Estamos buscando um profissional experiente para automatizar nosso CRM Kommo. Atualmente, utilizamos o Kommo para gerenciar nossos leads e processos de vendas, mas muitas tarefas ainda são realizadas manualmente. O objetivo principal é otimizar o fluxo de trabalho, reduzir a carga de trabalho manual e aumentar a eficiência operacional. Isso pode incluir a configuração de automações para: qualificação de leads, atribuição de tarefas, envio de e-mails e mensagens automáticas, integração com outras ferramentas (se necessário) e criação de relatórios automatizados. Buscamos um especialista que possa analisar nossos processos atuais, propor soluções de automação eficazes e implementá-las no Kommo, garantindo que o sistema funcione de forma fluida e integrada. É Fundamental ter conhecimento aprofundado da plataforma Kommo e suas capacidades de automação.	2026-05-30 02:20:14.709647
5687	Criação de site de autor e venda de livros em Shopify (PT/EN)	https://www.99freelas.com.br/project/criacao-de-site-de-autor-e-venda-de-livros-em-shopify-pt-en-757074?fs=t	99Freelas	\N	2026-05-30 18:41:02.673404
5688	Recuperação de conta do Google	https://www.99freelas.com.br/project/recuperacao-de-conta-do-google-757068?fs=t	99Freelas	\N	2026-05-30 18:41:02.675426
36	Software Startup Seeking Business Development Partner	https://www.freelancer.com/projects/automation/software-startup-seeking-business-development-partner	Freelancer	\N	2026-05-29 21:50:13.088365
37	Blu-ray Java Menu Update	https://www.freelancer.com/projects/automation/blu-ray-java-menu-update	Freelancer	\N	2026-05-29 21:50:13.089596
12	Programador para criação e manutenção de sites	https://www.99freelas.com.br/project/programador-para-criacao-e-manutencao-de-sites-756864?fs=t	99Freelas	\N	2026-05-29 21:50:13.052589
5686	Verificar conectividade forte em grafo (Python)	https://www.99freelas.com.br/project/verificar-conectividade-forte-em-grafo-python-757103?fs=t	99Freelas	\N	2026-05-30 18:41:02.670982
38	Desktop Typing Tutor Application	https://www.freelancer.com/projects/automation/desktop-typing-tutor-application	Freelancer	\N	2026-05-29 21:50:13.090916
4	Corrigir erro causado pelo WooCommerce e atualizar plugins	https://www.99freelas.com.br/project/corrigir-erro-causado-pelo-woocommerce-e-atualizar-plugins-756923?fs=t	99Freelas	\N	2026-05-29 21:50:13.037948
5	Configuração de agentes de IA no OpenClaw para marketing	https://www.99freelas.com.br/project/configuracao-de-agentes-de-ia-no-openclaw-para-marketing-756900?fs=t	99Freelas	\N	2026-05-29 21:50:13.039516
5481	Desenvolvedor(a) Fullstack para Evolução de Plataforma Bikestyle.app (Remoto)	https://www.workana.com/job/desenvolvedora-fullstack-para-evolucao-de-plataforma-bikestyleapp-remoto	Workana	\N	2026-05-30 04:25:16.107799
6	Verificação de cibersegurança do sistema e emissão de relatório	https://www.99freelas.com.br/project/verificacao-de-ciberseguranca-do-sistema-e-emissao-de-relatorio-756906?fs=t	99Freelas	\N	2026-05-29 21:50:13.040907
1436	Especialista em Redes para Otimizar Conexão de Internet e Resolver Problemas de lag em Jogos Online	https://www.workana.com/job/especialista-em-redes-para-otimizar-conexao-de-internet-e-resolver-problemas-de-lag-em-jogos-online	Workana	Preciso de um técnico de redes qualificado para diagnosticar e resolver problemas de qualidade de internet que afetam severamente minha experiência em jogos online. Embora o ping pareça estável, a conexão apresenta variações drásticas que impossibilitam jogar em alto nível. Suspeito que a provedora de internet local, que é a única disponível no bairro e provavelmente redireciona sinal de uma empresa maior, esteja alterando as rotas de forma inconsistente, causando perda de pacotes intermitentes. Busco um profissional que possa analisar a infraestrutura da rede, identificar a causa raiz desses problemas de desempenho, e propor soluções eficazes. O trabalho pode envolver a comunicação com a provedora para discutir as rotas e configurações, além de otimizar as configurações da minha rede local para garantir uma conexão estável e de alta performance para jogos.	2026-05-29 23:35:12.907865
40	Web-based Forex Trading Platform	https://www.freelancer.com/projects/automation/web-based-forex-trading-platform	Freelancer	\N	2026-05-29 21:50:13.093603
41	Build Innovative Dental Clinic Management System	https://www.freelancer.com/projects/automation/build-innovative-dental-clinic-management-system	Freelancer	\N	2026-05-29 21:50:13.094823
39	3D Artist / 3D Modeler Needed to Create Realistic Human Body Twin for Healthcare Application	https://www.freelancer.com/projects/automation/3d-artist-3d-modeler-needed-to-create-realistic-human-body-twin-for-healthcare-application	Freelancer	\N	2026-05-29 21:50:13.09237
5691	Integração Adapta One (Expert) com WhatsApp Business e Meta	https://www.99freelas.com.br/project/integracao-adapta-one-expert-com-whatsapp-business-e-meta-757028?fs=t	99Freelas	\N	2026-05-30 18:41:02.681324
2	Publique um projeto. É grátis.	https://www.99freelas.com.br/project/new	99Freelas	\N	2026-05-29 21:50:13.033568
5692	Desenvolvedor Unity para jogo 2D estilo casual	https://www.99freelas.com.br/project/desenvolvedor-unity-para-jogo-2d-estilo-casual-757038?fs=t	99Freelas	\N	2026-05-30 18:41:02.683499
5684	Auditoria e pentest em intranet corporativa	https://www.99freelas.com.br/project/auditoria-e-pentest-em-intranet-corporativa-757110?fs=t	99Freelas	\N	2026-05-30 18:41:02.665995
5685	Ajustes e correções no aplicativo	https://www.99freelas.com.br/project/ajustes-e-correcoes-no-aplicativo-757109?fs=t	99Freelas	\N	2026-05-30 18:41:02.668269
23	Advanced Laravel 12.x Training	https://www.freelancer.com/projects/automation/advanced-laravel-12x-training	Freelancer	\N	2026-05-29 21:50:13.072416
34	Develop Comprehensive Tax Filing Platform	https://www.freelancer.com/projects/automation/develop-comprehensive-tax-filing-platform	Freelancer	\N	2026-05-29 21:50:13.086411
24	C++ Windows Feature Expansion - 29/05/2026 12:50 EDT	https://www.freelancer.com/projects/automation/c-windows-feature-expansion---29052026-1250-edt	Freelancer	\N	2026-05-29 21:50:13.07404
21	Desenvolvimento de Plataforma de Conversa Multi-canal com Integração Whatsapp e Instagram/Facebook	https://www.workana.com/job/desenvolvimento-de-plataforma-de-conversa-multi-canal-com-integracao-whatsapp-e-instagramfacebook	Workana	\N	2026-05-29 21:50:13.068321
22	Fix Claude Subscription Activation Failure -- 2	https://www.freelancer.com/projects/automation/fix-claude-subscription-activation-failure----2	Freelancer	\N	2026-05-29 21:50:13.070022
25	Senior .Net Engineer	https://www.freelancer.com/projects/automation/senior-net-engineer	Freelancer	\N	2026-05-29 21:50:13.075389
6038	Criação de template personalizado no Notion	https://www.99freelas.com.br/project/criacao-de-template-personalizado-no-notion-757119?fs=t	99Freelas	\N	2026-05-30 19:10:12.596055
5896	Integração Make, Airtable e WhatsApp	https://www.99freelas.com.br/project/integracao-make-airtable-e-whatsapp-757118?fs=t	99Freelas	\N	2026-05-30 18:55:21.958471
26	Contract Communication Representative	https://www.freelancer.com/projects/automation/contract-communication-representative	Freelancer	\N	2026-05-29 21:50:13.076541
27	Carbon Calculator for Hostel Students	https://www.freelancer.com/projects/automation/carbon-calculator-for-hostel-students	Freelancer	\N	2026-05-29 21:50:13.077748
28	Need assist in 2027 Medicare Carrier & SMID Approvals	https://www.freelancer.com/projects/automation/need-assist-in-2027-medicare-carrier-smid-approvals	Freelancer	\N	2026-05-29 21:50:13.078895
29	Finish & Explain Basic Python	https://www.freelancer.com/projects/automation/finish-explain-basic-python	Freelancer	\N	2026-05-29 21:50:13.080384
35	Odoo 18 Community Invoice Format Customization as per Saudi ZATCA Rules	https://www.freelancer.com/projects/automation/odoo-18-community-invoice-format-customization-as-per-saudi-zatca-rules	Freelancer	\N	2026-05-29 21:50:13.087221
1932	Desenvolvimento de Plataforma Educacional Online Interativa para Web e Aplicativos Móveis	https://www.workana.com/job/desenvolvimento-de-plataforma-educacional-online-interativa-para-web-e-aplicativos-moveis	Workana	Busco um freelancer ou equipe para desenvolver uma plataforma de escola online completa, que inclua tanto um website quanto aplicativos móveis (iOS e Android). O foco principal é a criação de um ambiente pedagógico interativo e envolvente para os alunos, com funcionalidades que remetam a ferramentas como Kahoot, Quizlet e Ellii. Para os professores, a plataforma deve oferecer facilidade na designação de tarefas, apresentação de aulas e atividades, acompanhamento do progresso dos alunos e envio. A solução deve ser robusta, escalável e intuitiva, garantindo uma experiência de usuário fluida para todos os envolvidos. As atividades interativas podem incluir quizzes, gravação de audios (tarefas de apresentação/resposta), exercícios de arrastar e soltar, e outras dinâmicas que promovam o aprendizado ativo. A gestão de conteúdo e usuários são funcionalidades essenciais.	2026-05-30 00:15:14.492326
30	Luna AI Shopping Assistant Development	https://www.freelancer.com/projects/automation/luna-ai-shopping-assistant-development	Freelancer	\N	2026-05-29 21:50:13.081966
31	Corporate Digital Product Creation	https://www.freelancer.com/projects/automation/corporate-digital-product-creation	Freelancer	\N	2026-05-29 21:50:13.083732
32	Need Expert Node.js + Socket.IO + Agora Developer for Realtime Consultation App	https://www.freelancer.com/projects/automation/need-expert-nodejs-socketio-agora-developer-for-realtime-consultation-app	Freelancer	\N	2026-05-29 21:50:13.084812
725	Desenvolvimento de Jogo Online de Tiro Multiplataforma com Gráficos de Alta Qualidade	https://www.workana.com/job/desenvolvimento-de-jogo-online-de-tiro-multiplataforma-com-graficos-de-alta-qualidade	Workana	Estamos buscando um desenvolvedor ou equipe experiente para criar um jogo online de tiro de elite. O objetivo é desenvolver um título inovador e altamente envolvente, compatível com diversas plataformas (mobile e web), que apresente gráficos incríveis e uma jogabilidade fluida. O jogo deve ser projetado para atrair uma vasta audiência e ter um forte potencial de monetização. Buscamos profissionais com expertise em desenvolvimento de jogos, programação de mecânicas de tiro, otimização para diferentes dispositivos e implementação de funcionalidades online robustas. A experiência com motores de jogo como Unity 3D é essencial, assim como conhecimento em desenvolvimento backend para suportar a infraestrutura online do jogo.	2026-05-29 22:40:14.44916
33	Finish Windows .NET WPF Timekeeping Client with Idle Detection	https://www.freelancer.com/projects/automation/finish-windows-net-wpf-timekeeping-client-with-idle-detection	Freelancer	\N	2026-05-29 21:50:13.085657
62	Cross-Platform ML/AI IDE Development	https://www.freelancer.com/projects/automation/cross-platform-mlai-ide-development	Freelancer	\N	2026-05-29 21:50:13.12509
2358	Desenvolvimento de Agente Local de Impressão em Go (Golang) para Saas Sysloja	https://www.workana.com/job/desenvolvimento-de-agente-local-de-impressao-em-go-golang-para-saas-sysloja	Workana	O objetivo deste projeto é construir um agente local de impressão que funcione como um serviço em segundo plano no PC do caixa ou recepção do estabelecimento. Este agente permitirá que a aplicação web SaaS Sysloja, acessível emhttps://sysloja.app.br, imprima cupons fiscais, comandas de cozinha/bar e pré-contas. A impressão deve ser realizada em impressoras térmicas esc/pos conectadas via rede local (tcp/ip), usb ou serial, sem depender do diálogo de impressão padrão do navegador. O agente deve ser equivalente aos utilizados por sistemas como iFood Consumer, Colibri, Linx Degust e ControlPay. A linguagem de desenvolvimento escolhida e não negociável é Go (Golang).	2026-05-30 00:45:13.053279
67	Experienced Developer for Vibe coding project	https://www.freelancer.com/projects/automation/experienced-developer-for-vibe-coding-project	Freelancer	\N	2026-05-29 21:50:13.132244
48	Immediate Stock Algo Trading App	https://www.freelancer.com/projects/automation/immediate-stock-algo-trading-app	Freelancer	\N	2026-05-29 21:50:13.104706
61	Raspberry Pi Satellite Hotspot Software	https://www.freelancer.com/projects/automation/raspberry-pi-satellite-hotspot-software	Freelancer	\N	2026-05-29 21:50:13.123317
1	Publicar projeto	https://www.99freelas.com.br/project/new	99Freelas	\N	2026-05-29 21:50:13.027935
43	Leaddyno & OMS Workflow Setup	https://www.freelancer.com/projects/automation/leaddyno-oms-workflow-setup	Freelancer	\N	2026-05-29 21:50:13.097603
56	kyc intigration	https://www.freelancer.com/projects/automation/kyc-intigration	Freelancer	\N	2026-05-29 21:50:13.115745
44	Set Up LeadDyno Workflow	https://www.freelancer.com/projects/automation/set-up-leaddyno-workflow	Freelancer	\N	2026-05-29 21:50:13.098882
46	Django REST API Development	https://www.freelancer.com/projects/automation/django-rest-api-development	Freelancer	\N	2026-05-29 21:50:13.101722
6251	Integração Make, Airtable e API do WhatsApp	https://www.99freelas.com.br/project/integracao-make-airtable-e-api-do-whatsapp-757118?fs=t	99Freelas	\N	2026-05-30 19:25:13.12442
71	Advanced Fuel Compliance & Reconciliation Software	https://www.freelancer.com/projects/automation/advanced-fuel-compliance-reconciliation-software	Freelancer	\N	2026-05-29 21:50:13.138499
2365	Traditional Wear ERP & Billing	https://www.freelancer.com/projects/automation/traditional-wear-erp-billing	Freelancer	\N	2026-05-30 00:45:13.058486
3	Migração para Azure - 39 servidores	https://www.99freelas.com.br/project/migracao-para-azure-39-servidores-756964?fs=t	99Freelas	\N	2026-05-29 21:50:13.036117
42	Improve LeOS I/O & Docs	https://www.freelancer.com/projects/automation/improve-leos-io-docs	Freelancer	\N	2026-05-29 21:50:13.096283
51	Desktop Accounting Software Development	https://www.freelancer.com/projects/automation/desktop-accounting-software-development	Freelancer	\N	2026-05-29 21:50:13.108321
52	Power App Workflow Automation	https://www.freelancer.com/projects/automation/power-app-workflow-automation	Freelancer	\N	2026-05-29 21:50:13.109851
57	Fix Crashes in VB.NET App	https://www.freelancer.com/projects/automation/fix-crashes-in-vbnet-app	Freelancer	\N	2026-05-29 21:50:13.117268
58	SS7 <-> SMPP Gateway Using JSS7	https://www.freelancer.com/projects/automation/ss7---smpp-gateway-using-jss7	Freelancer	\N	2026-05-29 21:50:13.118808
53	Tradify Customization Expert	https://www.freelancer.com/projects/automation/tradify-customization-expert	Freelancer	\N	2026-05-29 21:50:13.111353
54	AMX NetLinx-KNX Integration	https://www.freelancer.com/projects/automation/amx-netlinx-knx-integration	Freelancer	\N	2026-05-29 21:50:13.112822
55	Surepass KYC Production Integration	https://www.freelancer.com/projects/automation/surepass-kyc-production-integration	Freelancer	\N	2026-05-29 21:50:13.114298
59	Python Student Management System	https://www.freelancer.com/projects/automation/python-student-management-system	Freelancer	\N	2026-05-29 21:50:13.120199
63	Stripe-to-Elorus Receipt Issuance Automation	https://www.freelancer.com/projects/automation/stripe-to-elorus-receipt-issuance-automation	Freelancer	\N	2026-05-29 21:50:13.126582
64	Lifetime Windows IPTV Editor	https://www.freelancer.com/projects/automation/lifetime-windows-iptv-editor	Freelancer	\N	2026-05-29 21:50:13.127846
65	QuickBooks-Simpro Integration & Automation	https://www.freelancer.com/projects/automation/quickbooks-simpro-integration-automation	Freelancer	\N	2026-05-29 21:50:13.12922
68	Private project or contest #40473180	https://www.freelancer.com/projects/automation/private-project-or-contest-40473180	Freelancer	\N	2026-05-29 21:50:13.133919
70	EU Developer for E-Commerce Software	https://www.freelancer.com/projects/automation/eu-developer-for-e-commerce-software	Freelancer	\N	2026-05-29 21:50:13.136996
49	Fix Surepass Production KYC Integration	https://www.freelancer.com/projects/automation/fix-surepass-production-kyc-integration	Freelancer	\N	2026-05-29 21:50:13.105972
60	Python Bug Fix & AWS Deploy	https://www.freelancer.com/projects/automation/python-bug-fix-aws-deploy	Freelancer	\N	2026-05-29 21:50:13.121629
66	AI Career Guidance Web App	https://www.freelancer.com/projects/automation/ai-career-guidance-web-app	Freelancer	\N	2026-05-29 21:50:13.130688
6252	Acessos via proxy para análise e inteligência jurídica	https://www.99freelas.com.br/project/acessos-via-proxy-para-analise-e-inteligencia-juridica-757113?fs=t	99Freelas	\N	2026-05-30 19:25:13.127063
50	Web App Onboarding Tutorial	https://www.freelancer.com/projects/automation/web-app-onboarding-tutorial	Freelancer	\N	2026-05-29 21:50:13.107123
47	Load Audio Files for Tonie Box	https://www.freelancer.com/projects/automation/load-audio-files-for-tonie-box	Freelancer	\N	2026-05-29 21:50:13.103325
45	Node-RED to Wago PLC Dashboard Fix	https://www.freelancer.com/projects/automation/node-red-to-wago-plc-dashboard-fix	Freelancer	\N	2026-05-29 21:50:13.100181
69	Technical Developer & Project Manager / Team Lead (Remote) -- 2	https://www.freelancer.com/projects/automation/technical-developer-project-manager-team-lead-remote----2	Freelancer	\N	2026-05-29 21:50:13.135592
5696	Especialista em Automações Integrações Datacrazy	https://www.workana.com/job/especialista-em-automacoes-integracoes-datacrazy	Workana	Estamos buscando um freelancer experiente para atuar como parceiro dando assistência na plataforma Datacrazy.Já temos algumas automações implementadas e precisamos de suporte contínuo para manutenção, otimização e desenvolvimento de novas funcionalidades.Buscamos um profissional que realmente tenha tempo disponível para eventuais duvidas, com flexibilidade para trabalhar por semana, por mês ou por hora, conforme a demanda. O profissional ideal terá conhecimento aprofundado em automação de processos e integração de sistemas, com foco em garantir a eficiência e a estabilidade das nossas operações no Datacrazy.	2026-05-30 18:41:02.691775
145	Integrar site Lovable com GitHub e Vercel	https://www.99freelas.com.br/project/integrar-site-lovable-com-github-e-vercel-756992?fs=t	99Freelas	\N	2026-05-29 22:00:15.898919
16	Criação de Loja Online de Roupas Femininas de Desapego Sustentável	https://www.workana.com/job/criacao-de-loja-online-de-roupas-femininas-de-desapego-sustentavel	Workana	Busco um profissional para desenvolver uma loja online de roupas femininas no formato de 'desapego'. O objetivo é criar uma plataforma e-commerce funcional e esteticamente agradável para a venda de peças semi-novas, bem cuidadas e com estilo. A proposta do projeto é promover a união entre elegância, economia e sustentabilidade, permitindo que as clientes renovem seus guarda-roupas com itens de qualidade a preços acessíveis. A loja deve ser intuitiva, fácil de navegar e otimizada para dispositivos móveis, garantindo uma excelente experiência de compra para as usuárias. É Essencial que a plataforma inclua funcionalidades como catálogo de produtos com fotos de alta qualidade, descrições detalhadas, sistema de carrinho de compras, opções de pagamento seguras e gestão de pedidos. O design deve refletir o conceito de estilo e cuidado com as peças, atraindo o público-alvo interessado em moda consciente.	2026-05-29 21:50:13.059535
19	Desenvolvimento de Sistema de Automação de Mensagens com Ia para Whatsapp	https://www.workana.com/job/desenvolvimento-de-sistema-de-automacao-de-mensagens-com-ia-para-whatsapp	Workana	Estamos buscando um desenvolvedor ou equipe especializada para criar um sistema de automação de mensagens para WhatsApp, utilizando inteligência artificial. O objetivo é otimizar a comunicação com clientes e usuários, permitindo respostas automáticas e inteligentes a diversas consultas. O sistema deve ser capaz de compreender a intenção do usuário e fornecer informações relevantes de forma eficiente. Espera-se uma solução robusta, escalável e de fácil integração com a plataforma WhatsApp. As funcionalidades desejadas incluem: Respostas automáticas baseadas em IA, Processamento de Linguagem Natural (PLN) para entender as mensagens, Integração com a API do WhatsApp, Capacidade de aprender e melhorar as interações ao longo do tempo. O projeto visa aprimorar o atendimento ao cliente, automatizar processos de vendas ou suporte, e fornecer uma experiência de usuário aprimorada.	2026-05-29 21:50:13.06501
1578	Desenvolvimento e Estratégia de E-commerce para Vendas Online de Produtos	https://www.workana.com/job/desenvolvimento-e-estrategia-de-e-commerce-para-vendas-online-de-produtos	Workana	O projeto visa o desenvolvimento e implementação de uma plataforma de e-commerce robusta para a venda online de produtos. O objetivo principal é estabelecer uma presença digital eficaz que gere rendas consistentes pela internet. As atividades incluem a seleção da plataforma ideal (Shopify, WooCommerce, etc.), Configuração da loja virtual, integração de métodos de pagamento, gestão de catálogo de produtos, e a implementação de estratégias iniciais para atrair clientes e otimizar as vendas. Buscamos um profissional com experiência comprovada em e-commerce e desenvolvimento web para criar uma solução completa e escalável.	2026-05-29 23:45:13.366506
146	Robô para leitura de IDs no Telegram	https://www.99freelas.com.br/project/robo-para-leitura-de-ids-no-telegram-756988?fs=t	99Freelas	\N	2026-05-29 22:00:15.902298
1577	Dll e Engenharia Reversa	https://www.workana.com/job/dll-e-engenharia-reversa	Workana	Preciso de alguém para fazer engenharia reversa em um jogo chamado Grand Fantasia e faça com que ele injete uma DLL que é necessário desenvolver para aplicar o Discord SDK	2026-05-29 23:45:13.364496
1229	Acquire Legacy COBOL Financial System	https://www.freelancer.com/projects/automation/acquire-legacy-cobol-financial-system	Freelancer	\N	2026-05-29 23:20:16.413552
5699	Especialista em Ia, Automação e Agentes Inteligentes para Implementação e Mentoria Estratégica	https://www.workana.com/job/especialista-em-ia-automacao-e-agentes-inteligentes-para-implementacao-e-mentoria-estrategica	Workana	Estamos buscando um profissional altamente experiente em Inteligência Artificial, automação e agentes inteligentes para atuar como parceiro estratégico. O objetivo principal é a implementação prática de soluções que gerem ganhos significativos de produtividade, economia de tempo e escalabilidade em diversas frentes de trabalho. Não procuramos apenas consultoria teórica, mas sim um especialista capaz de desenhar, construir e colocar sistemas de IA e automação em funcionamento. As áreas de aplicação incluem: 1. Gestão de uma igreja em crescimento com múltiplas unidades. 2. Projetos educacionais em andamento. 3. Desenvolvimento de produtos digitais para treinamento de líderes e pastores. O parceiro ideal terá a capacidade de não só implementar as soluções, mas também oferecer mentoria para a equipe interna, garantindo a sustentabilidade e o aprimoramento contínuo dos sistemas. Buscamos alguém com visão estratégica e habilidades técnicas para transformar ideias em resultados tangíveis.	2026-05-30 18:41:02.698027
18	Aprimoramento e Implementação de Agente de Ia para Whatsapp	https://www.workana.com/job/aprimoramento-e-implementacao-de-agente-de-ia-para-whatsapp	Workana	O cliente possui um agente de IA para WhatsApp já desenvolvido e funcional, mas necessita de um profissional para realizar alterações adicionais e, posteriormente, colocá-lo em produção. O projeto envolve a revisão do código existente, a implementação de novas funcionalidades ou ajustes conforme as especificações do cliente, testes completos para garantir a estabilidade e o correto funcionamento do agente, e a configuração e execução do deploy para que o agente esteja operacional no ambiente do WhatsApp. É Fundamental ter experiência com desenvolvimento de agentes de IA, integração com APIs de mensagens (especificamente WhatsApp) e processos de deploy.	2026-05-29 21:50:13.063152
3501	Dungeon Crusher Recipe Extraction I need a professional reverse engineer for this  -- 4	https://www.freelancer.com/projects/automation/dungeon-crusher-recipe-extraction-i-need-a-professional-reverse-engineer-for-this----4	Freelancer	\N	2026-05-30 02:05:33.633024
3714	Replication Specialist for UE5-Iris Optimisation	https://www.freelancer.com/projects/automation/replication-specialist-for-ue5-iris-optimisation	Freelancer	\N	2026-05-30 02:20:14.727198
2429	Desenvolvimento de Plataforma Web para Conexão entre Empreendedores e Fornecedores (Mvp)	https://www.workana.com/job/desenvolvimento-de-plataforma-web-para-conexao-entre-empreendedores-e-fornecedores-mvp	Workana	Estamos buscando um desenvolvedor ou equipe experiente para criar a primeira versão de uma plataforma web inovadora. O objetivo é estabelecer um marketplace que conecte empreendedores a fornecedores, similar ao modelo de Workana ou 99Freelas, mas focado exclusivamente na cadeia de suprimentos e produção.A proposta central da plataforma é permitir que empreendedores publiquem projetos detalhando suas necessidades de fornecimento, e que fornecedores interessados enviem propostas para atender a essas demandas. A plataforma visa facilitar a busca por parceiros de negócios em diversos setores.Exemplos de casos de uso incluem:- Empreendedores da moda procurando confecções para suas marcas de roupas.- Empresas buscando fabricantes de cosméticos para novos produtos.- Lojas de animais de estimação necessitando de fornecedores de coleiras, camas, brinquedos e outros itens.- Negócios em busca de fornecedores para produtos personalizados.As funcionalidades essenciais para o MVP incluem:- Sistema completo de cadastro e login de usuários.- Dois tipos distintos de conta: Empreendedor e Fornecedor.- Funcionalidade para empreendedores publicarem novos projetos com descrições detalhadas.- Capacidade para fornecedores visualizarem projetos e enviarem propostas personalizadas.- Criação de perfis públicos detalhados para fornecedores, exibindo suas especialidades e portfólio.- Um sistema de avaliações e feedback para garantir a qualidade e confiança.- Chat interno para comunicação e negociação direta entre as partes.- Painéis de gerenciamento intuitivos para empreendedores e fornecedores acompanharem seus projetos e propostas.- Uma área administrativa robusta para controle e moderação da plataforma.- Sistema de notificações para alertar usuários sobre novas propostas, mensagens e atualizações de projetos.O foco inicial é entregar um Produto Mínimo Viável (MVP) que seja totalmente funcional, com uma interface moderna, intuitiva e responsiva, garantindo uma excelente experiência tanto em computadores quanto em dispositivos móveis.Os principais segmentos de mercado que a plataforma atenderá inicialmente são:- Moda- Beleza- Mercado PetProcuramos um profissional ou equipe que possa não apenas desenvolver, mas também sugerir a melhor arquitetura de projeto, com visão de produto para construir uma solução escalável e com potencial de crescimento futuro. Ao enviar sua proposta, por favor, inclua as tecnologias que pretende utilizar, um prazo estimado para o desenvolvimento do MVP, seu portfólio de projetos semelhantes e um valor aproximado para a execução do trabalho. Buscamos um parceiro comprometido com a qualidade e o sucesso a longo prazo do projeto.	2026-05-30 00:50:14.833174
997	Desenvolvimento Push Notification - Android	https://www.99freelas.com.br/project/desenvolvimento-push-notification-android-757002?fs=t	99Freelas	\N	2026-05-29 23:00:11.44724
1655	DICOM SR Parsing Development	https://www.freelancer.com/projects/automation/dicom-sr-parsing-development	Freelancer	\N	2026-05-29 23:55:14.388837
155	Especialista em Automação e Integração Mindbody para Gestão de Academia	https://www.workana.com/job/especialista-em-automacao-e-integracao-mindbody-para-gestao-de-academia	Workana	O proprietário da academia DS Muay Thai Squad, localizada em Massachusetts, Estados Unidos, busca um profissional ou equipe especializada em automação e integração de sistemas para otimizar a gestão da academia. O objetivo principal é profissionalizar as operações, reduzir a necessidade de intervenção manual e permitir que o proprietário se concentre no ensino e no crescimento do negócio.Atualmente, a academia utiliza o sistema Mindbody para gerenciamento de planos, pagamentos, contratos e alunos. O projeto visa integrar e automatizar diversas funcionalidades, utilizando ferramentas existentes para garantir um sistema simples, profissional e de fácil manutenção.Requisitos do Projeto:- Integração completa com o sistema Mindbody.- Implementação de um sistema de check-in automático para alunos.- Configuração de um tablet em modo kiosk na recepção para interação.- Desenvolvimento de um sistema de QR Code ou carteirinha digital para identificação dos alunos.- Controle de presença automático e eficiente.- Notificação em tempo real sobre a presença dos alunos.- Verificação automática do status de mensalidade (ativa/inadimplente).- Integração com sistemas de waiver e documentos digitais.- Preparação para uma futura implementação de controle de acesso físico na porta.Informações Adicionais:- O sistema Mindbody já está em uso na academia.- Um tablet para o modo kiosk já está disponível.- A academia está em pleno funcionamento.- O foco é na expertise técnica e na integração de ferramentas, não no desenvolvimento de software complexo do zero.- O trabalho pode ser realizado de forma totalmente remota.- Busca-se um profissional confiável para uma possível parceria de longo prazo e suporte contínuo.Experiência e Conhecimentos Desejados:- Experiência prévia com academias ou negócios similares.- Proficiência na API do Mindbody.- Conhecimento e experiência com plataformas de automação como Zapier ou Make.- Habilidade em automação de processos.- Experiência com tecnologias de QR Code e RFID.- Conhecimento em configuração de sistemas Kiosk.- Experiência com controle de acesso.Os interessados devem apresentar portfólio, experiências relevantes, valor aproximado, prazo estimado e uma proposta de como fariam essa integração.	2026-05-29 22:00:15.919141
14	Desenvolvedor Junior para Continuidade de Software com Ia e Otimização Administrativa	https://www.workana.com/job/desenvolvedor-junior-para-continuidade-de-software-com-ia-e-otimizacao-administrativa	Workana	Estamos buscando um Desenvolvedor Junior para dar continuidade ao desenvolvimento de um software inovador que integra ferramentas de Inteligência Artificial e otimiza processos administrativos. O profissional será responsável por avaliar o código existente, entender a arquitetura do sistema e prosseguir com a implementação de novas funcionalidades e melhorias até a conclusão da demanda. É Essencial ter proatividade, capacidade de aprendizado rápido e interesse em trabalhar com tecnologias de IA e otimização de processos. Esta é uma excelente oportunidade para um profissional em início de carreira que busca experiência prática em um projeto desafiador e com impacto direto na eficiência operacional.	2026-05-29 21:50:13.056173
6618	Desenvolvimento de Plataforma Global de Palpites de Futebol Online	https://www.workana.com/job/desenvolvimento-de-plataforma-global-de-palpites-de-futebol-online	Workana	O objetivo deste projeto é desenvolver uma plataforma online robusta e interativa para palpites de jogos de futebol. A plataforma permitirá que usuários de todo o mundo se registrem, participem de ligas públicas e privadas, e submetam suas previsões para resultados de partidas de futebol. Será essencial um sistema de pontuação claro e um ranking global para incentivar a competição. A interface deve ser intuitiva e responsiva, funcionando perfeitamente em dispositivos desktop e móveis. A solução deve ser escalável para suportar um grande número de usuários simultâneos e garantir a segurança dos dados. Buscamos um desenvolvedor com experiência em criação de aplicações web complexas e que possa entregar um produto final de alta qualidade.	2026-05-30 19:50:16.404783
377	Power Platform Tenant State Scenarios	https://www.freelancer.com/projects/automation/power-platform-tenant-state-scenarios	Freelancer	\N	2026-05-29 22:15:11.995033
4121	Site simples de combate ao bullying escolar	https://www.99freelas.com.br/project/site-simples-de-combate-ao-bullying-escolar-757031?fs=t	99Freelas	\N	2026-05-30 02:50:14.999629
1080	Especialista em Ia para Desenvolvimento de Conteúdo para Plataforma de T&D	https://www.workana.com/job/especialista-em-ia-para-desenvolvimento-de-conteudo-para-plataforma-de-td	Workana	\N	2026-05-29 23:10:13.137538
6981	Windows Suspicious Script Remover Utility	https://www.freelancer.com/projects/automation/windows-suspicious-script-remover-utility	Freelancer	\N	2026-05-30 20:15:13.821161
4263	Cadastro de Banco de Dados - Produtos	https://www.99freelas.com.br/project/cadastro-de-banco-de-dados-produtos-757032?fs=t	99Freelas	\N	2026-05-30 03:00:15.016598
20	Desenvolvimento Completo de Website e Configuração de Infraestrutura	https://www.workana.com/job/desenvolvimento-completo-de-website-e-configuracao-de-infraestrutura	Workana	Estamos buscando um freelancer experiente para desenvolver um website completo e configurar toda a infraestrutura necessária. O projeto envolve a criação de um novo site do zero, incluindo design, desenvolvimento front-end e back-end, e a configuração do ambiente de servidor que o cliente se refere como 'sistema operacional do site'.O profissional será responsável por:*   Compreender os requisitos e objetivos do novo website.*   Propor e implementar uma solução tecnológica adequada (CMS, framework, etc.).*   Desenvolver o design visual e a interface do usuário (ui/ux).*   Programar todas as funcionalidades necessárias para o site.*   Configurar o servidor web e o banco de dados.*   Garantir a segurança e o desempenho do site.*   Realizar testes e otimizações.Detalhes adicionais sobre o propósito do site, funcionalidades específicas e preferências de design serão discutidos com o profissional selecionado. Buscamos alguém com capacidade de entregar um projeto de ponta a ponta, desde a concepção até a implementação final.	2026-05-29 21:50:13.066728
1068	Desenvolvimento de notificações push para Android	https://www.99freelas.com.br/project/desenvolvimento-de-notificacoes-push-para-android-757002?fs=t	99Freelas	\N	2026-05-29 23:10:13.112923
3636	Desenvolvimento de Integração Bling-Agro Receita via Webhook para Gestão de Pedidos	https://www.workana.com/job/desenvolvimento-de-integracao-bling-agro-receita-via-webhook-para-gestao-de-pedidos	Workana	O projeto consiste na criação e configuração de um webhook no sistema Bling para estabelecer uma integração bidirecional com o aplicativo Agro Receita. O objetivo principal é automatizar o fluxo de dados de pedidos.As etapas incluem:1. Configuração de um webhook no Bling para enviar informações de pedidos para o aplicativo Agro Receita.2. Desenvolvimento da lógica necessária para processar a resposta do Agro Receita, especificamente para extrair o número da receita.3. Atualização automática do pedido correspondente no Bling com o número da receita recebido do Agro Receita.O freelancer deverá utilizar a documentação da API do Agro Receita, disponível emhttps://doc.agroreceita.com.br/, para garantir a correta comunicação e manipulação dos dados. É Fundamental que a solução seja robusta e garanta a integridade das informações entre os dois sistemas.Algumas coisas são necessárias , campos customizados nO produto , porque nem todos precisam de receita , e quando um produto é vendido , acionar o web book dos pedidos	2026-05-30 02:15:15.04668
1435	Desenvolvimento de Balanced Scorecard Interativo no Power Bi	https://www.workana.com/job/desenvolvimento-de-balanced-scorecard-interativo-no-power-bi	Workana	Procuramos um especialista em Power BI para desenvolver um Balanced Scorecard (BSC) de resultados interativo. O objetivo é criar um painel dinâmico que permita monitorar e analisar o desempenho da empresa em quatro perspectivas principais: Financeira, Clientes, Processos Internos e Aprendizado e Crescimento. O projeto envolve a integração de dados de diversas fontes, modelagem de dados, criação de métricas e indicadores-chave de desempenho (KPIs), e a construção de visualizações claras e intuitivas. O freelancer será responsável por todo o ciclo de desenvolvimento, desde a coleta de requisitos até a entrega final do dashboard interativo, garantindo que o BSC seja uma ferramenta estratégica eficaz para a tomada de decisões.	2026-05-29 23:35:12.905625
6973	​Ajuste de Ia Python/Livekit e Automação de Whatsapp	https://www.workana.com/job/ajuste-de-ia-pythonlivekit-e-automacao-de-whatsapp	Workana	\N	2026-05-30 20:15:13.801936
17	Desenvolvimento de Software Desktop Python (Ja tenho a planilha como base)	https://www.workana.com/job/desenvolvimento-de-software-desktop-python-ja-tenho-a-planilha-como-base	Workana	Tenho uma planilha de reconstituição de matricula de imovel urbano e rural!Estamos buscando um desenvolvedor Python experiente para converter uma planilha Excel totalmente funcional em um software desktop robusto. A planilha atual é utilizada para cálculos de coordenadas UTM, azimute, rumo, distância, área e perímetro. O objetivo é replicar todas as funcionalidades existentes e implementar melhorias adicionais.Funcionalidades da planilha a serem replicadas:- Cálculo de distância por coordenadas UTM- Propagação de coordenadas por distância + azimute- Propagação de coordenadas por distância + rumo- Conversão UTMGeográficas (DMS)- Cálculo de área (m² e ha) e perímetro pelo método de Shoelace- Geração de gráfico do polígono- Banco de dados interno para salvar projetos- Exportação de dados em formatos dxf e kmlo desenvolvedor receberá a planilha excel completa como referência para replicar toda a lógica e cálculos em python. A interface do usuário deverá ser desenvolvida utilizando customtkinter, proporcionando uma experiência desktop moderna e intuitiva.Melhorias Adicionais:Detalhes sobre integrações externas e módulos adicionais, compatíveis com o nicho de agrimensura, serão especificados em um briefing detalhado.Stack Tecnológica Esperada:- Python 3.10+- customtkinter- matplotlib- pyproj- ezdxf- simplekml- reportlab- PyInstallerEntregas Obrigatórias:- Código-fonte organizado e devidamente comentado.- Executável .exe gerado via PyInstaller para fácil distribuição.- Testes funcionais completos utilizando dados reais que serão fornecidos.	2026-05-29 21:50:13.06127
2926	Desenvolvimento de Sistema Simples de Acompanhamento de Propostas em Google Sheets	https://www.workana.com/job/desenvolvimento-de-sistema-simples-de-acompanhamento-de-propostas-em-google-sheets	Workana	O objetivo principal é desenvolver uma ferramenta simples e eficiente para o acompanhamento de propostas comerciais, focando na facilidade de uso e agilidade. É Importante ressaltar que a intenção não é construir um CRM completo, mas sim um sistema focado especificamente no controle de retornos e acompanhamentos. A ferramenta deverá permitir o cadastro e gerenciamento das seguintes informações para cada proposta: cadastrar cliente, número da proposta, data da proposta, telefone, valor, vendedor responsável, data do próximo contato, status e observações rápidas. Para garantir que nenhuma proposta importante seja esquecida, o sistema deve incluir um mecanismo de alerta. Ao se aproximar a 'data do próximo contato', o sistema deverá: enviar aviso por e-mail OU gerar alerta automático. Os alertas devem ser claros e informativos, como 'Entrar em contato com cliente X referente proposta XXXX.'. A solução ideal deve ser: simples, rápida, fácil de usar e visual. A preferência é por uma implementação em Google Sheets, utilizando automações (scripts) para as funcionalidades de alerta e dashboard. Adicionalmente, um painel simples será necessário para visualizar rapidamente a quantidade de propostas do mês e o valor total previsto. O objetivo final é otimizar o acompanhamento comercial, garantindo que nenhuma oportunidade seja perdida e melhorando a gestão do pipeline de vendas. O projeto possui um prazo de entrega apertado de 1 dia.	2026-05-30 01:25:16.961969
5704	Windows-based Virtual GPS Device Development	https://www.freelancer.com/projects/automation/windows-based-virtual-gps-device-development	Freelancer	\N	2026-05-30 18:41:02.707484
2997	Configuração e Solução de Problemas de Notificações de E-mail do Google Forms	https://www.workana.com/job/configuracao-e-solucao-de-problemas-de-notificacoes-de-e-mail-do-google-forms	Workana	O cliente precisa de assistência para resolver um problema com as notificações de e-mail do Google Forms. As notificações estavam funcionando anteriormente, mas pararam de ser entregues, mesmo com a caixa de entrada do e-mail estando livre. O freelancer será responsável por investigar a causa raiz do problema, que pode incluir configurações do Google Forms, scripts associados, filtros de spam ou problemas com o provedor de e-mail. As tarefas incluem a reconfiguração das definições de notificação do Google Forms, testes para garantir que as notificações estão a funcionar corretamente e a implementação de uma solução para evitar futuras ocorrências. É Essencial que o profissional tenha experiência em lidar com a plataforma Google Forms e suas integrações.	2026-05-30 01:30:16.924351
4843	Ajustes em Bot Python de Arbitragem Polymarket/Kalshi	https://www.workana.com/job/ajustes-em-bot-python-de-arbitragem-polymarketkalshi	Workana	\N	2026-05-30 03:40:17.112514
5705	.NET Offline Billing Software Development	https://www.freelancer.com/projects/automation/net-offline-billing-software-development	Freelancer	\N	2026-05-30 18:41:02.709611
5702	Backend Developer Needed for GPS OBD Tracking Gateway	https://www.freelancer.com/projects/automation/backend-developer-needed-for-gps-obd-tracking-gateway	Freelancer	\N	2026-05-30 18:41:02.703581
5703	Commission-Only Consulting Sales Partner	https://www.freelancer.com/projects/automation/commission-only-consulting-sales-partner	Freelancer	\N	2026-05-30 18:41:02.705562
5706	Python Console Application: Student Records	https://www.freelancer.com/projects/automation/python-console-application-student-records	Freelancer	\N	2026-05-30 18:41:02.711566
5707	Ignition Vision Data Module	https://www.freelancer.com/projects/automation/ignition-vision-data-module	Freelancer	\N	2026-05-30 18:41:02.713106
15	Criação de Landing Page para Desafio Digital de 7 Dias	https://www.workana.com/job/criacao-de-landing-page-para-desafio-digital-de-7-dias	Workana	Estamos buscando um profissional qualificado para desenvolver uma landing page de alta conversão para um novo produto digital. Este produto é um desafio de 7 dias focado em redes sociais, com um modelo de 'low ticket', e faz parte de um ecossistema maior voltado para os setores da construção civil e mercado imobiliário. A landing page deve ser visualmente atraente, responsiva para dispositivos móveis e otimizada para capturar leads de forma eficaz. É Fundamental que a página comunique claramente o valor do desafio, suas etapas e os benefícios para os participantes, incentivando a inscrição. Precisamos de um design que ressoe com o público-alvo desses mercados e uma estrutura que facilite a navegação e a tomada de decisão. O objetivo principal é maximizar as inscrições para o desafio.	2026-05-29 21:50:13.057846
1222	Desenvolvimento de Aplicativo Mobile Nativo — Ios e Android	https://www.workana.com/job/desenvolvimento-de-aplicativo-mobile-nativo-ios-e-android	Workana	Preciso de um desenvolvedor mobile para construir do zero um app de saúde, nutrição e bem-estar para mulheres brasileiras, com publicação nas lojas até 15 de julho de 2026. O projeto é fechado, com valor único pela entrega completa.Funcionalidades esperadas incluem:- Autenticação, perfil e onboarding de usuários.- Dashboard intuitivo para acompanhamento de progresso diário e streak de constância.- Módulo de cardápio com registro de refeições por foto (com identificação de calorias via IA) e opção de registro manual.- Chat integrado com inteligência artificial treinada na metodologia da marca, apresentando delay inteligente e a possibilidade de atendimento humano.- Missões diárias com check-in automático baseado no comportamento do usuário.- Player de áudios diários com mini-player persistente para conteúdo de bem-estar.- Feed social para interação, com posts, fotos e reações.- Implementação de notificações push para engajamento.- Desenvolvimento de um painel administrativo completo para gerenciamento do aplicativo.- Suporte para publicação na Apple App Store e Google Play Store.A stack desejada para o desenvolvimento inclui React Native + Expo, Supabase para backend e banco de dados, TypeScript para tipagem e integração com APIs de IA para funcionalidades avançadas.O processo de seleção incluirá:1. Análise de propostas com portfólio de apps publicados.2. Call técnica de 30 minutos.3. Assinatura de contrato antes do início do projeto.Propostas sem portfólio de apps publicados nas lojas não serão consideradas.	2026-05-29 23:20:16.390238
5708	Anki V3 Scheduler — Custom Ordered Route Review Mode (Python/PyQt, Windows)	https://www.freelancer.com/projects/automation/anki-v3-scheduler-custom-ordered-route-review-mode-pythonpyqt-windows	Freelancer	\N	2026-05-30 18:41:02.714708
5711	Python script for Automation solidworks drawing	https://www.freelancer.com/projects/automation/python-script-for-automation-solidworks-drawing	Freelancer	\N	2026-05-30 18:41:02.721136
5712	Private project or contest #40479499	https://www.freelancer.com/projects/automation/private-project-or-contest-40479499	Freelancer	\N	2026-05-30 18:41:02.724184
7103	Criação de site para hospedaria	https://www.99freelas.com.br/project/criacao-de-site-para-hospedaria-757129?fs=t	99Freelas	\N	2026-05-30 20:25:15.307012
5713	HealthTech .NET Web App Build	https://www.freelancer.com/projects/automation/healthtech-net-web-app-build	Freelancer	\N	2026-05-30 18:41:02.726146
5717	360-Degree Coffee Mug Image Integration	https://www.freelancer.com/projects/automation/360-degree-coffee-mug-image-integration	Freelancer	\N	2026-05-30 18:41:02.733548
5718	ECR Fiscal POS Integration	https://www.freelancer.com/projects/automation/ecr-fiscal-pos-integration	Freelancer	\N	2026-05-30 18:41:02.735216
5720	Blu-ray Java Menu Update -- 2	https://www.freelancer.com/projects/automation/blu-ray-java-menu-update----2	Freelancer	\N	2026-05-30 18:41:02.738679
5721	NinjaTrader 8 Indicator Upgrades	https://www.freelancer.com/projects/automation/ninjatrader-8-indicator-upgrades	Freelancer	\N	2026-05-30 18:41:02.740258
5714	Guidance on Swarm Drone Algorithm  -- 3	https://www.freelancer.com/projects/automation/guidance-on-swarm-drone-algorithm----3	Freelancer	\N	2026-05-30 18:41:02.727804
5715	MERN Stack Frontend Dev Needed	https://www.freelancer.com/projects/automation/mern-stack-frontend-dev-needed	Freelancer	\N	2026-05-30 18:41:02.729684
7115	Desenvolvimento de Website Profissional para Consultoria de Engenharia Aeroportuária	https://www.workana.com/job/desenvolvimento-de-website-profissional-para-consultoria-de-engenharia-aeroportuaria	Workana	Estamos buscando um freelancer qualificado para desenvolver um website profissional para nossa consultoria de engenharia especializada em aeroportos. O objetivo principal é alavancar nossa presença digital e apresentar nossos serviços e expertise para empresas privadas e concessionárias do setor aeroportuário. O site deve ser uma ferramenta de marketing e comunicação eficaz, destacando nossa experiência e projetos anteriores. Precisamos de um design moderno, responsivo e intuitivo, que transmita credibilidade e profissionalismo. O conteúdo incluirá informações sobre a empresa, descrição detalhada dos serviços oferecidos, um portfólio de projetos relevantes, depoimentos de clientes e uma seção de contato clara. É Fundamental que o site seja otimizado para mecanismos de busca (SEO) para garantir visibilidade e atrair o público-alvo correto.	2026-05-30 20:25:15.343227
5716	Guidance on Swarm Drone Algorithm	https://www.freelancer.com/projects/automation/guidance-on-swarm-drone-algorithm	Freelancer	\N	2026-05-30 18:41:02.731725
5719	Python Educational CLI Tool	https://www.freelancer.com/projects/automation/python-educational-cli-tool	Freelancer	\N	2026-05-30 18:41:02.737109
5709	Embedded Systems Developer — Arduino & Raspberry Pi -- 2	https://www.freelancer.com/projects/automation/embedded-systems-developer-arduino-raspberry-pi----2	Freelancer	\N	2026-05-30 18:41:02.716705
5710	Embedded Systems Developer — Arduino & Raspberry Pi	https://www.freelancer.com/projects/automation/embedded-systems-developer-arduino-raspberry-pi	Freelancer	\N	2026-05-30 18:41:02.718932
5722	Cross-Platform Device Testing	https://www.freelancer.com/projects/automation/cross-platform-device-testing	Freelancer	\N	2026-05-30 18:41:02.741993
5695	Desenvolvimento de Portal de Turismo Completo (Site e Aplicativo) para Divulgação de Serviços	https://www.workana.com/job/desenvolvimento-de-portal-de-turismo-completo-site-e-aplicativo-para-divulgacao-de-servicos	Workana	Estamos buscando um profissional ou equipe para desenvolver um portal de turismo abrangente, que inclua tanto um website quanto um aplicativo móvel. O objetivo principal é criar uma plataforma robusta para a divulgação de serviços de terceiros no setor de turismo. O portal deverá permitir a listagem e promoção de diversas categorias de serviços, incluindo pousadas, hotéis, passeios e informações úteis como tábuas de maré. Espera-se que a plataforma seja intuitiva, com um design moderno e responsivo, garantindo uma excelente experiência de usuário tanto no desktop quanto em dispositivos móveis. O projeto envolve o desenvolvimento do frontend e backend do site, bem como a criação de aplicativos nativos ou híbridos para Android e iOS. A capacidade de integrar dados externos, como as tábuas de maré, será um diferencial. Buscamos uma solução completa que facilite a gestão de conteúdo e a interação com os usuários finais.	2026-05-30 18:41:02.689928
7458	Especialista em WooCommerce, UX e otimização de e-commerce	https://www.99freelas.com.br/project/especialista-em-woocommerce-ux-e-otimizacao-de-e-commerce-757133?fs=t	99Freelas	\N	2026-05-30 20:50:12.372429
7459	Desenvolvedor para gestão administrativa e escalabilidade de SaaS	https://www.99freelas.com.br/project/desenvolvedor-para-gestao-administrativa-e-escalabilidade-de-saas-757132?fs=t	99Freelas	\N	2026-05-30 20:50:12.374738
7460	Criação de landing page para hospedaria	https://www.99freelas.com.br/project/criacao-de-landing-page-para-hospedaria-757129?fs=t	99Freelas	\N	2026-05-30 20:50:12.377175
227	Criação de Landing Page Profissional com Design Impactante e Integração Whatsapp	https://www.workana.com/job/criacao-de-landing-page-profissional-com-design-impactante-e-integracao-whatsapp	Workana	Estamos buscando um freelancer experiente para desenvolver uma landing page de alta performance, focada em capturar leads e gerar solicitações de orçamento para nosso serviço. A página deve ter um design "top criativo" que realmente chame a atenção, transmitindo profissionalismo, nossa vasta experiência e domínio de mercado. O objetivo principal é que os visitantes possam solicitar um orçamento de forma rápida e fácil, com um botão de clique direto para o WhatsApp. Precisamos de uma página responsiva, otimizada para conversão e que reflita a qualidade e a autoridade da nossa marca no setor. O projeto inclui o design visual, desenvolvimento front-end e a integração funcional do botão de contato via WhatsApp.	2026-05-29 22:05:16.228358
4701	Desenvolvimento de Bot de Ia para Automação Criativa de Frases no Whatsapp	https://www.workana.com/job/desenvolvimento-de-bot-de-ia-para-automacao-criativa-de-frases-no-whatsapp	Workana	Estamos buscando um desenvolvedor experiente para criar um bot de inteligência artificial que automatize a geração e envio de frases no WhatsApp. O objetivo principal é tornar as interações mais divertidas e envolventes, utilizando a IA para criar conteúdo criativo e relevante. O projeto envolve a integração com a plataforma Whatsapp (via api oficial ou solução similar), o desenvolvimento de um módulo de ia para geração de texto e a configuração para automação de mensagens. O freelancer ideal terá experiência em desenvolvimento de chatbots, processamento de linguagem natural (NLP) e integração de APIs. Espera-se uma solução robusta e fácil de usar, capaz de gerar frases de forma dinâmica e divertida.	2026-05-30 03:30:14.157442
5698	Desenvolvimento de Loja Virtual Completa na Plataforma Nuvemshop	https://www.workana.com/job/desenvolvimento-de-loja-virtual-completa-na-plataforma-nuvemshop	Workana	Estamos buscando um profissional experiente para desenvolver uma loja virtual completa e funcional na plataforma Nuvemshop. O projeto inclui a configuração inicial da loja, personalização do layout de acordo com nossa identidade visual, importação de catálogo de produtos, configuração de métodos de pagamento e opções de envio. É Fundamental que o profissional tenha conhecimento aprofundado da plataforma Nuvemshop para garantir uma implementação eficiente e otimizada para vendas. O objetivo é criar uma experiência de compra intuitiva e atraente para nossos clientes.	2026-05-30 18:41:02.696503
5701	Implementação de Agente de Ia para Atendimento Whatsapp em Clínica	https://www.workana.com/job/implementacao-de-agente-de-ia-para-atendimento-whatsapp-em-clinica	Workana	Estamos buscando um profissional experiente em automação e agentes de inteligência artificial para desenvolver e implementar um assistente de atendimento via WhatsApp para uma clínica oftalmológica. O objetivo principal é otimizar o atendimento ao paciente, que atualmente lida com um alto volume de aproximadamente 700 conversas diárias.O agente de IA será responsável por:- Realizar atendimento fora do horário comercial de forma fluida e natural, evitando uma experiência robótica.- Identificar a unidade de atendimento e a necessidade específica de cada paciente.- Consultar uma base de conhecimento para classificar o caso do paciente e fornecer informações relevantes.- Tratar objeções comuns relacionadas a convênios, valores e horários de consulta, utilizando macros pré-definidas.- Conduzir o paciente para uma Chamada para Ação (CTA) de agendamento de consultas.- Encerrar as conversas informando sobre o retorno do atendimento no próximo dia útil.Já possuímos a seguinte infraestrutura e recursos:- Um CRM Kommo configurado e em pleno uso.- Uma base de macros já mapeada, desenvolvida a partir da auditoria de mais de 300 conversas.- O fluxo de atendimento atual está completamente documentado.Procuramos um freelancer com o seguinte perfil:- Experiência comprovada na implementação de agentes de IA conversacionais.- Conhecimento e familiaridade com a plataforma Kommo e/ou n8n.- Capacidade de colaborar na montagem e treinamento da base de conhecimento do agente.- Disponibilidade para realizar testes e ajustes necessários após a entrega inicial do projeto.	2026-05-30 18:41:02.701654
5700	Criação de Site de Convite Digital Responsivo para Aniversário Infantil	https://www.workana.com/job/criacao-de-site-de-convite-digital-responsivo-para-aniversario-infantil	Workana	Estamos buscando um desenvolvedor para criar um site de convite digital simples e responsivo para uma festa de aniversário infantil com o tema "Arraiá da Anna Clara". O objetivo é ter um convite online bonito e funcional que possa ser facilmente acessado de qualquer dispositivo, especialmente celulares.O site deve incluir os seguintes elementos:- Um título claro para o evento, como "Arraiá da Anna Clara".- Um texto de convite personalizado.- Todas as informações essenciais da festa: data, horário e local.- Espaço para uma foto da criança e uma imagem de caricatura (as imagens serão fornecidas).- Um botão de "Confirmar presença" que, ao ser clicado, abra uma conversa no WhatsApp para facilitar a confirmação dos convidados.- Uma opção para incluir música de fundo (o arquivo de música será fornecido).- Um design visual atraente e temático, inspirado em festas infantis e juninas, que seja leve e agradável.O profissional será responsável por:- Organizar o layout e a estrutura do site.- Garantir que o site seja totalmente responsivo e funcione bem em diferentes tamanhos de tela.- Implementar o botão de confirmação de presença via WhatsApp.- Integrar as imagens e a música fornecidas.- Realizar testes para corrigir possíveis erros e garantir a funcionalidade.Buscamos uma solução simples e leve, sem a necessidade de um sistema complexo de gerenciamento de conteúdo ou banco de dados. A entrega final deve ser um conjunto de arquivos html, css e javascript prontos para serem hospedados.	2026-05-30 18:41:02.699556
5697	Desenvolvimento de Sistema de Ia para Automação de Respostas no Whatsapp e Correção de Redações	https://www.workana.com/job/desenvolvimento-de-sistema-de-ia-para-automacao-de-respostas-no-whatsapp-e-correcao-de-redacoes	Workana	Procuramos um desenvolvedor ou equipe especializada em Inteligência Artificial para criar um sistema robusto que integre duas funcionalidades principais: 1. Automação de Respostas no WhatsApp: Implementar um chatbot inteligente capaz de interagir com usuários do WhatsApp, fornecendo respostas automáticas para perguntas frequentes, suporte básico e outras interações pré-definidas. O sistema deve ser capaz de compreender a intenção do usuário e fornecer respostas relevantes. 2. Correção de Redações com IA: Desenvolver um módulo de IA para analisar e corrigir redações. Este módulo deve identificar erros gramaticais, ortográficos, de pontuação e sugerir melhorias de estilo e clareza. A capacidade de fornecer feedback construtivo e detalhado é essencial. O projeto envolve o design, desenvolvimento, implementação e testes de ambas as funcionalidades, garantindo uma integração fluida e uma experiência de usuário eficiente. Conhecimento em processamento de linguagem natural (PNL), machine learning e integração de APIs é fundamental.	2026-05-30 18:41:02.694162
13	Desenvolvimento de Sistema Integrado de Triage e Apoio Clínico com Inteligência Artificial	https://www.workana.com/job/desenvolvimento-de-sistema-integrado-de-triage-e-apoio-clinico-com-inteligencia-artificial	Workana	Estamos buscando um freelancer ou equipe especializada para desenvolver um sistema integrado inovador que utilize inteligência artificial para otimizar processos na área da saúde. O sistema terá três módulos principais: 1. Triagem Inteligente: Um módulo para auxiliar na triagem de pacientes, priorizando casos com base em dados e sintomas, visando agilizar o atendimento e otimizar recursos. 2. Apoio à Decisão Clínica: Uma ferramenta que fornecerá suporte aos profissionais de saúde na tomada de decisões clínicas, oferecendo informações relevantes, diagnósticos diferenciais e recomendações de tratamento baseadas em evidências e análise de dados. 3. Formação Médica Continuada: Um módulo dedicado à educação continuada de médicos e outros profissionais de saúde, utilizando IA para personalizar o aprendizado, identificar lacunas de conhecimento e oferecer conteúdos relevantes e atualizados. O projeto requer expertise em desenvolvimento de software, inteligência artificial, processamento de linguagem natural (NLP) e conhecimento da área da saúde. Buscamos profissionais com experiência comprovada em projetos complexos e que possam entregar uma solução robusta, segura e escalável.	2026-05-29 21:50:13.054416
4133	Implementação e Integração de Crm Zoho com Whatsapp para Consultório de Psiquiatria	https://www.workana.com/job/implementacao-e-integracao-de-crm-zoho-com-whatsapp-para-consultorio-de-psiquiatria	Workana	Estamos buscando um profissional qualificado para implementar e configurar um sistema de CRM integrado com WhatsApp para o nosso consultório de Psiquiatria. O objetivo é otimizar a gestão de pacientes, agendamentos e comunicação, proporcionando um fluxo de trabalho mais eficiente e organizado. Preferencialmente, a solução deve ser baseada na plataforma Zoho, aproveitando suas funcionalidades para gerenciar dados de pacientes, histórico de interações e lembretes. A integração com WhatsApp é crucial para facilitar a comunicação direta e rápida com os pacientes, seja para confirmação de consultas, envio de informações ou acompanhamento. Buscamos uma solução gerenciável que permita à equipe do consultório utilizar o sistema de forma intuitiva após a implementação. O projeto envolve a configuração inicial do CRM, personalização para as necessidades específicas de um consultório de psiquiatria e a integração funcional com o WhatsApp.	2026-05-30 02:50:15.043699
3423	Automação de Classificação de Grãos de Café por Cor com Arduino e Clp Altus Xp325	https://www.workana.com/job/automacao-de-classificacao-de-graos-de-cafe-por-cor-com-arduino-e-clp-altus-xp325	Workana	Estamos buscando um especialista para desenvolver um sistema de automação para a classificação de grãos de café por cor. O projeto envolve a integração de hardware e software para otimizar o processo de separação.O sistema deve funcionar da seguinte forma:1.  Os grãos de café serão transportados por uma esteira.2.  Um sensor de cor TCS3472 fará a leitura da cor de cada grão (verde, vermelho, amarelo).3.  Com base na leitura do sensor, um dos três atuadores pneumáticos será acionado para direcionar o grão para o compartimento correspondente à sua cor.4.  Grãos de café estragados (cor preta) não devem acionar nenhum atuador e devem seguir reto na esteira, caindo em um compartimento de refugo.5. E também terá uma interface ihm mostrando o processo inteiro.O controle principal será realizado por um Arduino, que deverá se comunicar com um CLP Altus XP325. O Arduino atuará como mestre, e o CLP Altus XP325 como escravo, exigindo a programação de comunicação mestre-escravo entre os dois dispositivos. O profissional deverá ter experiência em programação de microcontroladores, integração de sensores e atuadores, e comunicação com CLPs industriais.	2026-05-30 02:00:15.536359
5980	Desenvolvimento de Site de Portfólio Profissional para Serviços de Vídeo	https://www.workana.com/job/desenvolvimento-de-site-de-portfolio-profissional-para-servicos-de-video	Workana	O cliente busca um freelancer para desenvolver um site de portfólio completo e funcional, destinado a divulgar seus serviços de gravação e edição de vídeo. O objetivo principal é apresentar o trabalho a potenciais clientes, como músicos, lojas, restaurantes e outros negócios, de forma profissional e acessível. O site deverá incluir as seguintes seções e funcionalidades essenciais: uma página inicial com uma apresentação clara e impactante do trabalho do cliente; uma seção dedicada para exibir exemplos de vídeos já realizados, funcionando como um portfólio visual da qualidade e estilo dos projetos anteriores; uma lista detalhada dos serviços oferecidos, que incluem captação de vídeo, edição de vídeo, adição de legendas, criação ou seleção de trilha sonora e edição específica para redes sociais; e um botão de contato direto via WhatsApp, facilitando que os clientes solicitem orçamentos de forma rápida e eficiente. O freelancer deverá garantir um design responsivo, intuitivo e profissional, que reflita a qualidade dos serviços de vídeo oferecidos pelo cliente, e que seja fácil de navegar em qualquer dispositivo.	2026-05-30 19:05:15.525002
6050	Criação de Site Responsivo para Lançamentos Imobiliários com Gerenciamento de Conteúdo	https://www.workana.com/job/criacao-de-site-responsivo-para-lancamentos-imobiliarios-com-gerenciamento-de-conteudo	Workana	Procuro um profissional qualificado para desenvolver um site simples, porém elegante e totalmente responsivo, focado na apresentação de lançamentos imobiliários.O objetivo principal é ter uma plataforma online que exiba os imóveis de forma clara e atraente para potenciais clientes.Pensei em usar o Claude Code para criar / WIX, ou algo não muito complexo, mas acho que seria legal algo um pouco melhor, estou aberto a ideias.O site deverá incluir:- Uma página inicial (homepage) com design moderno e intuitivo, filtro de valor, ajustar pixels.- Uma área dedicada à exibição de aproximadamente 10 produtos (lançamentos imobiliários).- Cada produto deve ter sua própria seção com múltiplas fotos, uma descrição detalhada e um botão de contato direto via WhatsApp para facilitar a interação com os interessados.É Fundamental que o site seja fácil de gerenciar e editar após a entrega. Trocar textos, atualizar fotos e adicionar novos produtos de forma autônoma.Não é necessário um sistema complexo ou funcionalidades avançadas de e-commerce, mas sim um site profissional, bem organizado e funcional que sirva como um catálogo digital eficaz.Busco um freelancer com experiência em desenvolvimento web que possa fazer esse serviço por um preço acessivel.	2026-05-30 19:10:12.620939
5979	Parceria Recorrente para Desenvolvimento Web: Sites Institucionais e Lojas Virtuais Completas	https://www.workana.com/job/parceria-recorrente-para-desenvolvimento-web-sites-institucionais-e-lojas-virtuais-completas	Workana	Estamos buscando um desenvolvedor freelancer para estabelecer uma parceria de longo prazo e recorrente na criação de sites institucionais e lojas virtuais completas. O profissional ideal terá experiência comprovada em plataformas como WordPress, WooCommerce, Shopify ou similares, e será capaz de entregar projetos "chave na mão".O escopo de cada projeto incluirá:*   Desenvolvimento completo do site institucional ou loja virtual.*   Criação de layout profissional e responsivo, com foco em mobile first.*   Publicação online do projeto.*   Configuração da hospedagem.*   Conexão e configuração do domínio.*   Instalação e configuração completa do site, garantindo que esteja funcionando perfeitamente no link final.É Fundamental que o profissional entregue o projeto pronto, publicado e totalmente funcional online, não apenas o desenvolvimento do layout ou o envio de arquivos. Nosso objetivo é fechar projetos recorrentes com clientes locais, por isso a busca por uma parceria duradoura.Ao apresentar sua proposta, gostaríamos de receber as seguintes informações:*   Portfólio de sites já desenvolvidos.*   Valor médio para a criação de um site institucional.*   Valor médio para a criação de uma loja virtual / e-commerce.*   Prazo médio de entrega para cada tipo de projeto.*   Confirmação de que realiza a publicação completa, incluindo domínio e hospedagem configurados.Serão considerados diferenciais:*   Experiência específica com WooCommerce ou Shopify.*   Experiência no desenvolvimento de sites para pequenos negócios.*   Excelente comunicação e comprometimento com prazos de entrega.	2026-05-30 19:05:15.522039
7541	Desenvolvimento de Plataforma Web e Mobile com Ia para Acompanhamento de Humor e Energia	https://www.workana.com/job/desenvolvimento-de-plataforma-web-e-mobile-com-ia-para-acompanhamento-de-humor-e-energia	Workana	O programa terá como base o conceito de um 'Gift Hub' e o front-end já possui uma prévia avançada.Fluxo do Usuário:1. O usuário receberá diariamente uma mensagem via WhatsApp para interação.2. Responderá a perguntas fechadas sobre seu dia, incluindo:- Horas de sono.- Nível de energia (escala de 0 a 10).- Nível de humor (escala de 0 a 10).- Se a mente está mais acelerada que o normal.- Se tomou a medicação.3. Após as perguntas, o sistema oferecerá a opção de gravar um áudio livre para comentar sobre o dia.Processamento de Áudio e IA:- Caso o usuário envie um áudio, este será transcrito automaticamente.- O conteúdo transcrito será armazenado no banco de dados.- A inteligência artificial analisará o texto em busca de padrões narrativos, mudanças comportamentais, níveis de otimismo/pessimismo, energia emocional e tendências gerais.- O sistema criará um histórico longitudinal completo para cada usuário.Dashboard Analítico:Um dashboard intuitivo apresentará as seguintes informações:- Tendência geral do usuário.- Gráficos de energia e humor ao longo do tempo.- Histórico de conversas e padrões narrativos.- Resumos gerados por IA para períodos de 3, 7, 15, 30 ou 60 dias.- Histórico completo de áudios e suas respectivas transcrições.- Gráficos de evolução temporal para facilitar a visualização.- O sistema comparará cada nova resposta com o padrão histórico individual (basal), identificando mudanças relevantes e anomalias ao longo do tempo.UM outro cliente mestre recebera os dados de cada usuario, onde tambem tera acesso a essesdados.elepodera ter acesso a multiplus dados, exemplo, um medico que tera acesso a esses dados tambem.Tecnologias Sugeridas:- Front-end: Lovable (framework similar a React/Vue)- Banco de dados: Supabase- Automações: n8n- Integração WhatsApp: Twilio- Inteligência Artificial: OpenAI/ChatGPT- Dashboard: Ferramentas de visualização de dados com gráficos de evolução temporal.	2026-05-30 20:55:15.259952
7399	Configuração Avançada do Kommo Crm para Rastreamento de Vendas e Integração com E-commerce	https://www.workana.com/job/configuracao-avancada-do-kommo-crm-para-rastreamento-de-vendas-e-integracao-com-e-commerce	Workana	Procuramos um profissional experiente para configurar e otimizar nosso Kommo CRM, com foco principal no rastreamento da jornada do cliente e da participação da equipe de vendas. O objetivo é identificar se um lead interagiu com nossos vendedores via WhatsApp em qualquer etapa antes da conversão, mesmo que a compra final ocorra em nosso site WooCommerce. Esta informação é crucial para a bonificação da equipe de vendas e para manter um histórico completo do lead, independentemente de futuras alterações nos números de telefone.As principais fontes de tráfego para nossos leads incluem RD Station, Meta (Facebook/Instagram), tráfego orgânico do site e campanhas de Facebook/Instagram que direcionam para o WhatsApp.Requisitos do Projeto:*   Configurar o Kommo CRM para rastrear interações de leads com a equipe de vendas via WhatsApp algo que vai facilitar no projeto é que no momento temos apenas 1 vendendor.*   Desenvolver uma solução para marcar leads que tiveram contato com a equipe de vendas, mesmo que a conversão final aconteça no site (WooCommerce).*   Implementar um campo ou coluna no Kommo CRM que indique a participação da equipe de vendas no processo de venda.*   Garantir que o rastreamento seja persistente e não seja afetado por mudanças nos números de telefone do WhatsApp.*   Fornecer documentação detalhada de toda a configuração e dos processos implementados, permitindo futuras alterações e manutenção interna.*   A intenção principal não é criar novos funis de alimentação de leads neste momento, mas sim traquear o caminho da compra e a influência da equipe de vendas.* Essa TAG ou marcação terá vida útil do mês vigente. Ou seja dia 01 ao 30.Buscamos um especialista que possa analisar nosso fluxo atual e propor a melhor abordagem técnica para atingir esses objetivos, garantindo uma solução eficiente e escalável.	2026-05-30 20:45:12.81162
6476	Desenvolvimento de Robô Interativo 'Knight' (Hollow Knight) com Movimento e Comandos de Voz	https://www.workana.com/job/desenvolvimento-de-robo-interativo-knight-hollow-knight-com-movimento-e-comandos-de-voz	Workana	Estamos buscando um desenvolvedor ou equipe para criar um robô personalizado inspirado no personagem Knight do jogo Hollow Knight. O objetivo é construir um protótipo funcional com as seguintes características e capacidades:Características Físicas:Altura entre 17 e 20 cm.Aparência geral semelhante ao Knight, sem necessidade de detalhes extremos, mas com reconhecimento claro do personagem.Inclusão do ferrão (nail) característico do personagem.Funcionalidades de Movimento:Capacidade de andar, movendo as pernas de forma autônoma.Movimentação dos braços para expressar ações simples.Funcionalidades Interativas:Capacidade de reproduzir frases pré-definidas ou geradas por meio de um alto-falante integrado.Responder a comandos de voz simples para iniciar ações ou reproduzir frases.O projeto envolve design mecânico, eletrônica embarcada e programação. Buscamos profissionais com experiência em robótica, desenvolvimento de hardware e software, e integração de sistemas de voz.Gostaríamos que as propostas incluíssem:Uma avaliação da viabilidade técnica do projeto.Sugestões de componentes e tecnologias a serem utilizados (ex: microcontroladores, motores, módulos de voz).Uma estimativa de custo detalhada.Um cronograma de desenvolvimento.Estamos abertos a sugestões para otimizar o projeto e reduzir custos, desde que as funções principais de movimento, interação por voz e a essência da aparência do Knight sejam mantidas.	2026-05-30 19:40:12.26204
6483	Teamcenter Workflow & NX Integration	https://www.freelancer.com/projects/automation/teamcenter-workflow-nx-integration	Freelancer	\N	2026-05-30 19:40:12.275813
\.


--
-- Data for Name: user_profile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_profile (id, user_id, username, nivel, localizacao, idiomas, skill) FROM stdin;
1	10	string10@mail.com	Júnior	Brasil	Português	Python
2	11	string9@mail.com	Pleno	Estados Unidos	Português, Inglês	Python, TypeScript
3	13	ga1234@mail.com	Júnior	Brasil	Português	Python
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (user_id, username, email, password) FROM stdin;
1	testcreate_updated	updated@example.com	newpassword
2	testuser_1780096712	test_1780096712@example.com	$argon2id$v=19$m=65536,t=3,p=4$jnLjZVjSyqdlcbNbevPU2Q$R0ktZo/VuagsLbFEuYV0rPLDV6q86ZABHHaZNCMqaMM
3	string	string@mail	$argon2id$v=19$m=65536,t=3,p=4$8QC7bahSLOPteenLGI0xXA$AxtqotSYze/X3N5R1Xc7gd6Be53qVA/VzHaX497rojI
4	string	string@mail.com	$argon2id$v=19$m=65536,t=3,p=4$jBYJhq/wftazEKgbKvxSaw$MMzb/xFr7tPLvQ4X1PPQTCg9wba3D8lQptmUUjPdTWs
5	ga	ga@mail.com	$argon2id$v=19$m=65536,t=3,p=4$r/KFxTb/hjtGaEMTigZUtA$gnBBKWM4HKY9DGDCT5Co3X2y8stMvq2eaGQDmPSAS88
8	string33	string33@mail.com	$argon2id$v=19$m=65536,t=3,p=4$EsxtcVIVwyCi4VWxIs9x/Q$HOJBp5WI3+TpSg7IfcQDG7d146EYdtFCmz6bQXaFuXs
9	string8	string8@mail.com	$argon2id$v=19$m=65536,t=3,p=4$PGdMyncTMRUhqjzH38+Wsg$1oiJBP2/wWDcz3Fke/YFyweYVtM5VkIeuo3zIL0CJ0E
10	string10	string10@mail.com	$argon2id$v=19$m=65536,t=3,p=4$1Qpuon89J9mUm2IQ3TfevQ$cf28jqHGKns0AJn89+WtvOA/404CbYD/Ch8nLvw2noc
11	string9	string9@mail.com	$argon2id$v=19$m=65536,t=3,p=4$0W/ps+ZpZ8qmWYSweCspoQ$fHJru7WwUfz5+WycT9cYKAma9JK0uOR2dpOsQnsG+G8
12	gabriel	ga123@mail.com	$argon2id$v=19$m=65536,t=3,p=4$EWSuewRwJtXaN3X7RFyJqw$l2wP6Ysz1UQ5+FsItq8Jls7HZaNHsnkH+h8xSFb2jzk
13	ga1234	ga1234@mail.com	$argon2id$v=19$m=65536,t=3,p=4$sCAhDuZ788ErreHywkg8Kw$8W3e8v6B1tDa5hur3k5GUvNF0JOrm92IJ4h1D1Dljds
\.


--
-- Name: freelas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.freelas_id_seq', 7597, true);


--
-- Name: user_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_profile_id_seq', 3, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_user_id_seq', 13, true);


--
-- Name: freelas freelas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelas
    ADD CONSTRAINT freelas_pkey PRIMARY KEY (id);


--
-- Name: freelas freelas_titulo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelas
    ADD CONSTRAINT freelas_titulo_key UNIQUE (titulo);


--
-- Name: user_profile user_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT user_profile_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: user_profile user_profile_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT user_profile_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

\unrestrict Pw3H26gxLfInCDXPZgLAXhafEAW4RpiVleOUP8ISEdRoVPbYPkqBJ1GWhhY2DOa

