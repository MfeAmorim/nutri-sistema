-- ============================================================
--  NUTRI AMORIM — Script SQL para o Supabase
--  Cole isso no SQL Editor do seu projeto Supabase
-- ============================================================

-- 1. TABELA DE PERFIS
create table if not exists public.perfis (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade unique,
  nome text,
  sobrenome text,
  email text,
  telefone text,
  nascimento date,
  objetivo text,
  termo_aceito boolean default false,
  termo_aceito_em timestamptz,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 2. TABELA DE PRONTUÁRIOS (FICHA DE ANAMNESE)
create table if not exists public.prontuarios (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade unique,
  nome text,
  nascimento date,
  sexo text,
  estado_civil text,
  profissao text,
  telefone text,
  -- Antropometria
  peso numeric(6,2),
  altura numeric(5,1),
  imc numeric(5,2),
  peso_desejado numeric(6,2),
  circ_abdominal numeric(5,1),
  perc_gordura numeric(5,2),
  -- Atividade física
  nivel_atividade text,
  tipo_exercicio text,
  freq_exercicio integer,
  -- Saúde
  patologias text,
  medicamentos text,
  alergias text,
  cirurgias text,
  -- Hábitos alimentares
  num_refeicoes integer,
  apetite text,
  alimentos_gosta text,
  alimentos_nao_gosta text,
  ingesta_agua numeric(4,1),
  alcool text,
  tabagismo text,
  sono text,
  -- Objetivos
  objetivo text,
  meta_peso numeric(6,2),
  observacoes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- 3. TABELA DE ALIMENTOS (TACO/TBCA)
create table if not exists public.alimentos (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade,
  nome text not null,
  fonte text default 'TACO',
  kcal_100g numeric(8,2) not null,
  proteina_100g numeric(8,2) not null,
  carb_100g numeric(8,2) default 0,
  gordura_100g numeric(8,2) default 0,
  fibra_100g numeric(8,2) default 0,
  sodio_100mg numeric(8,2) default 0,
  created_at timestamptz default now()
);

-- 4. TABELA DE RECORDATÓRIOS (24h)
create table if not exists public.recordatorios (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade,
  data date not null,
  itens text,  -- JSON string com os itens consumidos
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique(user_id, data)
);

-- ============================================================
--  ROW LEVEL SECURITY (RLS) — Cada usuário vê só seus dados
-- ============================================================

alter table public.perfis enable row level security;
alter table public.prontuarios enable row level security;
alter table public.alimentos enable row level security;
alter table public.recordatorios enable row level security;

-- Políticas para PERFIS
create policy "Usuário vê só seu perfil" on public.perfis for select using (auth.uid() = user_id);
create policy "Usuário cria seu perfil" on public.perfis for insert with check (auth.uid() = user_id);
create policy "Usuário atualiza seu perfil" on public.perfis for update using (auth.uid() = user_id);

-- Políticas para PRONTUÁRIOS
create policy "Usuário vê só seu prontuário" on public.prontuarios for select using (auth.uid() = user_id);
create policy "Usuário insere seu prontuário" on public.prontuarios for insert with check (auth.uid() = user_id);
create policy "Usuário atualiza seu prontuário" on public.prontuarios for update using (auth.uid() = user_id);

-- Políticas para ALIMENTOS
create policy "Usuário vê só seus alimentos" on public.alimentos for select using (auth.uid() = user_id);
create policy "Usuário insere seus alimentos" on public.alimentos for insert with check (auth.uid() = user_id);
create policy "Usuário deleta seus alimentos" on public.alimentos for delete using (auth.uid() = user_id);

-- Políticas para RECORDATÓRIOS
create policy "Usuário vê só seus recordatórios" on public.recordatorios for select using (auth.uid() = user_id);
create policy "Usuário insere seus recordatórios" on public.recordatorios for insert with check (auth.uid() = user_id);
create policy "Usuário atualiza seus recordatórios" on public.recordatorios for update using (auth.uid() = user_id);

-- ============================================================
--  TRIGGER para updated_at automático
-- ============================================================
create or replace function update_updated_at()
returns trigger as $$
begin new.updated_at = now(); return new; end;
$$ language plpgsql;

create trigger t_perfis before update on public.perfis for each row execute function update_updated_at();
create trigger t_prontuarios before update on public.prontuarios for each row execute function update_updated_at();
create trigger t_recordatorios before update on public.recordatorios for each row execute function update_updated_at();
