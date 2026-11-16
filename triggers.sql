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


SET TERM ;!
