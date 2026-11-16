SET TERM ! ;
CREATE PROCEDURE SP_ALOCAR_ALUNOS (
    P_MATRICULA CHAR(8),
    P_CPF CHAR(11),
    P_ID_TURMA INTEGER
)
AS
DECLARE VARIABLE V_EXISTE_ALUNO INTEGER;
DECLARE VARIABLE V_TEM_PAGAMENTO INTEGER;
DECLARE VARIABLE V_VAGAS_MAXIMAS INTEGER;
DECLARE VARIABLE V_ALUNOS_ALOCADOS INTEGER;
DECLARE VARIABLE V_JA_ALOCADO INTEGER;
BEGIN
    SELECT COUNT(*) 
      FROM Alunos 
     WHERE CPF = :P_CPF AND matricula = :P_MATRICULA
      INTO :V_EXISTE_ALUNO;

    IF (V_EXISTE_ALUNO = 0) THEN
        EXCEPTION EX_REGRA_ALOCACAO 'Aluno não encontrado com o CPF e matrícula informados.';

    SELECT COUNT(*)
      FROM Pagamentos
     WHERE fk_aluno_CPF = :P_CPF
       AND fk_aluno_matricula = :P_MATRICULA
       AND status = 'pago'
      INTO :V_TEM_PAGAMENTO;

    IF (V_TEM_PAGAMENTO = 0) THEN
        EXCEPTION EX_REGRA_ALOCACAO 'Alocação negada: o aluno não possui pagamento com status pago.';

    SELECT COUNT(*)
      FROM Alocado
     WHERE fk_aluno_CPF = :P_CPF
       AND fk_aluno_matricula = :P_MATRICULA
      INTO :V_JA_ALOCADO;

    IF (V_JA_ALOCADO > 0) THEN
        EXCEPTION EX_REGRA_ALOCACAO 'Alocação negada: o aluno já está alocado em uma turma.';

    SELECT vagas_maximas
      FROM Turmas
     WHERE id = :P_ID_TURMA
      INTO :V_VAGAS_MAXIMAS;

    IF (V_VAGAS_MAXIMAS IS NULL) THEN
        EXCEPTION EX_REGRA_ALOCACAO 'Turma informada não existe.';

    SELECT COUNT(*)
      FROM Alocado
     WHERE fk_turma = :P_ID_TURMA
      INTO :V_ALUNOS_ALOCADOS;

    IF (V_ALUNOS_ALOCADOS >= V_VAGAS_MAXIMAS) THEN
        EXCEPTION EX_REGRA_ALOCACAO 'Alocação negada: não há vagas disponíveis nesta turma.';

    INSERT INTO Alocado (fk_turma, fk_aluno_matricula, fk_aluno_CPF)
    VALUES (:P_ID_TURMA, :P_MATRICULA, :P_CPF);
END!
SET TERM ;!

SET TERM ! ;

CREATE OR ALTER PROCEDURE SP_REGISTRAR_PAGAMENTO (
    P_ID_PAGAMENTO INTEGER,
    P_MATRICULA CHAR(8),
    P_CPF CHAR(11),
    P_FORMA_PAGAMENTO VARCHAR(50),
    P_DATA_PAGAMENTO TIMESTAMP
)
AS
DECLARE VARIABLE V_CONTADOR INTEGER;
BEGIN
    -- 1. Se foi informado o ID do pagamento diretamente, atualiza o registro existente
    IF (:P_ID_PAGAMENTO IS NOT NULL) THEN
    BEGIN
        UPDATE Pagamentos
           SET status = 'pago',
               data_de_pagamento = :P_DATA_PAGAMENTO
               -- Descomente a linha abaixo se a sua tabela tiver a coluna forma_pagamento:
               -- , forma_pagamento = :P_FORMA_PAGAMENTO
         WHERE id = :P_ID_PAGAMENTO;
    END
    -- 2. Se foi informado Matrícula e CPF, busca se já existe pagamento em aberto para atualizar
    ELSE IF (:P_MATRICULA IS NOT NULL AND :P_CPF IS NOT NULL) THEN
    BEGIN
        SELECT COUNT(*) 
          FROM Pagamentos 
         WHERE fk_aluno_matricula = :P_MATRICULA 
           AND fk_aluno_CPF = :P_CPF
           AND status <> 'pago'
          INTO :V_CONTADOR;

        IF (:V_CONTADOR > 0) THEN
        BEGIN
            UPDATE Pagamentos
               SET status = 'pago',
                   data_de_pagamento = :P_DATA_PAGAMENTO
             WHERE fk_aluno_matricula = :P_MATRICULA 
               AND fk_aluno_CPF = :P_CPF
               AND status <> 'pago';
        END
        ELSE
        BEGIN
            -- Se não existir nenhum registro pendente, cria um novo pagamento já com status pago
            INSERT INTO Pagamentos (fk_aluno_matricula, fk_aluno_CPF, status, data_de_pagamento)
            VALUES (:P_MATRICULA, :P_CPF, 'pago', :P_DATA_PAGAMENTO);
        END
    END
END!

SET TERM ; !
