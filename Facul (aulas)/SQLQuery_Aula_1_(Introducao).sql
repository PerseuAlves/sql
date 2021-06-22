/*
---------------------------------------------------------------------------------------
																AULA: INTRODUÇÃO	  -
---------------------------------------------------------------------------------------
*/

/*
Um campeonato de basquete tem times que são cadastrados por um id único, 
que começa em 4001 e incrementa de 1 em 1, o nome do time que também 
deve ser único e a cidade. Um time tem muitos jogadores, porém 1 jogador 
só pode jogar em 1 time e os jogadores são cadastrados por um código 
único que inicia em 900101, incrementa de 1 em 1, o nome do jogador 
deve ser único também, sexo pode apenas ser M ou F, mas a maioria dos 
jogadores é Homem, altura com 2 casas decimais e a data de nascimento 
(apenas jogadores nascidos até 31/12/1999). 
Jogadores do sexo masculino devem ter, no mínimo 1.70 de altura e do 
sexo feminino, 1.60).
-------------------------------------------------------------------
A seguir se previu a necessidade de cadastro para ginásio, por um id 
numérico e nome char(10). Ainda não estava certo se id seria a chave 
primária, portanto é criada sem. 
Todo ginásio tem um time e todo time tem apenas um ginásio. Essa 
informação foi passada após a criação da tabela, além da confirmação
de id como PK.
O nome do ginásio, deve ser modificado para VARCHAR(50)
Todo ginásio passou a necessitar armazenar uma URL com a foto da 
fachada, chamada URL.
Na sequência se verificou que esse atributo deveria se chamar 
URLFoto.
Posteriormente se verificou que esse atributo se tornou desnecessário e 
deve ser excluido
*/
 
CREATE DATABASE aulaCRUDConstraints
GO
USE aulaCRUDConstraints

/*
CONSTRAINTS - RESTRIÇÕES:

PK - Cria um índice para busca e define unicidade
FK - Cria uma referência entre PK e FK para fazer validações (NÃO importa dados de outra tabela)
IDENTITY(X,Y) - Auto-incremento, inicia em X, Y define o passo 
DEFAULT(X) - Caso a coluna não receba valor, será preenchida com X
UNIQUE - Define unicidade
CHECK - Valida alguma regra, caso falhe, o registro é excluído (Nível de coluna ou nível de tabela)
*/
 
CREATE TABLE times (
id		INT				NOT NULL	IDENTITY(4001,1),
nome	VARCHAR(30)		NOT NULL	UNIQUE,
cidade	VARCHAR(50)		NOT NULL
PRIMARY KEY (id)
)
GO
--UPPER(char): Aumenta a expressão para maiúsculo
--DATE pode ser: YYYY-MM-DD ou YYYY-DD-MM
CREATE TABLE jogador (
codigo		INT				NOT NULL	IDENTITY(900101,1),
nome		VARCHAR(50)		NOT NULL	UNIQUE,
sexo		CHAR(1)			NULL		DEFAULT('M')
										CHECK(UPPER(sexo) = 'M' OR UPPER(sexo) = 'F'),
altura		DECIMAL(7,2)	NOT NULL,
dt_nasc		DATE			NULL		CHECK(dt_nasc <= '1999-12-31'),
timesId		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (timesId) REFERENCES times (id),
CONSTRAINT chk_sx_alt
		CHECK (
			(sexo = 'M' AND altura >= 1.70) OR
			(sexo = 'F' AND altura >= 1.60)
		)
)
 
EXEC sp_help times
EXEC sp_help jogador
 
CREATE TABLE ginasio (
id		INT,
nome	CHAR(10)
)

/*
ALTER TABLE nome_tabela
ADD
ALTER COLUMN
DROP COLUMN
*/

ALTER TABLE ginasio
ADD timesId INT NOT NULL
 
ALTER TABLE ginasio
ADD FOREIGN KEY (timesId) REFERENCES times (id)
 
ALTER TABLE ginasio
ALTER COLUMN id INT NOT NULL
 
ALTER TABLE ginasio
ADD PRIMARY KEY (id)
 
ALTER TABLE ginasio
ALTER COLUMN nome VARCHAR(50) NOT NULL
 
ALTER TABLE ginasio
ADD url VARCHAR(100) NULL

/*
Renomear Tabela ou Coluna (SQL SERVER APENAS)
EXEC sp_rename 'dbo.nome_da_tabela.nome_coluna','novo_nome','column'
EXEC sp_rename 'dbo.nome_da_tabela','novo_nome'
*/
 
EXEC sp_rename 'dbo.ginasio.url','urlFoto','column'
 
ALTER TABLE ginasio
DROP COLUMN urlFoto
 
ALTER TABLE ginasio
ADD CONSTRAINT UQ_NOME_GINASIO UNIQUE (nome)

--LEN(CHAR): retorna qtd de caracteres

ALTER TABLE ginasio
ADD CONSTRAINT CHK_TAM_NOME_GINASIO 
	CHECK (LEN(nome) > 10)
 
EXEC sp_help ginasio
 
/*
DML - Linguagem de Manipulação de Dados
INSERT - Inserir registros na tabela
SELECT - Consulta dados nas tabelas
UPDATE - Modificar dados de um ou mais registros
DELETE - Excluir um ou mais registros
 
Sintaxes: 
INSERT INTO nome_tabela (atr1, atr2, atr3, ..., atrN) VALUES
(d1, d2, d3, ..., dN)
 
Permite null
INSERT INTO nome_tabela (atr1, atr3, ..., atrN) VALUES
(d1, d3, ..., dN)
OU
INSERT INTO nome_tabela (atr1, atr2, atr3, ..., atrN) VALUES
(d1, NULL, d3, ..., dN)
 
Se está na ordem de criação das colunas
INSERT INTO nome_tabela VALUES
(d1, d2, d3, ..., dN)

SELECT * FROM nome_tabela
*/

INSERT INTO times (nome, cidade) VALUES 
('São Roque', 'Thunders')
 
SELECT * FROM times
SELECT * FROM ginasio
SELECT * FROM jogador
 
INSERT INTO times (nome, cidade) VALUES
('Tatuí', 'Hawks'),
('Avaré', 'Panthers'),
('Botucatu', 'Bulls'),
('Santos', 'Bills')
 
INSERT INTO ginasio VALUES
(1, 'Ginásio do Aeroporto', 4002)
 
INSERT INTO ginasio VALUES
(2, 'Ginásio Praiano', 4005)
 
INSERT INTO times (nome, cidade) VALUES 
('Itu', 'Giants')
 
INSERT INTO times (nome, cidade) VALUES 
('Itupeva', 'Biggers')

/*
DELETE nome_tabela
WHERE coluna = valor
*/

DELETE times 
WHERE id = 4001
 
DELETE times
WHERE nome = 'Tatuí'

DELETE times
WHERE id < 4005
 
DELETE times
WHERE cidade = 'Tatuí' OR cidade = 'São Roque' OR nome = 'Bulls'
 
DELETE times
WHERE cidade = 'Santos' AND nome = 'Biggers'
 
DELETE ginasio
DELETE times

--Após deletar a tabela times e a recriar manualmente:

INSERT INTO times (cidade, nome) VALUES 
('São Roque', 'Thunders'),
('Tatuí', 'Hawks'),
('Avaré', 'Panthers'),
('Botucatu', 'Bulls'),
('Santos', 'Bills'),
('Itu', 'Giants'),
('Itupeva', 'Biggers'),
('Franca','Dharma')

/*
DELETE COMPLETO (Todas as linhas, Não funciona caso a tabela tenha FKs)
Reiniciando o IDENTITY:
TRUNCATE TABLE nome_tabela
*/

TRUNCATE TABLE times

/*
Reiniciar a contagem do IDENTITY
DBCC CHECKIDENT ('nome_tabela', RESEED, novo_valor)
*/

DBCC CHECKIDENT ('times', RESEED, 4000)

/*
UPDATE nome_tabela
SET atr1 = novo_valor, atr2 = novo_valor
WHERE coluna = valor
*/
 
--Todos esses resolvem o mesmo problema---------
UPDATE times
SET nome = 'Blackers', cidade = 'Ribeirão Preto'
WHERE id = 4008
-- OU
UPDATE times
SET nome = 'Blackers', cidade = 'Ribeirão Preto'
WHERE nome = 'Dharma'
-- OU 
UPDATE times
SET nome = 'Blackers', cidade = 'Ribeirão Preto'
WHERE nome = 'Dharma' AND cidade = 'Franca'
------------------------------------------------

UPDATE times
SET nome = 'Black Rivers'
WHERE id = 4008

UPDATE times 
SET cidade = 'São Roque'
WHERE id = 4001
 
UPDATE times 
SET cidade = 'Tatuí'
WHERE id = 4002
 
--ERRADO, irá atualizar todas as colunas da tabela
UPDATE times 
SET cidade = ' São Paulo'
--------------------------------------------------

--Usando a segunda tabela (revisão do conteúdo de cima)
 
INSERT INTO jogador (nome, altura, dt_nasc, timesId) VALUES
('Jordan', 1.87, '1963-02-17', 4004)
 
INSERT INTO jogador (nome, altura, dt_nasc, timesId) VALUES
('Bird', 1.75, '1992-06-06', 4001)
 
DELETE jogador
WHERE codigo = 900104
 
DBCC CHECKIDENT ('jogador', RESEED, 900101)
 
UPDATE jogador
SET altura = 1.75
WHERE nome = 'Jordan'
 
UPDATE jogador
SET altura = altura + (0.1 * altura)
WHERE codigo = 900101

/*
A tabela funcionário tem as seguintes restrições:
- PK - id
- id - auto incremento de 1 em 1
- número - deve ser positivo
- cep - deve ter 8 caracteres
- ddd - padrão 11
- telefone - deve ter 8 caracteres
- data_nasc - deve ser anterior a hoje
- salario - deve ser positivo

A tabela projeto tem as seguintes restrições:
- PK - codigo
- codigo - auto incremento partindo de 1001, de 1 em 1
- nome - não pode repetir

A tabela funcproj tem as seguintes restrições:
- PK - id_funcionario, codigo_projeto
- FK - id_funcionario ref. funcionario, PK id
- FK - codigo_projeto ref. projeto, PK codigo
- data_inicio & data_fim - data_fim não pode ser maior que data_inicio
*/

CREATE DATABASE selects
GO
USE selects
GO
 
CREATE TABLE funcionario(
id          INT             NOT NULL	IDENTITY,
nome        VARCHAR(100)    NOT NULL,
sobrenome   VARCHAR(200)    NOT NULL,
logradouro  VARCHAR(200)    NOT NULL,
numero      INT             NOT NULL	CHECK(numero > 0),
bairro      VARCHAR(100)    NULL,
cep         CHAR(8)         NULL		CHECK(LEN(cep) = 8),	
ddd         CHAR(2)         NULL		DEFAULT(11),
telefone    CHAR(8)         NULL		CHECK(LEN(telefone) = 8),
data_nasc   DATETIME        NOT NULL	CHECK(data_nasc < GETDATE()),
salario     DECIMAL(7,2)    NOT NULL	CHECK(salario > 0.00)
PRIMARY KEY(id)
)
GO
CREATE TABLE projeto(
codigo      INT             NOT NULL	IDENTITY(1001,1),
nome        VARCHAR(200)    NOT NULL	UNIQUE,
descricao   VARCHAR(300)    NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE funcproj(
id_funcionario  INT         NOT NULL,
codigo_projeto  INT         NOT NULL,
data_inicio     DATETIME    NOT NULL,
data_fim        DATETIME    NOT NULL
PRIMARY KEY (id_funcionario, codigo_projeto)
FOREIGN KEY (id_funcionario) REFERENCES funcionario (id),
FOREIGN KEY (codigo_projeto) REFERENCES projeto (codigo),
CONSTRAINT chk_dts CHECK(data_fim > data_inicio)
)


INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, telefone, data_nasc, salario) VALUES
('Fulano',	'da Silva',	'R. Voluntários da Patria',	8150,	'Santana',	'05423110',	'76895248',	'1974-05-15',	4350.00),
('Cicrano',	'De Souza',	'R. Anhaia', 353,	'Barra Funda',	'03598770',	'99568741',	'1984-08-25',	1552.00),
('Beltrano',	'Dos Santos',	'R. ABC', 1100,	'Artur Alvim',	'05448000',	'25639854',	'1963-06-02',	2250.00)
INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, ddd, telefone, data_nasc, salario) VALUES
('Tirano',	'De Souza',	'Avenida Águia de Haia', 4430,	'Artur Alvim',	'05448000',	NULL,	NULL,	'1975-10-15',	2804.00)

INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, ddd, telefone, data_nasc, salario) VALUES
('Beltrano',	'Dos Santos',	'R. ABC', 1100,	'Artur Alvim',	'05448000',	'11',	'25639854',	'2015-06-02',	2250.00)

INSERT INTO projeto VALUES
('Implantação de Sistemas','Colocar o sistema no ar'),
('Modificação do módulo de cadastro','Modificar CRUD'),
('Teste de Sistema de Cadastro',NULL)

INSERT INTO funcproj VALUES
(1, 1001, '2015-04-18', '2015-04-30'),
(3, 1001, '2015-04-18', '2015-04-30'),
(1, 1002, '2015-05-06', '2015-05-10'),
(2, 1002, '2015-05-06', '2015-05-10'),
(3, 1003, '2015-05-11', '2015-05-13')

--Invertida
INSERT INTO funcproj VALUES
(3, 1003, '2015-05-13', '2015-05-11')

SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj

--Funções Importantes
SELECT 'Boa tarde', 'Turma'
SELECT GETDATE()
	--Alias em colunas (AS)
SELECT GETDATE() AS hoje
	--CONVERSÕES DE TIPO (CAST, CONVERT)
SELECT 12 AS doze
SELECT 'A12' AS adoze
SELECT CAST(12 AS CHAR(2)) AS doze_char
SELECT CAST(12.53 AS VARCHAR(5)) AS doze_quebrado_varchar
SELECT CAST(12.53 AS INT) AS doze_quebrado_int
SELECT CAST('A12' AS INT) AS adoze_int
SELECT CAST('12' AS INT) AS doze_char_int

SELECT CONVERT(CHAR(2), 12) AS doze_char_convert
SELECT CONVERT(VARCHAR(5), 12.53) AS doze_quebrado_varchar_convert
SELECT CONVERT(INT, 12.53) AS doze_quebrado_varchar
SELECT CONVERT(INT, 'A12') AS adoze_int_convert
SELECT CONVERT(INT, '12') AS doze_char_int_convert

--103 convert date(datetime) -> char(dd/mm/yyyy) - BR
SELECT CONVERT(CHAR(10), GETDATE(), 103) AS dia_hoje
--108 convert datetime ->char (HH:mm)
SELECT CONVERT(CHAR(5), GETDATE(), 108) AS hora_agora

SELECT CONVERT(CHAR(12), GETDATE(), 107) AS dia_hoje


--Select Simples funcionario (Sem ddd, telefone)
SELECT id, nome, sobrenome, logradouro, numero, bairro,
		cep, data_nasc, salario 
FROM funcionario

SELECT id, nome, sobrenome, logradouro, numero, bairro,
		cep, data_nasc AS nascimento, salario 
FROM funcionario

EXEC sp_help funcionario

--Select Simples funcionario(s) Fulano
SELECT id, nome, sobrenome, logradouro, numero, bairro,
		cep, data_nasc AS nascimento, salario 
FROM funcionario
WHERE nome = 'Fulano'

--Select Simples funcionario(s) Beltrano
SELECT id, nome, sobrenome, logradouro, numero, bairro,
		cep, data_nasc AS nascimento, salario 
FROM funcionario
WHERE nome = 'Beltrano'


--Select Simples funcionario(s) Fulano Silva
SELECT id, nome, sobrenome, logradouro, numero, bairro,
		cep, data_nasc AS nascimento, salario 
FROM funcionario
WHERE nome = 'Fulano' AND sobrenome LIKE '%Silva%'

--LIKE (como, tipo) %
--Select Simples funcionario(s) Beltrano Santos Nascido nos anos 60
SELECT id, nome, sobrenome, logradouro, numero, bairro,
		cep, data_nasc AS nascimento, salario 
FROM funcionario
WHERE nome = 'Beltrano' 
	AND sobrenome LIKE '%Santos%'
	AND data_nasc < '1970-01-01'
	

--Id e Nome Concatenado de quem não tem telefone
--nome_completo
SELECT id, nome + ' ' + sobrenome AS nome_completo
FROM funcionario
WHERE telefone IS NULL

--NULL não usa = 
-- IS NULL ou IS NOT NULL

SELECT id, nome, sobrenome, nome + ' ' + sobrenome AS nome_completo, telefone
FROM funcionario


--Nome Concatenado e telefone (sem ddd) de quem tem telefone
SELECT id, nome + ' ' + sobrenome AS nome_completo, telefone
FROM funcionario
WHERE telefone IS NOT NULL
--ORDER BY nome ASC, sobrenome ASC, data_nasc DESC
ORDER BY nome, sobrenome, data_nasc DESC

--ORDER BY atr1, atr2
--ASC - CRESCENTE -- DEFAULT
--DESC - DECRESCENTE

SELECT id, nome + ' ' + sobrenome AS nome_completo, telefone
FROM funcionario
WHERE telefone IS NOT NULL
--ORDER BY nome ASC, sobrenome ASC, data_nasc DESC
ORDER BY nome_completo

--Nome Concatenado e telefone (sem ddd) de quem tem telefone em ordem alfabética

--Nome completo, Endereco completo (Rua, nº e CEP), ddd e telefone, ordem alfabética crescente
SELECT id, 
		nome + ' ' + sobrenome AS nome_completo,
		logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + cep AS endereco_completo,
		ddd, 
		telefone
FROM funcionario
ORDER BY nome_completo ASC

--Nome completo, Endereco completo (Rua, nº e CEP), data_nasc (BR), ordem alfabética decrescente
SELECT id, 
		nome + ' ' + sobrenome AS nome_completo,
		logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + cep AS endereco_completo,
		CONVERT(CHAR(10), data_nasc, 103) AS nascimento
FROM funcionario
ORDER BY nome_completo DESC

--Datas distintas (BR) de inicio de trabalhos
SELECT DISTINCT CONVERT(CHAR(10), data_inicio, 103) AS data_inicio
FROM funcproj

--Consultar dados distintos de Beltrano
SELECT DISTINCT nome, sobrenome, logradouro, numero, bairro,
		cep, salario 
FROM funcionario
WHERE nome = 'Beltrano' 
	AND sobrenome LIKE '%Santos%'


--DISTINCT remove as linhas duplicadas (linha inteiras iguais)

--nome_completo e 15% de aumento para Cicrano
SELECT id, nome + ' ' + sobrenome AS [nome completo], 
	salario, 
	CAST(salario + (salario * 0.15) AS DECIMAL(7,2)) AS aumento
FROM funcionario
WHERE nome = 'Cicrano'

SELECT id, nome + ' ' + sobrenome AS [nome completo], 
	salario, 
	CAST(salario * 1.15 AS DECIMAL(7,2)) AS aumento
FROM funcionario
WHERE nome = 'Cicrano'

--Nome completo e salario de quem ganha mais que 3000
SELECT id, nome + ' ' + sobrenome AS [nome completo], 
		salario
FROM funcionario
WHERE salario > 3000.00


--Nome completo e salario de quem ganha menos que 2000
SELECT id, nome + ' ' + sobrenome AS [nome completo], 
		salario
FROM funcionario
WHERE salario < 2000.00

--Nome completo e salario de quem ganha entre 2000 e 3000
SELECT id, nome + ' ' + sobrenome AS [nome completo], 
		salario
FROM funcionario
WHERE salario >= 2000.00 AND salario <= 3000.00

SELECT id, nome + ' ' + sobrenome AS [nome completo], 
		salario
FROM funcionario
WHERE salario BETWEEN 2000.00 AND 3000.00


--Nome completo e salario de quem ganha menos que 2000 e mais que 3000
SELECT id, nome + ' ' + sobrenome AS [nome completo], 
		salario
FROM funcionario
WHERE salario <= 2000.00 OR salario >= 3000.00

SELECT id, nome + ' ' + sobrenome AS [nome completo], 
		salario
FROM funcionario
WHERE salario NOT BETWEEN 2000.00 AND 3000.00

USE selects

EXEC sp_help funcionario

DBCC CHECKIDENT ('funcionario', RESEED, 5)

DELETE funcionario WHERE id > 5

INSERT INTO funcionario VALUES 
('Fulano','da Silva Jr.','R. Voluntários da Patria',8150,NULL,'05423110','11','32549874','1990-09-09',1235.00),
('João','dos Santos','R. Anhaia',150,NULL,'03425000','11','45879852','1973-08-19',2352.00),
('Maria','dos Santos','R. Pedro de Toledo',18,NULL,'04426000','11','32568974','1982-05-03',4550.00)

SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj

--SUBSTRING(char, posição inicial, qtd de caracteres) - retorna char
SELECT SUBSTRING('Banco de Dados', 1, 5) AS sub
SELECT SUBSTRING('Banco de Dados', 7, 2) AS sub
SELECT SUBSTRING('Banco de Dados', 10, 5) AS sub

SELECT SUBSTRING('Banco de Dados', 1, 5) AS sub
SELECT SUBSTRING('Banco de Dados', 1, 6) AS sub

SELECT SUBSTRING('Banco de Dados', 10, 5) AS sub
SELECT SUBSTRING('Banco de Dados', 9, 6) AS sub

SELECT SUBSTRING('Banco de Dados', 7, 2) AS sub
SELECT SUBSTRING('Banco de Dados', 6, 4) AS sub

--TRIM
--LTRIM(char) - retorna char sem espaços à esquerda
--RTRIM(char) - retorna char sem espaços à direta
SELECT LTRIM('   Boa tarde') AS boa_tarde
SELECT '   Boa tarde' AS boa_tarde

SELECT SUBSTRING('Banco de Dados', 1, 5) AS sub
SELECT RTRIM(SUBSTRING('Banco de Dados', 1, 6)) AS sub

SELECT SUBSTRING('Banco de Dados', 10, 5) AS sub
SELECT LTRIM(SUBSTRING('Banco de Dados', 9, 6)) AS sub

SELECT LTRIM(RTRIM(' oi ')) AS oi
SELECT SUBSTRING('Banco de Dados', 7, 2) AS sub
SELECT LTRIM(RTRIM(SUBSTRING('Banco de Dados', 6, 4))) AS sub

--Funções para operações com datas
SELECT GETDATE() AS hoje
/* ISSO NÃO SE FAZ !!!!!!!!!!!
SELECT CAST(SUBSTRING(CONVERT(CHAR(10), GETDATE(), 103), 1, 2) AS INT) AS dia
*/
SELECT DAY(GETDATE()) AS dia
SELECT MONTH(GETDATE()) AS mes
SELECT YEAR(GETDATE()) AS ano
SELECT DAY(GETDATE()) AS dia, MONTH(GETDATE()) AS mes, YEAR(GETDATE()) AS ano
--DATEPART(INTERVALO, date) - retorna int
SELECT DATEPART(DAY, GETDATE()) AS dia
SELECT DATEPART(MONTH, GETDATE()) AS mes
SELECT DATEPART(YEAR, GETDATE()) AS ano
SELECT DATEPART(WEEKDAY, GETDATE()) AS dia_semana_hoje
SELECT DATEPART(WEEKDAY, '2021-04-13') AS dia_semana_aniv_Denis
SELECT DATEPART(WEEKDAY, '2021-01-20') AS dia_semana_aniv_Diogo
SELECT DATEPART(WEEK, GETDATE()) AS semana_ano_hoje
SELECT DATEPART(DAYOFYEAR, GETDATE()) AS dia_ano_hoje
SELECT 365 - DATEPART(DAYOFYEAR, GETDATE()) AS faltam_dias_ano

--DATEDIFF & DATEADD
--DATEDIFF(Intervalo, Date, Date) - retorna int
SELECT DATEDIFF(DAY, '1982-09-22', '2000-01-20') AS Ex_30
SELECT DATEDIFF(DAY, '1982-09-22', '1987-03-25') AS Ex_30

SELECT DATEDIFF(DAY, '1987-03-25', '1982-09-22') AS Ex_30 --Negativo

SELECT DATEDIFF(MONTH, '1982-09-22', '2000-01-20') AS Ex_30
SELECT DATEDIFF(YEAR, '1982-09-22', '1987-03-25') AS Ex_30

--DATEADD(Intervalo, int, date) - retorna date
SELECT DATEADD(DAY, 7, GETDATE()) AS daqui_7_dias
SELECT DATEADD(DAY, -7, GETDATE()) AS sete_dias_atras

SELECT CONVERT(CHAR(10), DATEADD(MONTH, 3, GETDATE()), 103) AS daqui_3_meses

SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj

/*
CASE:

Semelhante ao Switch..Case:
alias_coluna = CASE(valor)
	WHEN res THEN saida
	WHEN res2 THEN saida2
	...
	ELSE saida_else
	END

Semelhante ao if..else
	CASE 
		WHEN teste_logico THEN
			saida
		ELSE
			saida
	END AS alias

	CASE 
		WHEN teste_logico THEN
			saida
		ELSE
			CASE
				WHEN outro_teste THEN
					outra_saida
				ELSE
					outra_saida
			END
	END AS alias
*/
/*SUBCONSULTA (SUBQUERY ou SUBSELECT)
SELECT atributos
FROM tabela
WHERE atributo IN   **NOT IN
(
	SELECT atributo
	FROM tabela2
	WHERE condicoes
)
*/

--Exemplos:
--Consultar nome completo e telefone mascarado, com ddd
--(XX)XXXX-XXXX
SELECT nome+' '+sobrenome AS nome_completo,
		'('+ddd+')'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4) AS tel
FROM funcionario

--Caso seja celular ?
SELECT nome+' '+sobrenome AS nome_completo,
		tel = CASE (CAST(SUBSTRING(telefone,1,1) AS INT))
		WHEN 6 THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		WHEN 7 THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		WHEN 8 THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		WHEN 9 THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		ELSE
			'('+ddd+')'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		END
FROM funcionario

--De outro jeito
SELECT nome+' '+sobrenome AS nome_completo,
		CASE
			WHEN CAST(SUBSTRING(telefone,1,1) AS INT) >= 6 THEN
				'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
			ELSE
				'('+ddd+')'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		END AS tel
FROM funcionario


--Consultar nome completo, com endereço completo 
SELECT nome+' '+sobrenome AS nome_completo,
	CASE 
		WHEN bairro IS NULL THEN
			logradouro+','+CAST(numero AS VARCHAR(5))
		ELSE
			logradouro+','+CAST(numero AS VARCHAR(5))+' - '+bairro 
	END AS endereco_completo
FROM funcionario


--Corrigir com CASE

--Consultar nome completo, endereço completo, cep mascarado, 
--telefone com ddd mascarado e validação de celular
SELECT id,
	nome+' '+sobrenome AS nome_completo,
	CASE 
		WHEN bairro IS NULL THEN
			logradouro+','+CAST(numero AS VARCHAR(5))
		ELSE
			logradouro+','+CAST(numero AS VARCHAR(5))+' - '+bairro 
	END AS endereco_completo,
	SUBSTRING(cep, 1, 5)+'-'+SUBSTRING(cep, 6, 3) AS CEP,
	CASE
		WHEN CAST(SUBSTRING(telefone,1,1) AS INT) >= 6 THEN
			'('+ddd+')9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		ELSE
			'('+ddd+')'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
	END AS tel
FROM funcionario

--Quantos dias trabalhados, por funcionário em cada projeto
SELECT id_funcionario, codigo_projeto,
	DATEDIFF(DAY, data_inicio, data_fim) AS duracao
FROM funcproj

--Funcionario 3 do projeto 1003 pediu mais 3 dias para finalizar o projeto, 
--qual será sua nova data final, convertida (BR) ?
SELECT id_funcionario, codigo_projeto, 
	CONVERT(CHAR(10), data_fim, 103) AS data_fim,
	CONVERT(CHAR(10), DATEADD(DAY, 3, data_fim), 103) AS nova_data_fim
FROM funcproj
WHERE id_funcionario = 3 AND codigo_projeto = 1003

--Quantos codigos de projetos distintos tem menos de 10 dias trabalhados
SELECT DISTINCT codigo_projeto
FROM funcproj
WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10

--Nomes e descrições de projetos distintos tem menos de 10 dias trabalhados
SELECT nome, descricao
FROM projeto 
WHERE codigo IN 
(
SELECT DISTINCT codigo_projeto
FROM funcproj
WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10
)

--Nomes completos dos Funcionários que estão no
--projeto Modificação do Módulo de Cadastro
SELECT nome + ' ' + sobrenome AS nome_completo
FROM funcionario
WHERE id IN
(
	SELECT id_funcionario
	FROM funcproj
	WHERE codigo_projeto IN
	(
		SELECT codigo
		FROM projeto
		WHERE nome LIKE 'Modifi%'
	)
)

--Nomes completos dos Funcionários que NÃO estão no
--projeto Modificação do Módulo de Cadastro
SELECT nome + ' ' + sobrenome AS nome_completo
FROM funcionario
WHERE id NOT IN
(
	SELECT id_funcionario
	FROM funcproj
	WHERE codigo_projeto IN
	(
		SELECT codigo
		FROM projeto
		WHERE nome LIKE 'Modifi%'
	)
)

--Mostrar nome_completo e os nomes dos dias da semana (Pt-BR) da 
--data de nascimento dos funcionarios
SELECT nome + ' ' + sobrenome AS nome_completo,
	dia_semana = CASE (DATEPART(WEEKDAY, data_nasc))
		WHEN 1 THEN 'Domingo'
		WHEN 2 THEN 'Segunda-feira'
		WHEN 3 THEN 'Terça-feira'
		WHEN 4 THEN 'Quarta-feira'
		WHEN 5 THEN 'Quinta-feira'
		WHEN 6 THEN 'Sexta-feira'
		ELSE 'Sábado'
	END
FROM funcionario

--Nomes completos e Idade, em anos (considere se fez ou ainda fará
--aniversário esse ano), dos funcionários
SELECT nome + ' ' + sobrenome AS nome_completo,
	DATEDIFF(DAY, data_nasc, GETDATE()) / 365 as idade
FROM funcionario
