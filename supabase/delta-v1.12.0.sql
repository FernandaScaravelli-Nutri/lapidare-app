-- ════════════════════════════════════════════════════════════════════
-- LAPIDARE · UPDATE v1.12.0 · PDF NA AVALIAÇÃO ANTROPOMÉTRICA
-- ════════════════════════════════════════════════════════════════════
-- O que faz: adiciona coluna "pdf_url" na tabela de avaliações
-- (peso_registros), permitindo a nutri anexar PDF da avaliação física
-- (presencial ou exportado do Shaped).
--
-- Como rodar (30 seg):
--   1. Supabase → SQL Editor → + New query
--   2. Cola TUDO desse arquivo → Run
--   3. Esperado: "Success. No rows returned"
--
-- 100% seguro: idempotente.
-- O bucket "documentos" já foi criado na v1.10.0 e é reutilizado aqui.
-- ════════════════════════════════════════════════════════════════════

alter table public.peso_registros
  add column if not exists pdf_url text;

-- ════════════════════════════════════════════════════════════════════
-- ✅ Pronto! Volta no app → perfil de uma paciente → aba "Avaliação"
-- → vai aparecer "PDF da avaliação (opcional)" abaixo das observações.
-- ════════════════════════════════════════════════════════════════════
