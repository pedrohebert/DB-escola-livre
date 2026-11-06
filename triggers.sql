CREATE EXCEPTION EX_TURMA_LOTADA
    'Não há vagas disponíveis nesta turma';

CREATE EXCEPTION EX_PAGAMENTO_PENDENTE
    'O aluno não possui pagamento aprovado';

CREATE EXCEPTION EX_CARGA_HORARIA_MAXIMA_EXTRAPOLADA
	'A carga horaria da turma foi extrapolada';

SET TERM !;

CREATE TRIGGER validar_insert_alocada
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

CREATE TRIGGER validar_carga_horaria_atividade
FOR atividades
BEFORE INSERT
AS
DECLARE VARIABLE sum_carga integer;
DECLARE VARIABLE carga_max integer;
BEGIN
	SELECT sum(a.carga_horaria) FROM atividades a
	WHERE a.fk_turma = NEW.fk_turma
	INTO :sum_carga;

	SELECT t.CARGA_HORARIA  FROM TURMAS t
	WHERE t.id = NEW.fk_turma
	INTO :carga_max;

	IF (:sum_carga + NEW.carga_horaria > :carga_max)
	THEN
		EXCEPTION EX_CARGA_HORARIA_MAXIMA_EXTRAPOLADA;
END!

SET TERM ;!
