-- =========================================================
-- Consultas de verificacao
-- =========================================================

SELECT * FROM Alunos;
SELECT * FROM Cursos;
SELECT * FROM Turmas;
SELECT * FROM Atividades;
SELECT * FROM Inscricao;
SELECT * FROM Alocado;
SELECT * FROM Participa;
SELECT * FROM monitora;
SELECT * FROM Pagamentos;

-- =========================================================
-- Consultas de verificacao de views
-- =========================================================

SELECT * FROM alunos_a_ser_alocados;
SELECT * FROM tividades_das_turmas;

/*Listar alunos, seus cursos e as turmas em que estão alocados*/
SELECT
    A.nome AS aluno,
    A.matricula,
    C.nome AS curso,
    T.id AS turma,
    T.data_de_inicio
FROM Alunos A
INNER JOIN Alocado AL
    ON AL.fk_aluno_CPF = A.CPF
    AND AL.fk_aluno_matricula = A.matricula
INNER JOIN Turmas T
    ON T.id = AL.fk_turma
INNER JOIN Cursos C
    ON C.id = T.fk_curso
ORDER BY A.nome;

/*Listar as turmas e seus respectivos instrutores*/
SELECT
    T.id AS turma,
    C.nome AS curso,
    I.nome AS instrutor,
    I.email,
    T.data_de_inicio,
    T.turno
FROM Turmas T
INNER JOIN Cursos C
    ON C.id = T.fk_curso
INNER JOIN monitora M
    ON M.fk_turmas = T.id
INNER JOIN Instrutores I
    ON I.CPF = M.fk_instrutores_CPF
    AND I.matricula = M.fk_instrutores_matricula
ORDER BY T.id;

/*Consultar frequência e notas dos alunos nas atividades*/
SELECT
    A.nome AS aluno,
    A.CPF,
    A.matricula,
    C.nome AS curso,
    T.id AS turma,
    ATV.id AS atividade,
    ATV.data_da_atividade,
    P.frequencia,
    P.nota
FROM Participa P
INNER JOIN Alunos A
    ON A.CPF = P.fk_aluno_CPF
    AND A.matricula = P.fk_aluno_matricula
INNER JOIN Atividades ATV
    ON ATV.id = P.fk_atividade
INNER JOIN Turmas T
    ON T.id = ATV.fk_turma
INNER JOIN Cursos C
    ON C.id = T.fk_curso
ORDER BY A.nome, ATV.data_da_atividade;

/*Identificar turmas com média geral de notas igual ou superior a 7*/
SELECT
    T.id AS turma,
    C.nome AS curso,
    AVG(P.nota) AS media_geral
FROM Turmas T
INNER JOIN Cursos C
    ON C.id = T.fk_curso
INNER JOIN Atividades ATV
    ON ATV.fk_turma = T.id
INNER JOIN Participa P
    ON P.fk_atividade = ATV.id
GROUP BY
    T.id,
    C.nome
HAVING AVG(P.nota) >= 7
ORDER BY media_geral DESC;

/*Listar alunos que possuem notas acima da média geral*/
SELECT
    A.nome AS aluno,
    A.matricula,
    C.nome AS curso,
    T.id AS turma,
    ATV.id AS atividade,
    P.nota
FROM Alunos A
INNER JOIN Participa P
    ON P.fk_aluno_CPF = A.CPF
    AND P.fk_aluno_matricula = A.matricula
INNER JOIN Atividades ATV
    ON ATV.id = P.fk_atividade
INNER JOIN Turmas T
    ON T.id = ATV.fk_turma
INNER JOIN Cursos C
    ON C.id = T.fk_curso
WHERE P.nota > (
    SELECT AVG(P2.nota)
    FROM Participa P2
)
ORDER BY P.nota DESC;

/*Situação dos pagamentos*/
SELECT
    A.nome AS ALUNO,
    C.nome AS CURSO,
    P.status AS SITUACAO_PAGAMENTO,
    P.forma_de_pagamento AS FORMA_PAGAMENTO,
    P.data_de_venciemento AS DATA_VENCIMENTO,
    CASE
        WHEN P.status = 'pago' THEN 0
        WHEN P.data_de_venciemento < CURRENT_DATE
             AND P.status <> 'pago'
        THEN DATEDIFF(DAY FROM P.data_de_venciemento TO CURRENT_DATE)
        ELSE 0
    END AS DIAS_EM_ATRASO
FROM Alunos A
INNER JOIN Inscricao I
    ON I.fk_aluno_CPF = A.CPF
    AND I.fk_aluno_matricula = A.matricula
INNER JOIN Cursos C
    ON C.id = I.fk_curso
LEFT JOIN Pagamentos P
    ON P.fk_aluno_CPF = A.CPF
    AND P.fk_aluno_matricula = A.matricula
ORDER BY
    A.nome,
    C.nome;

/*Identificar atividades cuja carga horária é superior à média das atividades da mesma turma*/
SELECT
    ATV.id AS atividade,
    ATV.fk_turma AS turma,
    ATV.data_da_atividade,
    ATV.carga_horaria
FROM Atividades ATV
WHERE ATV.carga_horaria > (
    SELECT AVG(AT2.carga_horaria)
    FROM Atividades AT2
    WHERE AT2.fk_turma = ATV.fk_turma
)
ORDER BY ATV.fk_turma, ATV.carga_horaria DESC;

/*Vagas disponíveis por turma*/
SELECT
    T.id AS ID_TURMA,
    T.data_de_inicio AS DATA_INICIO,
    C.nome AS CURSO,
    T.vagas_maximas AS CAPACIDADE_MAXIMA,
    COUNT(AL.fk_aluno_matricula) AS ALUNOS_ALOCADOS,
    T.vagas_maximas - COUNT(AL.fk_aluno_matricula) AS VAGAS_RESTANTES,
    T.turno AS TURNO,
    T.carga_horaria AS CARGA_HORARIA_TOTAL
FROM Turmas T
INNER JOIN Cursos C
    ON C.id = T.fk_curso
LEFT JOIN Alocado AL
    ON AL.fk_turma = T.id
GROUP BY
    T.id,
    T.data_de_inicio,
    C.nome,
    T.vagas_maximas,
    T.turno,
    T.carga_horaria
ORDER BY T.id;

/*Consultar quantidade de atividades e carga horária por turma */
SELECT
    T.id AS turma,
    C.nome AS curso,
    T.carga_horaria AS carga_horaria_turma,
    COUNT(ATV.id) AS total_atividades,
    COALESCE(SUM(ATV.carga_horaria), 0) AS carga_horaria_atividades,
    T.carga_horaria -
        COALESCE(SUM(ATV.carga_horaria), 0) AS carga_horaria_restante
FROM Turmas T
INNER JOIN Cursos C
    ON C.id = T.fk_curso
LEFT JOIN Atividades ATV
    ON ATV.fk_turma = T.id
GROUP BY
    T.id,
    C.nome,
    T.carga_horaria
ORDER BY T.id;

/*Identificar alunos aptos a receber certificado */
SELECT
    A.nome AS aluno,
    A.CPF,
    A.matricula,
    C.nome AS curso,
    T.id AS turma,
    AVG(P.nota) AS media_final,
    100.0 * SUM(
        CASE
            WHEN P.frequencia = TRUE
            THEN ATV.carga_horaria
            ELSE 0
        END
    ) / NULLIF(SUM(ATV.carga_horaria), 0) AS percentual_frequencia,
    SUM(
        CASE
            WHEN P.frequencia = TRUE
            THEN ATV.carga_horaria
            ELSE 0
        END
    ) AS carga_horaria_cumprida
FROM Alunos A
INNER JOIN Alocado AL
    ON AL.fk_aluno_CPF = A.CPF
    AND AL.fk_aluno_matricula = A.matricula
INNER JOIN Turmas T
    ON T.id = AL.fk_turma
INNER JOIN Cursos C
    ON C.id = T.fk_curso
INNER JOIN Atividades ATV
    ON ATV.fk_turma = T.id
LEFT JOIN Participa P
    ON P.fk_atividade = ATV.id
    AND P.fk_aluno_CPF = A.CPF
    AND P.fk_aluno_matricula = A.matricula
GROUP BY
    A.nome,
    A.CPF,
    A.matricula,
    C.nome,
    T.id,
    T.carga_horaria
HAVING
    AVG(P.nota) >= 7
    AND COUNT(P.nota) = COUNT(ATV.id)
    AND 100.0 * SUM(
        CASE
            WHEN P.frequencia = TRUE
            THEN ATV.carga_horaria
            ELSE 0
        END
    ) / NULLIF(SUM(ATV.carga_horaria), 0) > 70
    AND SUM(
        CASE
            WHEN P.frequencia = TRUE
            THEN ATV.carga_horaria
            ELSE 0
        END
    ) >= T.carga_horaria
    AND SUM(ATV.carga_horaria) = T.carga_horaria
ORDER BY A.nome;
