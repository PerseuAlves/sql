CREATE DATABASE querydinamica01
GO
USE querydinamica01


CREATE TABLE produto(
idProduto INT NOT NULL,
tipo VARCHAR(100),
cor VARCHAR(50)
PRIMARY KEY(idProduto)
)
GO
CREATE TABLE camiseta(
idProduto INT NOT NULL,
tamanho VARCHAR(3)
PRIMARY KEY(idProduto)
FOREIGN KEY (idProduto) REFERENCES produto(idProduto))
GO
CREATE TABLE tenis(
idProduto INT NOT NULL,
tamanho INT
PRIMARY KEY(idProduto)
FOREIGN KEY (idProduto) REFERENCES produto(idProduto))

SELECT * FROM produto
SELECT * FROM tenis
SELECT * FROM camiseta

SELECT p.idProduto, p.cor, p.tipo, t.tamanho
FROM tenis t, produto p
WHERE p.idProduto = t.idProduto

SELECT p.idProduto, p.cor, p.tipo, c.tamanho
FROM camiseta c, produto p
WHERE p.idProduto = c.idProduto

--Query Dinâmica
--Exemplo:
INSERT INTO produto VALUES
(1, 'Bola', 'Azul')

DELETE produto

DECLARE @query VARCHAR(MAX)
SET @query = 'INSERT INTO produto VALUES (1, ''Bola'', ''Azul'')'
PRINT @query
EXEC (@query)

/*Problema: 
Preciso criar uma única SP que me permita inserir 
tênis ou camiseta
*/
CREATE PROCEDURE sp_insereproduto (@id INT, @tipo VARCHAR(100),
	@cor VARCHAR(50), @tamanho VARCHAR(3), 
	@saida VARCHAR(100) OUTPUT)
AS
	DECLARE @tam	INT,
			@tabela	VARCHAR(10),
			@query	VARCHAR(150),
			@erro	VARCHAR(MAX)
	
	SET @tabela = 'tenis'

	BEGIN TRY
		SET @tam = CAST(@tamanho AS INT)
	END TRY
	BEGIN CATCH
		SET @tabela = 'camiseta'
	END CATCH

	SET @query = 'INSERT INTO '+@tabela+' VALUES ('+
		CAST(@id AS VARCHAR(5))+','''+@tamanho+''')'
	PRINT @query

	BEGIN TRY
		INSERT INTO produto VALUES (@id, @tipo, @cor)
		EXEC (@query)
		SET @saida = @tabela+' inserido(a) com sucesso!'
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('ID de produto duplicado', 16, 1)
		END
		ELSE
		BEGIN
			PRINT @erro
			RAISERROR('Erro de processamento', 16, 1)
		END
	END CATCH

DECLARE @out1 VARCHAR(100)
EXEC sp_insereproduto 1001, 'Regata', 'Branca', 'GG', 
	@out1 OUTPUT
PRINT @out1

DECLARE @out2 VARCHAR(100)
EXEC sp_insereproduto 1002, 'Polo', 'Amarela', 'M', 
	@out2 OUTPUT
PRINT @out2

DECLARE @out3 VARCHAR(100)
EXEC sp_insereproduto 10001, 'Chuteira', 'Lilas', '42', 
	@out3 OUTPUT
PRINT @out3
