/*
  MASSA DE DADOS DE TESTE - BANCO ESCOLAR
  SGBD: Firebird

  Execute este arquivo depois de criar as tabelas, exceptions e triggers.

  Observacoes:
  1. Os dados pessoais sao ficticios.
  2. Os IDs identity sao recuperados por subconsultas.
  3. O trigger validar_update_status_pagamento e desativado temporariamente
     porque, na versao apresentada, ele bloqueia PENDENTE -> PAGO.
  4. O trigger validar_data_de_pagamento_pagamentos permanece ativo e deve
     preencher data_de_pagamento quando o status mudar para PAGO.
*/

-- =========================================================
-- 1. ENDERECOS
-- =========================================================

INSERT INTO Enderecos (rua, bairro, cep, cidade, estado)
VALUES ('Rua das Flores', 'Centro', '56300001', 'Petrolina', 'PE');

INSERT INTO Enderecos (rua, bairro, cep, cidade, estado)
VALUES ('Rua do Sol', 'Areia Branca', '56300002', 'Petrolina', 'PE');

INSERT INTO Enderecos (rua, bairro, cep, cidade, estado)
VALUES ('Av. Principal', 'Jardim Amazonas', '56300003', 'Petrolina', 'PE');

INSERT INTO Enderecos (rua, bairro, cep, cidade, estado)
VALUES ('Rua Bahia', 'Gercino Coelho', '56300004', 'Petrolina', 'PE');

INSERT INTO Enderecos (rua, bairro, cep, cidade, estado)
VALUES ('Rua Pernambuco', 'Centro', '56300005', 'Petrolina', 'PE');

INSERT INTO Enderecos (rua, bairro, cep, cidade, estado)
VALUES ('Rua Sao Joao', 'Sao Jose', '56300006', 'Petrolina', 'PE');


-- =========================================================
-- 2. TELEFONES
-- =========================================================

INSERT INTO Telefones (telefone_1, telefone_2)
VALUES ('87999990001', '87988880001');

INSERT INTO Telefones (telefone_1, telefone_2)
VALUES ('87999990002', NULL);

INSERT INTO Telefones (telefone_1, telefone_2)
VALUES ('87999990003', '87988880003');

INSERT INTO Telefones (telefone_1, telefone_2)
VALUES ('87999990004', NULL);

INSERT INTO Telefones (telefone_1, telefone_2)
VALUES ('87999990005', NULL);

INSERT INTO Telefones (telefone_1, telefone_2)
VALUES ('87999990006', NULL);

INSERT INTO Telefones (telefone_1, telefone_2)
VALUES ('87999990007', NULL);


-- =========================================================
-- 3. ALUNOS
-- =========================================================

INSERT INTO Alunos (
    CPF, matricula, sexo, nome, email,
    data_de_nacimento, fk_telefone, fk_endereco
)
VALUES (
    '11111111111', '20260001', 'M',
    'Joao Silva', 'joao@email.com',
    DATE '2005-04-10',
    (SELECT id FROM Telefones WHERE telefone_1 = '87999990001'),
    (SELECT id FROM Enderecos WHERE cep = '56300001')
);

INSERT INTO Alunos (
    CPF, matricula, sexo, nome, email,
    data_de_nacimento, fk_telefone, fk_endereco
)
VALUES (
    '22222222222', '20260002', 'F',
    'Maria Santos', 'maria@email.com',
    DATE '2004-08-15',
    (SELECT id FROM Telefones WHERE telefone_1 = '87999990002'),
    (SELECT id FROM Enderecos WHERE cep = '56300002')
);

INSERT INTO Alunos (
    CPF, matricula, sexo, nome, email,
    data_de_nacimento, fk_telefone, fk_endereco
)
VALUES (
    '33333333333', '20260003', 'M',
    'Pedro Oliveira', 'pedro@email.com',
    DATE '2005-01-20',
    (SELECT id FROM Telefones WHERE telefone_1 = '87999990003'),
    (SELECT id FROM Enderecos WHERE cep = '56300003')
);

INSERT INTO Alunos (
    CPF, matricula, sexo, nome, email,
    data_de_nacimento, fk_telefone, fk_endereco
)
VALUES (
    '44444444444', '20260004', 'F',
    'Ana Costa', 'ana@email.com',
    DATE '2006-11-05',
    (SELECT id FROM Telefones WHERE telefone_1 = '87999990004'),
    (SELECT id FROM Enderecos WHERE cep = '56300004')
);


-- =========================================================
-- 4. INSTRUTORES
-- =========================================================

INSERT INTO Instrutores (CPF, matricula, nome, email, fk_telefone)
VALUES (
    '55555555555', 'INST000001', 'Carlos Mendes', 'carlos@email.com',
    (SELECT id FROM Telefones WHERE telefone_1 = '87999990005')
);

INSERT INTO Instrutores (CPF, matricula, nome, email, fk_telefone)
VALUES (
    '66666666666', 'INST000002', 'Fernanda Lima', 'fernanda@email.com',
    (SELECT id FROM Telefones WHERE telefone_1 = '87999990006')
);

INSERT INTO Instrutores (CPF, matricula, nome, email, fk_telefone)
VALUES (
    '77777777777', 'INST000003', 'Ricardo Alves', 'ricardo@email.com',
    (SELECT id FROM Telefones WHERE telefone_1 = '87999990007')
);


-- =========================================================
-- 5. CURSOS
-- =========================================================

INSERT INTO Cursos (nome, ementa, descricao)
VALUES (
    'Desenvolvimento Web',
    'HTML, CSS, JavaScript e desenvolvimento de aplicacoes web.',
    'Curso voltado para desenvolvimento de aplicacoes web modernas.'
);

INSERT INTO Cursos (nome, ementa, descricao)
VALUES (
    'Banco de Dados',
    'Modelagem, SQL, normalizacao e administracao de bancos de dados.',
    'Curso de fundamentos e praticas de bancos de dados relacionais.'
);

INSERT INTO Cursos (nome, ementa, descricao)
VALUES (
    'Redes de Computadores',
    'Protocolos, arquitetura de redes e infraestrutura.',
    'Curso de fundamentos de redes de computadores.'
);


-- =========================================================
-- 6. TURMAS
-- =========================================================

INSERT INTO Turmas (
    data_de_inicio, vagas_maximas, carga_horaria, turno, fk_curso
)
VALUES (
    DATE '2026-12-01', 2, 40, 'manha',
    (SELECT id FROM Cursos WHERE nome = 'Desenvolvimento Web')
);

INSERT INTO Turmas (
    data_de_inicio, vagas_maximas, carga_horaria, turno, fk_curso
)
VALUES (
    DATE '2026-12-05', 3, 60, 'noite',
    (SELECT id FROM Cursos WHERE nome = 'Banco de Dados')
);

INSERT INTO Turmas (
    data_de_inicio, vagas_maximas, carga_horaria, turno, fk_curso
)
VALUES (
    DATE '2026-12-10', 2, 50, 'tarde',
    (SELECT id FROM Cursos WHERE nome = 'Redes de Computadores')
);


-- =========================================================
-- 7. INSCRICOES
-- O trigger de pagamento exige uma inscricao existente.
-- =========================================================

-- Desenvolvimento Web
INSERT INTO Inscricao (fk_curso, fk_aluno_matricula, fk_aluno_CPF, valor)
VALUES (
    (SELECT id FROM Cursos WHERE nome = 'Desenvolvimento Web'),
    '20260001', '11111111111', 500.00
);

INSERT INTO Inscricao (fk_curso, fk_aluno_matricula, fk_aluno_CPF, valor)
VALUES (
    (SELECT id FROM Cursos WHERE nome = 'Desenvolvimento Web'),
    '20260002', '22222222222', 500.00
);

-- Banco de Dados
INSERT INTO Inscricao (fk_curso, fk_aluno_matricula, fk_aluno_CPF, valor)
VALUES (
    (SELECT id FROM Cursos WHERE nome = 'Banco de Dados'),
    '20260003', '33333333333', 450.00
);

INSERT INTO Inscricao (fk_curso, fk_aluno_matricula, fk_aluno_CPF, valor)
VALUES (
    (SELECT id FROM Cursos WHERE nome = 'Banco de Dados'),
    '20260004', '44444444444', 450.00
);

-- Redes de Computadores
INSERT INTO Inscricao (fk_curso, fk_aluno_matricula, fk_aluno_CPF, valor)
VALUES (
    (SELECT id FROM Cursos WHERE nome = 'Redes de Computadores'),
    '20260001', '11111111111', 400.00
);


-- =========================================================
-- 8. PAGAMENTOS
-- O status inicial sera 'pendente' pelo DEFAULT da tabela.
-- =========================================================

INSERT INTO Pagamentos (
    forma_de_pagamento, data_de_vencimento,
    fk_aluno_matricula, fk_aluno_CPF
)
VALUES (
    'pix', DATEADD(30 DAY TO CURRENT_TIMESTAMP),
    '20260001', '11111111111'
);

INSERT INTO Pagamentos (
    forma_de_pagamento, data_de_vencimento,
    fk_aluno_matricula, fk_aluno_CPF
)
VALUES (
    'credito', DATEADD(30 DAY TO CURRENT_TIMESTAMP),
    '20260002', '22222222222'
);

INSERT INTO Pagamentos (
    forma_de_pagamento, data_de_vencimento,
    fk_aluno_matricula, fk_aluno_CPF
)
VALUES (
    'debito', DATEADD(30 DAY TO CURRENT_TIMESTAMP),
    '20260003', '33333333333'
);

INSERT INTO Pagamentos (
    forma_de_pagamento, data_de_vencimento,
    fk_aluno_matricula, fk_aluno_CPF
)
VALUES (
    'pix', DATEADD(30 DAY TO CURRENT_TIMESTAMP),
    '20260004', '44444444444'
);


-- =========================================================
-- 9. APROVACAO DOS PAGAMENTOS
-- O trigger de status apresentado bloqueia PENDENTE -> PAGO.
-- Desativamos somente esse trigger durante a preparacao.
-- O trigger de data de pagamento continua ativo.
-- =========================================================

ALTER TRIGGER validar_update_status_pagamento INACTIVE;

UPDATE Pagamentos
SET status = 'pago'
WHERE fk_aluno_CPF IN (
    '11111111111',
    '22222222222',
    '33333333333',
    '44444444444'
);

ALTER TRIGGER validar_update_status_pagamento ACTIVE;


-- =========================================================
-- 10. ALOCACOES
-- O trigger exige pagamento com status 'pago' e vaga disponivel.
-- =========================================================

-- Turma de Desenvolvimento Web
INSERT INTO Alocado (fk_turma, fk_aluno_matricula, fk_aluno_CPF)
VALUES (
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-01' AND turno = 'manha'),
    '20260001', '11111111111'
);

INSERT INTO Alocado (fk_turma, fk_aluno_matricula, fk_aluno_CPF)
VALUES (
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-01' AND turno = 'manha'),
    '20260002', '22222222222'
);

-- Turma de Banco de Dados
INSERT INTO Alocado (fk_turma, fk_aluno_matricula, fk_aluno_CPF)
VALUES (
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-05' AND turno = 'noite'),
    '20260003', '33333333333'
);

INSERT INTO Alocado (fk_turma, fk_aluno_matricula, fk_aluno_CPF)
VALUES (
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-05' AND turno = 'noite'),
    '20260004', '44444444444'
);


-- =========================================================
-- 11. ATIVIDADES
-- A soma das cargas horarias fica abaixo do limite de cada turma.
-- =========================================================

-- Desenvolvimento Web: 10 + 10 + 15 = 35 horas (limite 40)
INSERT INTO Atividades (
    data_da_atividade, descricao, carga_horaria, fk_turma
)
VALUES (
    TIMESTAMP '2026-12-02 08:00:00',
    'Introducao ao HTML', 10,
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-01' AND turno = 'manha')
);

INSERT INTO Atividades (
    data_da_atividade, descricao, carga_horaria, fk_turma
)
VALUES (
    TIMESTAMP '2026-12-03 08:00:00',
    'Estilizacao com CSS', 10,
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-01' AND turno = 'manha')
);

INSERT INTO Atividades (
    data_da_atividade, descricao, carga_horaria, fk_turma
)
VALUES (
    TIMESTAMP '2026-12-04 08:00:00',
    'JavaScript basico', 15,
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-01' AND turno = 'manha')
);

-- Banco de Dados: 20 + 20 = 40 horas (limite 60)
INSERT INTO Atividades (
    data_da_atividade, descricao, carga_horaria, fk_turma
)
VALUES (
    TIMESTAMP '2026-12-06 19:00:00',
    'Modelagem de dados', 20,
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-05' AND turno = 'noite')
);

INSERT INTO Atividades (
    data_da_atividade, descricao, carga_horaria, fk_turma
)
VALUES (
    TIMESTAMP '2026-12-07 19:00:00',
    'Consultas SQL', 20,
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-05' AND turno = 'noite')
);

-- Redes: 25 + 20 = 45 horas (limite 50)
INSERT INTO Atividades (
    data_da_atividade, descricao, carga_horaria, fk_turma
)
VALUES (
    TIMESTAMP '2026-12-11 14:00:00',
    'Fundamentos de redes', 25,
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-10' AND turno = 'tarde')
);

INSERT INTO Atividades (
    data_da_atividade, descricao, carga_horaria, fk_turma
)
VALUES (
    TIMESTAMP '2026-12-12 14:00:00',
    'Protocolos de comunicacao', 20,
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-10' AND turno = 'tarde')
);


-- =========================================================
-- 12. PARTICIPACOES
-- =========================================================

-- Joao: Desenvolvimento Web
INSERT INTO Participa (
    fk_aluno_matricula, fk_aluno_CPF, fk_atividade, frequencia, nota
)
VALUES (
    '20260001', '11111111111',
    (SELECT id FROM Atividades
     WHERE data_da_atividade = TIMESTAMP '2026-12-02 08:00:00'),
    TRUE, 9.0
);

INSERT INTO Participa (
    fk_aluno_matricula, fk_aluno_CPF, fk_atividade, frequencia, nota
)
VALUES (
    '20260001', '11111111111',
    (SELECT id FROM Atividades
     WHERE data_da_atividade = TIMESTAMP '2026-12-03 08:00:00'),
    TRUE, 8.5
);

-- Maria: Desenvolvimento Web
INSERT INTO Participa (
    fk_aluno_matricula, fk_aluno_CPF, fk_atividade, frequencia, nota
)
VALUES (
    '20260002', '22222222222',
    (SELECT id FROM Atividades
     WHERE data_da_atividade = TIMESTAMP '2026-12-02 08:00:00'),
    TRUE, 9.5
);

-- Pedro: Banco de Dados
INSERT INTO Participa (
    fk_aluno_matricula, fk_aluno_CPF, fk_atividade, frequencia, nota
)
VALUES (
    '20260003', '33333333333',
    (SELECT id FROM Atividades
     WHERE data_da_atividade = TIMESTAMP '2026-12-06 19:00:00'),
    TRUE, 8.0
);

INSERT INTO Participa (
    fk_aluno_matricula, fk_aluno_CPF, fk_atividade, frequencia, nota
)
VALUES (
    '20260003', '33333333333',
    (SELECT id FROM Atividades
     WHERE data_da_atividade = TIMESTAMP '2026-12-07 19:00:00'),
    TRUE, 9.0
);

-- Ana: Banco de Dados
INSERT INTO Participa (
    fk_aluno_matricula, fk_aluno_CPF, fk_atividade, frequencia, nota
)
VALUES (
    '20260004', '44444444444',
    (SELECT id FROM Atividades
     WHERE data_da_atividade = TIMESTAMP '2026-12-06 19:00:00'),
    TRUE, 10.0
);


-- =========================================================
-- 13. MONITORA
-- =========================================================

INSERT INTO Monitora (
    fk_turmas, fk_instrutores_CPF, fk_instrutores_matricula
)
VALUES (
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-01' AND turno = 'manha'),
    '55555555555', 'INST000001'
);

INSERT INTO Monitora (
    fk_turmas, fk_instrutores_CPF, fk_instrutores_matricula
)
VALUES (
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-05' AND turno = 'noite'),
    '66666666666', 'INST000002'
);

INSERT INTO Monitora (
    fk_turmas, fk_instrutores_CPF, fk_instrutores_matricula
)
VALUES (
    (SELECT id FROM Turmas
     WHERE data_de_inicio = DATE '2026-12-10' AND turno = 'tarde'),
    '77777777777', 'INST000003'
);


-- =========================================================
-- 14. CONSULTAS DE CONFERENCIA
-- Execute separadamente, se desejar conferir os resultados.
-- =========================================================

-- Registros das tabelas
-- SELECT * FROM Enderecos;
-- SELECT * FROM Telefones;
-- SELECT * FROM Alunos;
-- SELECT * FROM Instrutores;
-- SELECT * FROM Cursos;
-- SELECT * FROM Turmas;
-- SELECT * FROM Inscricao;
-- SELECT * FROM Pagamentos;
-- SELECT * FROM Alocado;
-- SELECT * FROM Atividades;
-- SELECT * FROM Participa;
-- SELECT * FROM Monitora;

-- Alunos, inscricoes e cursos
-- SELECT
--     a.nome,
--     a.matricula,
--     c.nome AS curso,
--     i.valor
-- FROM Alunos a
-- JOIN Inscricao i
--     ON i.fk_aluno_CPF = a.CPF
--     AND i.fk_aluno_matricula = a.matricula
-- JOIN Cursos c
--     ON c.id = i.fk_curso;

-- Pagamentos dos alunos
-- SELECT
--     a.nome,
--     p.forma_de_pagamento,
--     p.status,
--     p.data_de_criacao,
--     p.data_de_vencimento,
--     p.data_de_pagamento
-- FROM Pagamentos p
-- JOIN Alunos a
--     ON a.CPF = p.fk_aluno_CPF
--     AND a.matricula = p.fk_aluno_matricula;

-- Ocupacao das turmas
-- SELECT
--     t.id,
--     c.nome AS curso,
--     t.vagas_maximas,
--     COUNT(al.fk_aluno_CPF) AS alunos_matriculados,
--     t.vagas_maximas - COUNT(al.fk_aluno_CPF) AS vagas_disponiveis
-- FROM Turmas t
-- JOIN Cursos c ON c.id = t.fk_curso
-- LEFT JOIN Alocado al ON al.fk_turma = t.id
-- GROUP BY t.id, c.nome, t.vagas_maximas;

-- Carga horaria utilizada nas turmas
-- SELECT
--     t.id,
--     c.nome AS curso,
--     t.carga_horaria AS carga_maxima,
--     COALESCE(SUM(a.carga_horaria), 0) AS carga_utilizada
-- FROM Turmas t
-- JOIN Cursos c ON c.id = t.fk_curso
-- LEFT JOIN Atividades a ON a.fk_turma = t.id
-- GROUP BY t.id, c.nome, t.carga_horaria;
