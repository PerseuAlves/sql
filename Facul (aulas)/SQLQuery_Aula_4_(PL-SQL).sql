--Linguagem de Programação em SQL (PL-SQL)

--Declaração de variável
--DECLARE @var AS Tipo
--Ex.: DECLARE @contador AS INT
--Ex.: DECLARE @contador INT

--Atribuição de valor
--SET @var = valor
--Ex.: SET @contador = 0
--Ex.: SET @titulo = 'Novo Livro'

--Ex.1:
DECLARE @valor INT
DECLARE @nome VARCHAR(50)
SET @nome = 'Fulano'
SET @valor = 3000
PRINT(@nome+' andou '+CAST(@valor AS VARCHAR(4))+' m.')

--Ex.2:
DECLARE @vlr1	INT,
		@vlr2	INT,
		@res	INT
SET @vlr1 = 10
SET @vlr2 = 20
SET @res = @vlr1 + @vlr2
PRINT(@res)

--Estrutura condicional
/*
IF (teste_lógico)
BEGIN
	Programação
END
ELSE
BEGIN
	Programação
END
*/
--Ex.:Media = (P1 * 0,3) + (P2 * 0,5) + (T * 0,2)
DECLARE @p1		DECIMAL(7,2),
		@p2		DECIMAL(7,2),
		@t		DECIMAL(7,2),
		@media	DECIMAL(7,2)
SET @p1 = 7.0
SET @p2 = 9.5
SET @t = 5.0
SET @media = (@p1 * 0.3) + (@p2 * 0.5) + (@t * 0.2)
PRINT ('Média = '+CAST(@media AS VARCHAR(6)))
IF (@media < 6.0)
BEGIN
	PRINT ('Reprovado')
END
ELSE
BEGIN
	PRINT ('Aprovado')
END

--Estrutura de repetição
/*
WHILE (teste_lógico)
BEGIN
	Programação
	Incremento
END
*/
--Ex.:
DECLARE @entrada	INT,
		@vlr		INT,
		@rsltd		INT
SET @entrada = 100
SET @vlr = 0
IF (@entrada > 0 AND @entrada <= 10)
BEGIN
	WHILE (@vlr < = 10)
	BEGIN
		SET @rsltd = @entrada * @vlr
		SET @vlr = @vlr + 1
		PRINT (@rsltd)
	END
END
ELSE
BEGIN
	--RAISE ERROR
	 RAISERROR('Valor de entrada inválido !', 16, 1)
END

--Exemplos com tabelas:
CREATE DATABASE progsql
GO
USE progsql

CREATE TABLE produto (
id				INT				NOT NULL,
nome			VARCHAR(50)		NOT NULL,
vlr_unitario	DECIMAL(7,2)	NOT NULL
PRIMARY KEY (id)
)

DECLARE @id		INT,
		@nome	VARCHAR(50),
		@vlr_un	DECIMAL(7,2)
SET @id = 1
WHILE (@id <= 1000)
BEGIN
	SET @nome = 'Produto '+CAST(@id AS VARCHAR(4))
	IF (@id % 2 = 0)
	BEGIN
		SET @vlr_un = @id * 3.5
	END
	ELSE 
	BEGIN
		SET @vlr_un = @id * 1.25
	END

	INSERT INTO produto VALUES
	(@id, @nome, @vlr_un)

	SET @id = @id + 1
END

SELECT COUNT(id) FROM produto
SELECT * FROM produto

DECLARE @id_produto1		INT,
		@nome_produto1		VARCHAR(50),
		@vlr_un_produto1	DECIMAL(7,2),
		@id_produto2		INT,
		@nome_produto2		VARCHAR(50),
		@vlr_un_produto2	DECIMAL(7,2)

--Forma 1:
SET @id_produto1 = (SELECT id FROM produto WHERE id = 974)
SET @nome_produto1 = (SELECT nome FROM produto WHERE id = 974)
SET @vlr_un_produto1 = (SELECT vlr_unitario FROM produto WHERE id = 974)
--Forma 2:
SELECT @id_produto2 = id, @nome_produto2 = nome, 
		@vlr_un_produto2 = vlr_unitario
FROM produto
WHERE id = 1000
IF (@vlr_un_produto2 > @vlr_un_produto1)
BEGIN
	PRINT (@nome_produto2)
END
ELSE
BEGIN
	PRINT (@id_produto1)
	PRINT (@nome_produto1)
END


DECLARE @vlr_un_prod		DECIMAL(7,2),
		@vlr_un_prod_desc	DECIMAL(7,2)
--Forma 1:
SET @vlr_un_prod = (SELECT vlr_unitario FROM produto WHERE id = 237)
SET @vlr_un_prod_desc = (SELECT vlr_unitario * 0.9 FROM produto WHERE id = 237)
--Forma 2:
SELECT @vlr_un_prod = vlr_unitario,
		@vlr_un_prod_desc = vlr_unitario * 0.9
FROM produto 
WHERE id = 237
SELECT @vlr_un_prod AS Valor_un, @vlr_un_prod_desc AS Valor_un_desconto 