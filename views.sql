CREATE VIEW alunos_a_ser_alocados
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
