INSERT INTO Enderecos
VALUES (1, 'Rua A', 'Centro', '56300000', 'Petrolina', 'PE');

INSERT INTO Enderecos
VALUES (2, 'Rua B', 'Centro', '56300000', 'Petrolina', 'PE');

INSERT INTO Enderecos
VALUES (3, 'Rua C', 'Centro', '56300000', 'Petrolina', 'PE');

INSERT INTO Enderecos
VALUES (4, 'Rua D', 'Centro', '56300000', 'Petrolina', 'PE');


INSERT INTO Telefones
VALUES (1, '87991234567', NULL);

INSERT INTO Telefones
VALUES (2, '87998765432', '87988112233');

INSERT INTO Telefones
VALUES (3, '87996543210', NULL);

INSERT INTO Telefones
VALUES (4, '87999887766', NULL);


INSERT INTO Alunos
VALUES ('16899535009', '01', 'M', 'João Silva', 'joao.silva@teste.com', '2003-05-14', 1, 1);

INSERT INTO Alunos
VALUES ('93541134780', '02', 'F', 'Maria Souza', 'maria.souza@teste.com', '2001-11-02', 2, 2);

INSERT INTO Alunos
VALUES ('45317828791', '03', 'M', 'Pedro Alves', 'pedro.alves@teste.com', '2000-03-27', 3, 3);

INSERT INTO Alunos
VALUES ('39053344705', '04', 'F', 'Ana Lima', 'ana.lima@teste.com', '2004-08-19', 4, 4);


INSERT INTO Pagamentos
VALUES (1, 'pix', 'pago', '2026-09-01 10:00:00', '2026-09-10 23:59:59', '2026-09-02 09:30:00', '01', '16899535009');

INSERT INTO Pagamentos
VALUES (2, 'credito', 'pago', '2026-09-01 11:00:00', '2026-09-10 23:59:59', '2026-09-05 16:45:00', '02', '93541134780');

INSERT INTO Pagamentos
VALUES (3, 'debito', 'vencido', '2026-09-01 12:00:00', '2026-09-10 23:59:59', NULL, '03', '45317828791');

INSERT INTO Pagamentos
VALUES (4, 'pix', 'pendente', '2026-10-20 10:00:00', '2026-11-05 23:59:59', NULL, '04', '39053344705');


INSERT INTO Cursos
VALUES (1, 'Banco de Dados', 'Modelagem relacional, SQL e transações.', 'Curso introdutório de bancos de dados relacionais.');


INSERT INTO Inscricao
VALUES (1, '01', '16899535009', 350);

INSERT INTO Inscricao
VALUES (1, '02', '93541134780', 350);

INSERT INTO Inscricao
VALUES (1, '03', '45317828791', 350);

INSERT INTO Inscricao
VALUES (1, '04', '39053344705', 350);


INSERT INTO Turmas
VALUES (1, '2026-09-14', 20, 60, 'noite', 1);


INSERT INTO Alocado
VALUES (1, '01', '16899535009');

INSERT INTO Alocado
VALUES (1, '02', '93541134780');

INSERT INTO Alocado
VALUES (1, '03', '45317828791');

INSERT INTO Alocado
VALUES (1, '04', '39053344705');


INSERT INTO Atividades
VALUES (1, '2026-09-14 19:00:00', 'Aula 1: Modelo entidade-relacionamento', 4, 1);


INSERT INTO Participa
VALUES ('01', '16899535009', 1, TRUE, 9);

INSERT INTO Participa
VALUES ('02', '93541134780', 1, TRUE, 8);

INSERT INTO Participa
VALUES ('03', '45317828791', 1, FALSE, NULL);

INSERT INTO Participa
VALUES ('04', '39053344705', 1, TRUE, 10);


INSERT INTO Telefones
VALUES (5, '87991112233', NULL);

INSERT INTO Telefones
VALUES (6, '87992223344', NULL);

INSERT INTO Instrutores
VALUES ('52998224725', '01', 'Carlos Mendes', 'carlos.mendes@teste.com', 5);

INSERT INTO Instrutores
VALUES ('11144477735', '02', 'Fernanda Costa', 'fernanda.costa@teste.com', 6);


INSERT INTO monitora
VALUES (1, '52998224725', '01');

INSERT INTO monitora
VALUES (1, '11144477735', '02');

