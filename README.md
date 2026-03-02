# 🌿 Nutri Amorim — Guia de Deploy

## Estrutura do Projeto

```
nutri-amorim/
├── index.html          ← Página inicial (landing page)
├── login.html          ← Login
├── cadastro.html       ← Criação de conta
├── termo.html          ← Termo de consentimento + download PDF
├── dashboard.html      ← Dashboard principal (todas as abas)
├── supabase-config.js  ← ⚠️ Configurar com suas credenciais
├── supabase-schema.sql ← SQL para criar o banco no Supabase
└── README.md
```

---

## PASSO 1 — Criar projeto no Supabase

1. Acesse https://supabase.com e crie uma conta
2. Crie um novo projeto
3. Vá em **SQL Editor** e cole o conteúdo de `supabase-schema.sql`
4. Execute o SQL para criar todas as tabelas
5. Vá em **Settings → API** e copie:
   - **Project URL** (ex: `https://abcdef.supabase.co`)
   - **anon public key**

---

## PASSO 2 — Configurar credenciais

Abra `supabase-config.js` e substitua:

```js
const SUPABASE_URL = 'https://SEU-PROJETO.supabase.co';
const SUPABASE_ANON_KEY = 'SUA-ANON-KEY-AQUI';
```

---

## PASSO 3 — Configurar autenticação no Supabase

1. No Supabase, vá em **Authentication → Providers**
2. Email/Password já vem habilitado por padrão ✅
3. Em **Authentication → URL Configuration**, adicione a URL do seu site na Render como Site URL e Redirect URL

---

## PASSO 4 — Deploy na Render

1. Crie uma conta em https://render.com
2. Clique em **New → Static Site**
3. Conecte seu repositório GitHub (faça upload dos arquivos)
4. Configure:
   - **Name:** nutri-amorim
   - **Branch:** main
   - **Build Command:** (deixe vazio)
   - **Publish Directory:** `.` (ponto)
5. Clique em **Create Static Site**
6. A Render vai gerar uma URL como: `https://nutri-amorim.onrender.com`

---

## PASSO 5 — Atualizar URL no Supabase

Após o deploy na Render, volte ao Supabase:
- **Authentication → URL Configuration**
- Adicione `https://nutri-amorim.onrender.com` como Site URL

---

## Funcionalidades

| Página | Recurso |
|--------|---------|
| `index.html` | Landing page com botões Entrar / Criar Conta |
| `cadastro.html` | Cadastro com validação + aceite de termos |
| `login.html` | Login por e-mail e senha |
| `termo.html` | Termo de consentimento + download PDF |
| `dashboard.html` | Dashboard com 6 abas |
| → Início | Resumo e cards de navegação |
| → Meu Perfil | Editar dados pessoais |
| → Prontuário Médico | Ficha de anamnese completa + export PDF |
| → Tabela Alimentar | Cadastro de alimentos TACO/TBCA |
| → Recordatório 24h | Registro diário + totais nutricionais |
| → Plano Alimentar | Geração de plano personalizado |
| Exportar Excel | Planilha com 3 abas (prontuário, alimentos, recordatório) |

---

## Tabelas no Supabase

- `perfis` — Dados do usuário
- `prontuarios` — Ficha de anamnese completa
- `alimentos` — Tabela de proporção alimentar
- `recordatorios` — Recordatório 24h por data
# nutri-sistema
