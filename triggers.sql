CREATE OR ALTER EXCEPTION EX_TURMA_LOTADA
    'Não há vagas disponíveis nesta turma';

CREATE OR ALTER EXCEPTION EX_PAGAMENTO_PENDENTE
    'O aluno não possui pagamento aprovado';

CREATE OR ALTER EXCEPTION EX_CARGA_HORARIA_MAXIMA_EXTRAPOLADA
	'A carga horaria da turma foi extrapolada';

CREATE OR ALTER EXCEPTION EX_UPDATE_STATUS_PAGAMENTO_INVALIDO
	'A atualização do status não segue a ordem correta';

CREATE OR ALTER EXCEPTION EX_UPDATE_DATA_DE_PAGAMENTO
	'Não enviar data de pagamento';

CREATE OR ALTER EXCEPTION EX_ALUNO_NAO_INSCRITO
	'O aluno deve esta inscrito em curso primeiro';

CREATE OR ALTER EXCEPTION EX_STATUS_INICIAL_INVALIDO
	'Um pagamento deve ser criado com status pendente.';

CREATE OR ALTER EXCEPTION EX_ALUNO_SEM_INSCRICAO
'O aluno precisa possuir uma inscricao para gerar um pagamento.';

SET TERM !;

CREATE OR ALTER TRIGGER validar_insert_alocada
FOR alocado
BEFORE INSERT
AS
	DECLARE VARIABLE cont_alunos INTEGER;
	DECLARE VARIABLE vagas_max INTEGER;
BEGIN
	IF (NOT EXISTS(
		SELECT 1 FROM PAGAMENTOS p
		WHERE p.fk_aluno_matricula = NEW.fk_aluno_matricula
			AND p.fk_aluno_CPF = NEW.fk_aluno_CPF
			AND p.status = 'pago'
		)
	)
	THEN
		EXCEPTION EX_PAGAMENTO_PENDENTE;

	SELECT COUNT(*) FROM ALOCADO a
	WHERE a.FK_TURMA = NEW.FK_TURMA
	INTO :cont_alunos;

	SELECT VAGAS_MAXIMAS FROM TURMAS t
	WHERE t.ID = NEW.fk_turma
	INTO :vagas_max;

	IF (:cont_alunos >= :vagas_max)
	THEN
		EXCEPTION EX_TURMA_LOTADA;
END!

CREATE OR ALTER TRIGGER validar_carga_horaria_atividade
FOR atividades
BEFORE INSERT
AS
DECLARE VARIABLE sum_carga DECIMAL(10,2);
DECLARE VARIABLE carga_max DECIMAL(10,2);
BEGIN
	SELECT (sum(a.carga_horaria),0) FROM atividades a
	WHERE a.fk_turma = NEW.fk_turma
	INTO :sum_carga;

	SELECT t.CARGA_HORARIA  FROM TURMAS t
	WHERE t.id = NEW.fk_turma
	INTO :carga_max;

	IF (:sum_carga + NEW.carga_horaria > :carga_max)
	THEN
		EXCEPTION EX_CARGA_HORARIA_MAXIMA_EXTRAPOLADA;
END!

CREATE OR ALTER TRIGGER validar_update_status_pagamento
FOR pagamentos
BEFORE UPDATE
AS
BEGIN
	-- Não permite alterar status depois que já está pago
	IF (OLD.status = 'pago') THEN
        EXCEPTION EX_UPDATE_STATUS_PAGAMENTO_INVALIDO;
	-- invalida transações
	IF (OLD.status = 'pendente' AND NEW.status NOT IN ('processando', 'vencido'))
	THEN
		EXCEPTION EX_UPDATE_STATUS_PAGAMENTO_INVALIDO;

	IF (OLD.status = 'processando' AND NEW.status NOT IN ('pago', 'vencido'))
	THEN
		EXCEPTION EX_UPDATE_STATUS_PAGAMENTO_INVALIDO;

	IF (OLD.status = 'vencido' AND NEW.status NOT IN ('processando')
	THEN
		EXCEPTION EX_UPDATE_STATUS_PAGAMENTO_INVALIDO;

END!

CREATE OR ALTER TRIGGER validar_data_de_pagamento_pagamentos
FOR pagamentos
BEFORE UPDATE
AS
BEGIN
	-- Se estiver mudando para 'pago', preenche a data automaticamente
    IF (NEW.status = 'pago' AND OLD.status <> 'pago') THEN
    BEGIN
        NEW.data_de_pagamento = CURRENT_TIMESTAMP;
    END
	ELSE 
	BEGIN
	-- Não permite alterar a data de pagamento manualmente em outros casos
        IF (NEW.data_de_pagamento IS DISTINCT FROM OLD.data_de_pagamento) THEN
        	EXCEPTION EX_UPDATE_DATA_DE_PAGAMENTO;
    END

END!


-- t-06 e t-05
CREATE OR ALTER TRIGGER VALIDAR_INSERT_PAGAMENTO
FOR PAGAMENTOS
ACTIVE BEFORE INSERT
POSITION 0
AS
DECLARE VARIABLE ALUNO_INSCRITO INTEGER;
BEGIN

    -- R1: O pagamento deve iniciar como pendente
    IF (NEW.STATUS IS NULL OR NEW.STATUS <> 'pendente') THEN
        EXCEPTION EX_STATUS_INICIAL_INVALIDO;

    -- R2: O aluno deve possuir uma inscrição
    SELECT COUNT(*)
    FROM INSCRICAO i
    WHERE i.fk_aluno_CPF = NEW.fk_aluno_CPF
      AND i.fk_aluno_matricula = NEW.fk_aluno_matricula
    INTO :ALUNO_INSCRITO;

    IF (ALUNO_INSCRITO = 0) THEN
        EXCEPTION EX_ALUNO_SEM_INSCRICAO;

END!

SET TERM ;!
