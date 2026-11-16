CREATE OR ALTER VIEW alunos_a_ser_alocados
AS
SELECT
	a.CPF,
	a.matricula,
	a.nome		AS aluno,
	c.nome		AS curso,
	p.data_de_pagamento,
	i.valor
FROM ALUNOS a
JOIN Inscricao i
ON  i.fk_aluno_CPF = a.CPF
AND i.fk_aluno_matricula = a.matricula
JOIN CURSOS c
ON c.id = i.fk_curso
JOIN PAGAMENTOS p
ON  p.fk_aluno_CPF = a.CPF
AND p.fk_aluno_matricula = a.matricula
WHERE p.status = 'pago'
;


CREATE OR ALTER VIEW tividades_das_turmas
AS
SELECT
	a.id,
	a.data_da_atividade,
	a.descricao,
	a.carga_horaria,
	t.id AS turma_id,
	(
		SELECT count(*) FROM PARTICIPA p
		WHERE p.fk_atividade = a.fk_turma
		AND p.frequencia = TRUE
	) AS quant_alunos_presentes,
	(
		SELECT count(*) FROM ALOCADO al
		WHERE al.fk_turma = a.fk_turma
	) AS quant_alunos_na_turma,
    CAST(
        (
            SELECT COUNT(*)
            FROM PARTICIPA p
            WHERE p.fk_atividade = a.fk_turma
              AND p.frequencia = TRUE
        ) AS DECIMAL(10,2)
    )
    /
    NULLIF(
        (
            SELECT COUNT(*)
            FROM ALOCADO al
            WHERE al.fk_turma = a.fk_turma
        ), 0
    ) * 100 AS taxa_de_presenca,
	(
        SELECT AVG(p.nota)
        FROM PARTICIPA p
        WHERE p.fk_atividade = a.id
    ) AS media_dos_alunos
FROM ATIVIDADES a
JOIN turmas t
ON a.fk_turma = t.id
ORDER BY a.data_da_atividade DESC
;
