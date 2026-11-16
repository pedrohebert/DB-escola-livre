CREATE OR ALTER VIEW VW_BASE_DESEMPENHO_ALUNO AS
SELECT
    al.fk_turma,
    a.CPF,
    a.matricula,
    a.nome,
    t.total_ativ,
    SUM(CASE WHEN p.frequencia = TRUE THEN 1 ELSE 0 END) AS presencas,
    AVG(p.nota) AS media_bruta
FROM Alocado al
JOIN Alunos a
  ON a.CPF = al.fk_aluno_CPF
 AND a.matricula = al.fk_aluno_matricula
LEFT JOIN (SELECT fk_turma, COUNT(*) AS total_ativ
             FROM Atividades
            GROUP BY fk_turma) t
  ON t.fk_turma = al.fk_turma
LEFT JOIN Atividades atv
  ON atv.fk_turma = al.fk_turma
LEFT JOIN Participa p
  ON p.fk_atividade = atv.id
 AND p.fk_aluno_CPF = a.CPF
 AND p.fk_aluno_matricula = a.matricula
GROUP BY al.fk_turma, a.CPF, a.matricula, a.nome, t.total_ativ;


SELECT
    fk_turma,
    CPF,
    matricula,
    nome,
    total_ativ,
    presencas,
    CASE WHEN total_ativ > 0
         THEN CAST(presencas * 100.0 / total_ativ AS DECIMAL(5,2))
         ELSE 0
    END AS perc_freq,
    CAST(media_bruta AS DECIMAL(5,2)) AS media,
    CASE
        WHEN total_ativ IS NULL THEN 'Sem atividades registradas'
        WHEN (presencas * 100.0 / total_ativ) < 75 THEN 'Reprovado por frequência'
        WHEN COALESCE(media_bruta, 0) < 6 THEN 'Reprovado por desempenho'
        ELSE 'Aprovado - apto a certificado'
    END AS situacao
FROM VW_BASE_DESEMPENHO_ALUNO
WHERE fk_turma = 1; -- Exemplo de filtro opcional
