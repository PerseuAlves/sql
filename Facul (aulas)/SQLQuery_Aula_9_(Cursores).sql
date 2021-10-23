/*CURSORES

Sintaxe:
	DECLARE @var1	TIPO,	
			@var2	TIPO
	DECLARE cur CURSOR FOR --Inicializa o cursor pra uma consulta
		SELECT ...

	OPEN cur	-- Posiciona o cursor para começar
	FETCH NEXT FROM cur INTO variaveis --Busca a 1a linha e, se houver, colocar cada dado de cada coluna da linha em uma variável
	WHILE @@FETCH_STATUS = 0 --Enquanto a busca retornar uma linha válida
	BEGIN
		Programação

		FETCH NEXT FROM cur INT variaveis --Busca a próxima linha
	END
	CLOSE cur		--Finaliza o cursor
	DEALLOCATE cur	--Tira o cursor da memória
*/
CREATE DATABASE aulacursor
GO
USE aulacursor

CREATE TABLE cliente (
id			INT				NOT NULL,
nome		VARCHAR(50)		NOT NULL,
vl_entrada	DECIMAL(7,2)	NOT NULL,
vl_saida	DECIMAL(7,2)	NOT NULL
PRIMARY KEY(id)
)

INSERT INTO cliente VALUES(1,'Cli1',11238,10362)
INSERT INTO cliente VALUES(2,'Cli2',17159,14018)
INSERT INTO cliente VALUES(3,'Cli3',13106,14332)
INSERT INTO cliente VALUES(4,'Cli4',10805,18889)
INSERT INTO cliente VALUES(5,'Cli5',13625,12191)
INSERT INTO cliente VALUES(6,'Cli6',17256,13584)
INSERT INTO cliente VALUES(7,'Cli7',14930,18788)
INSERT INTO cliente VALUES(8,'Cli8',19144,11118)
INSERT INTO cliente VALUES(9,'Cli9',11811,15345)
INSERT INTO cliente VALUES(10,'Cli10',10491,18687)
INSERT INTO cliente VALUES(11,'Cli11',14390,18509)
INSERT INTO cliente VALUES(12,'Cli12',11289,13348)
INSERT INTO cliente VALUES(13,'Cli13',11889,10618)
INSERT INTO cliente VALUES(14,'Cli14',10023,17999)
INSERT INTO cliente VALUES(15,'Cli15',10957,14682)
INSERT INTO cliente VALUES(16,'Cli16',12156,15338)
INSERT INTO cliente VALUES(17,'Cli17',17535,13595)
INSERT INTO cliente VALUES(18,'Cli18',14354,18652)
INSERT INTO cliente VALUES(19,'Cli19',18574,19906)
INSERT INTO cliente VALUES(20,'Cli20',15299,14058)

SELECT * FROM cliente

GO

--Criar uma UDF que retorne os clientes com saldo negativo
--ID, nome, saldo
--saldo = vl_entrada - vl_saida

CREATE FUNCTION fn_cli_saldo_negativo()
RETURNS @tabela TABLE(
id		INT,
nome	VARCHAR(50),
saldo	DECIMAL(7,2)
)
AS
BEGIN
	DECLARE @id			INT,
			@nome		VARCHAR(50),
			@vl_entrada	DECIMAL(7,2),
			@vl_saida	DECIMAL(7,2),
			@saldo		DECIMAL(7,2)
	DECLARE cur CURSOR FOR
		SELECT id, nome, vl_entrada, vl_saida FROM cliente

	OPEN cur
	FETCH NEXT FROM cur INTO @id, @nome, @vl_entrada, @vl_saida
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @saldo = @vl_entrada - @vl_saida
		IF (@saldo < 0)
		BEGIN
			INSERT INTO @tabela VALUES
			(@id, @nome, @saldo)
		END

		FETCH NEXT FROM cur INTO @id, @nome, @vl_entrada, @vl_saida
	END

	CLOSE cur
	DEALLOCATE cur

	RETURN
END

GO

SELECT * FROM fn_cli_saldo_negativo()