# documento compartilhado:

https://docs.google.com/document/d/1N8fVItlQHlc3d8A3M6tPlp3m2mhZFzzxIxvzMg-CK-E/edit?tab=t.0
> [!NOTE]
> entrar com email educacional

# estrutura de arquivos:
![](imagens/image.png)
---
# triggers

### alocado 
- [x] feito  

pre-insert.  
verificar se o pagamento respectivo está com status pago e se a turma está com vagas disponíveis.  

---
### atividade
- [x] feito  

pre-insert.  
verificar se a soma das cargas horarias das atividades da turma superam a carga horaria máxima da turma, bloquear se sim. 

---
### pagamento
- [x] feito  

pre-update. 
verificar a se o status está sendo atualizado e se a ordem de progresso está sendo respeitada.  

|Status atual|Próximo status permitido|
|---|---|
|`pendente`| `processando`, `vencido`|
|`processando`| `pago`, `pendente`, `vencido`  |
|`pago`| Nenhum|
|`vencido`| `pendente`, `processando`|

**Justificativas:**

- `pendente → processando`: pagamento iniciado.
- `pendente → vencido`: prazo de pagamento expirado.
- `processando → pago`: pagamento confirmado.
- `processando → pendente`: processamento cancelado ou não concluído.
- `processando → vencido`: prazo expirado durante o processamento.
- `vencido → pendente`: pagamento reaberto.
- `vencido → processando`: pagamento iniciado após reabertura.

---
### pagamento
- [x] feito  

pre-update.  
validar data_de_pagamento impedir que a data venha de fora e inserir caso o novo status esteja correto.
inserir `data_de_pagamento` se o novo status for `pago`.  


# procedures 

### alocar aluno
- [ ] feito  

recebe: matricula, cpf, ID da turma  

verifica de o aluno tem o status de pago  
verifica se a turma tem vaga  
e verifica se o aluno esta alocado em outra turma  

---
### registrar_pagamento 
- [ ] feito  

recebe: id da inscrição ou (matrícula + curso), forma de pagamento e data.  
atualiza o status do pagamento para o pago e preenche a data de pagamento.  
dispensa se o aluno já estiver alocado e cria o registro do pagamento.  

---
# views

### atividades da turma 
- [ ] feito  

cada linha contem:  
- descrição, data, carga horaria,  quantidades de alunos presente, quantidades de alunos totais, taxa de presença , media da nota dos alunos presentes. 
---
### alunos prontos para ser alocados
- [ ] feito  

cada linha contem:  
- nome do aluno,  CPF e a matricula, curso inscrito, data de pagamento, o valor da inscrição (ou o total caso seja possível se inscrever em mais) 
mostrar somente alunos que possuem statos de pagamento 'pago' e não estão em uma turma.
---
### pagamentos
- [ ] feito  

cada linha contem:  
vê quais alunos pagaram, quais ainda devem pagar, o curso deles, a data de vencimento e os dias em atraso,

---
### turma vaga
- [ ] feito
  
ID e data de início da turma,   Curso,  Capacidade máxima,  Quantidade de alunos já alocados , Vagas restantes,  
Turno, Carga horária total.  

---
# to-do
- [ ] procedure: criar matricula de aluno  
- [ ] procedure: criar matricula de instrutores
