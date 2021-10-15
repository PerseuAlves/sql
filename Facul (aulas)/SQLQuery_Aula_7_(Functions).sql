CREATE DATABASE functions
GO

USE functions
GO

CREATE TABLE aluno (
    cod 	int 			NOT NULL,
    nome 	varchar(100) 	NULL,
    altura 	decimal(7, 2) 	NULL,
    peso 	decimal(7, 2) 	NULL
    PRIMARY KEY (cod)
)
GO

INSERT INTO aluno VALUES
(1, 'Fulano', 1.82, 130),
(2, 'Cicrano', 1.95, 89),
(3, 'Beltrano', 1.70, 76)
GO

/*
Funções definidas pelo usuário
USER DEFINED FUNCTIONS (UDF)

- Não aceitam DDL (Não pode chamar procedure)
- Não aceitam RAISE ERROR
- Retornam ResultSet (Acessado por SELECT)
- Permitem fazer JOINS com SELECTS de VIEWS e TABELAS
- É necessário declarar seu tipo de retorno
- Podem ser:
	-Scalar Function (Retorna um valor escalar)
	-In-line Table Functions* (Retorna uma tabela a partir de um select)
	-Multi Statement Table Function* (Retorna uma tabela processada)

SINTAXE:
CREATE FUNCTION fn_nome(param. entrada)
RETURNS tipo
AS
BEGIN
	programação
	RETURN variável**
END

Funções Multi Statement Table não se coloca a variável 
de retorno, ficando apenas RETURN

SELECT Scalar Function
SELECT dbo.fn_nome(params)
*/
--Exemplo 1: UDF Scalar que retorna o IMC do aluno
--IMC = Peso / altura²

CREATE FUNCTION fn_calcimc(@cod INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @alt	DECIMAL(7,2),
			@peso	DECIMAL(7,2),
			@imc	DECIMAL(7,2)
	IF (@cod > 0)
	BEGIN
--		SET @alt = (SELECT altura FROM aluno WHERE cod = @cod)
--		SET @peso = (SELECT peso FROM aluno WHERE cod = @cod)
		SELECT @alt = altura, @peso = peso
			FROM aluno
			WHERE cod = @cod
		SET @imc = @peso / POWER(@alt, 2)
	END
	RETURN @imc
END
GO

SELECT dbo.fn_calcimc(3) AS IMC
GO

--Exemplo 2: UDF MST que retorna
--(cod | nome | altura | peso | imc | situacao)
CREATE FUNCTION fn_alunoimc()
RETURNS @table TABLE (
cod			INT,
nome		VARCHAR(100),
altura		DECIMAL(7,2),
peso		DECIMAL(7,2),
imc			DECIMAL(7,2),
situacao	VARCHAR(100)
)
AS
BEGIN
	INSERT INTO @table (cod, nome, altura, peso)
		SELECT cod, nome, altura, peso FROM aluno

	UPDATE @table
		SET imc = (SELECT dbo.fn_calcimc(cod))

	UPDATE @table
		SET situacao = 'Muito abaixo do peso'
		WHERE imc < 17
	UPDATE @table
		SET situacao = 'Abaixo do peso'
		WHERE imc >= 17 AND imc < 18.5
	UPDATE @table
		SET situacao = 'Peso Normal'
		WHERE imc >= 18.5 AND imc < 25
	UPDATE @table
		SET situacao = 'Acima do Peso'
		WHERE imc >= 25 AND imc < 30
	UPDATE @table
		SET situacao = 'Obesidade Grau I'
		WHERE imc >= 30 AND imc < 35
	UPDATE @table
		SET situacao = 'Obesidade Grau II'
		WHERE imc >= 35 AND imc < 40
	UPDATE @table
		SET situacao = 'Obesidade Grau III'
		WHERE imc >= 40

	RETURN
END
GO

CREATE FUNCTION fn_situacaoimc(@imc DECIMAL(7,2))
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @situacao VARCHAR(100)
	IF (@imc < 17)
	BEGIN
		SET @situacao = 'Muito abaixo do peso'
	END
	IF (@imc >= 17 AND @imc < 18.5)
	BEGIN
		SET @situacao = 'Abaixo do peso'
	END
	IF (@imc >= 18.5 AND @imc < 25)
	BEGIN
		SET @situacao = 'Peso Normal'
	END
	IF (@imc >= 25 AND @imc < 30)
	BEGIN
		SET @situacao = 'Acima do Peso'
	END
	IF (@imc >= 30 AND @imc < 35)
	BEGIN
		SET @situacao = 'Obesidade Grau I'
	END
	IF (@imc >= 35 AND @imc < 40)
	BEGIN
		SET @situacao = 'Obesidade Grau II'
	END
	IF (@imc >= 40)
	BEGIN
		SET @situacao = 'Obesidade Grau III'
	END

	RETURN @situacao
END
GO

SELECT dbo.fn_situacaoimc(39.2) AS situacao
GO

SELECT dbo.fn_situacaoimc(16.5) AS situacao
GO

CREATE FUNCTION fn_alunoimc()
RETURNS @table TABLE (
cod			INT,
nome		VARCHAR(100),
altura		DECIMAL(7,2),
peso		DECIMAL(7,2),
imc			DECIMAL(7,2),
situacao	VARCHAR(100)
)
AS
BEGIN
	INSERT INTO @table (cod, nome, altura, peso)
		SELECT cod, nome, altura, peso FROM aluno

	UPDATE @table
		SET imc = (SELECT dbo.fn_calcimc(cod))

	UPDATE @table
		SET situacao = (SELECT dbo.fn_situacaoimc(imc))

	RETURN
END
GO

SELECT * FROM fn_alunoimc()