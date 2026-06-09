-- ════════════════════════════════════════════════════════════════════
-- LAPIDARE · UPDATE v1.10.0 · PDF DO PLANO/SUBSTITUIÇÕES/COMPRAS
-- ════════════════════════════════════════════════════════════════════
-- O que faz:
--   - Adiciona coluna "pdf_url" nas tabelas planos, substituicoes, listas_compras
--   - Cria bucket "documentos" no Storage pra guardar os PDFs
--   - Configura as permissões (nutri sobe, paciente baixa)
--
-- Como rodar (1 minuto):
--   1. Supabase → SQL Editor → + New query
--   2. Cola TUDO desse arquivo
--   3. Run (Cmd+Enter)
--   4. Esperado: "Success. No rows returned"
--
-- 100% seguro: idempotente (pode rodar de novo sem duplicar nada).
-- ════════════════════════════════════════════════════════════════════

-- 1. Coluna nova nas tabelas existentes
alter table public.planos          add column if not exists pdf_url text;
alter table public.substituicoes   add column if not exists pdf_url text;
alter table public.listas_compras  add column if not exists pdf_url text;

-- 2. Bucket público de documentos (path contém UUIDs, é não-adivinhável)
insert into storage.buckets (id, name, public)
  values ('documentos', 'documentos', true)
on conflict (id) do nothing;

-- 3. Permissões: nutri faz upload/delete, qualquer um lê (precisa da URL exata)
drop policy if exists documentos_select on storage.objects;
create policy documentos_select on storage.objects
  for select using (bucket_id = 'documentos');

drop policy if exists documentos_insert on storage.objects;
create policy documentos_insert on storage.objects
  for insert with check (
    bucket_id = 'documentos' and auth.uid() is not null
  );

drop policy if exists documentos_update on storage.objects;
create policy documentos_update on storage.objects
  for update using (
    bucket_id = 'documentos' and auth.uid() is not null
  );

drop policy if exists documentos_delete on storage.objects;
create policy documentos_delete on storage.objects
  for delete using (
    bucket_id = 'documentos' and auth.uid() is not null
  );

-- ════════════════════════════════════════════════════════════════════
-- ✅ Pronto! Volta no seu app → perfil de uma paciente → aba Plano
-- (ou Substituições, ou Compras) → agora aparece o campo "PDF (opcional)".
-- ════════════════════════════════════════════════════════════════════
