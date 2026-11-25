-- Base de datos de la revisión de los wireframes de Qwi.
-- Ejecutar una vez en Supabase → SQL Editor → New query → Run.

create table if not exists public.propuestas (
  id        uuid primary key default gen_random_uuid(),
  t         text not null check (char_length(t) <= 200),          -- texto revisado (página.sección.clave)
  pagina    text not null check (char_length(pagina) <= 80),
  original  text not null default '' check (char_length(original) <= 4000),
  propuesta text not null check (char_length(propuesta) between 1 and 4000),
  nota      text not null default '' check (char_length(nota) <= 1000),
  autor     text not null check (char_length(autor) between 1 and 80),
  creado    timestamptz not null default now(),
  estado    text not null default 'pendiente' check (estado in ('pendiente','aceptada','descartada'))
);

create table if not exists public.feedback (
  id      uuid primary key default gen_random_uuid(),
  sec     text not null check (char_length(sec) <= 200),             -- "general", "pagina" o "pagina.seccion"
  pagina  text not null check (char_length(pagina) <= 80),
  seccion text not null default '' check (char_length(seccion) <= 200),
  tipo    text not null default 'otro' check (tipo in ('contenido','estructura','diseno','duda','falta','otro')),
  texto   text not null check (char_length(texto) between 1 and 4000),
  autor   text not null check (char_length(autor) between 1 and 80),
  creado  timestamptz not null default now(),
  estado  text not null default 'pendiente' check (estado in ('pendiente','aceptada','descartada'))
);

-- Reglas: cualquiera con el enlace puede leer y añadir.
-- Solo se puede cambiar el estado (pendiente / aceptada / descartada). Nadie borra desde la web.
alter table public.propuestas enable row level security;
alter table public.feedback   enable row level security;

drop policy if exists "leer propuestas"   on public.propuestas;
drop policy if exists "crear propuestas"  on public.propuestas;
drop policy if exists "estado propuestas" on public.propuestas;
drop policy if exists "leer feedback"     on public.feedback;
drop policy if exists "crear feedback"    on public.feedback;
drop policy if exists "estado feedback"   on public.feedback;

create policy "leer propuestas"   on public.propuestas for select to anon using (true);
create policy "crear propuestas"  on public.propuestas for insert to anon with check (estado = 'pendiente');
create policy "estado propuestas" on public.propuestas for update to anon using (true) with check (true);
create policy "leer feedback"     on public.feedback   for select to anon using (true);
create policy "crear feedback"    on public.feedback   for insert to anon with check (estado = 'pendiente');
create policy "estado feedback"   on public.feedback   for update to anon using (true) with check (true);

revoke update on public.propuestas from anon;
revoke update on public.feedback   from anon;
grant  update (estado) on public.propuestas to anon;
grant  update (estado) on public.feedback   to anon;
revoke delete on public.propuestas from anon;
revoke delete on public.feedback   from anon;

-- Actualización en directo (lo que envía uno aparece a los demás sin recargar).
do $$ begin
  alter publication supabase_realtime add table public.propuestas;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.feedback;
exception when duplicate_object then null; end $$;

-- Respuestas: conversación bajo cada propuesta o feedback.
create table if not exists public.respuestas (
  id        uuid primary key default gen_random_uuid(),
  ref_tabla text not null check (ref_tabla in ('propuestas','feedback')),
  ref_id    uuid not null,
  texto     text not null check (char_length(texto) between 1 and 2000),
  autor     text not null check (char_length(autor) between 1 and 80),
  creado    timestamptz not null default now()
);
alter table public.respuestas enable row level security;
drop policy if exists "leer respuestas"  on public.respuestas;
drop policy if exists "crear respuestas" on public.respuestas;
create policy "leer respuestas"  on public.respuestas for select to anon using (true);
create policy "crear respuestas" on public.respuestas for insert to anon with check (true);
revoke update, delete on public.respuestas from anon;
do $$ begin
  alter publication supabase_realtime add table public.respuestas;
exception when duplicate_object then null; end $$;
