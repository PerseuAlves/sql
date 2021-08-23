/*
Exercício:

Considere a tabela Produto com os seguintes atributos:
Produto (Codigo | Nome | Valor)
Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
(Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)
Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a empresa vende, entra na tabela SAIDA.
Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA), criar uma exceção de erro para código inválido, receba o codigo_transacao, codigo_produto e a quantidade e preencha a tabela correta,
com o valor_total de cada transação de cada produto.

*/

USE master
GO
DROP DATABASE loja
GO
CREATE DATABASE loja
GO
USE loja
GO

CREATE TABLE Produto
(
    codigo                      INT,
    nome                        VARCHAR(100),
    valor                       DECIMAL(5,2)
    PRIMARY KEY(codigo)
)
GO

CREATE TABLE ENTRADA
(
    Codigo_Transacao            INT,
    Codigo_Produto              INT,
    Quantidade                  INT,
    Valor_Total                 INT
    PRIMARY KEY(Codigo_Transacao)
    FOREIGN key(Codigo_Produto) REFERENCES Produto(codigo)
)
GO

CREATE TABLE SAIDA
(
    Codigo_Transacao            INT,
    Codigo_Produto              INT,
    Quantidade                  INT,
    Valor_Total                 INT
    PRIMARY KEY(Codigo_Transacao)
    FOREIGN key(Codigo_Produto) REFERENCES Produto(codigo)
)
GO

CREATE PROCEDURE sp_Loja(@codigo CHAR(1), @codigo_Produto INT, @codigo_transacao INT, @nome VARCHAR(100), @valor DECIMAL(5,2), @quantidade INT, @saida VARCHAR(MAX) OUTPUT)
AS
    DECLARE @contador   INT,
            @tabela	    VARCHAR(20),
			@query	    VARCHAR(150),
			@erro	    VARCHAR(MAX),
            @valorT      DECIMAL(5,2)

    SET @valorT = @quantidade * @valor

    IF(@codigo = 'e')
    BEGIN
        SET @tabela = 'ENTRADA'

        SET @query = 'INSERT INTO ' + @tabela + ' VALUES ' +
        '(' + CAST(@codigo_transacao AS VARCHAR(2)) + ', ' + CAST(@codigo_Produto AS VARCHAR(2)) + ', ' + CAST(@quantidade AS VARCHAR(3)) + ', ' + CAST(@valorT AS VARCHAR(6)) + ')'

        PRINT @query

        BEGIN TRY
            INSERT INTO Produto VALUES (@codigo_Produto, @nome, @valor)
            EXEC (@query)
            SET @saida = 'Operação na tabela ' + @tabela+' realizada com sucesso.'
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
    END
    ELSE
    IF(@codigo = 's')
    BEGIN
        SET @tabela = 'SAIDA'

        SET @query = 'INSERT INTO ' + @tabela + ' VALUES ' +
        '(' + CAST(@codigo_transacao AS VARCHAR(2)) + ', ' + CAST(@codigo_Produto AS VARCHAR(2)) + ', ' + CAST(@quantidade AS VARCHAR(3)) + ', ' + CAST(@valorT AS VARCHAR(6)) + ')'

        PRINT @query

        BEGIN TRY
            INSERT INTO Produto VALUES (@codigo_Produto, @nome, @valor)
            EXEC (@query)
            SET @saida = 'Operação na tabela ' + @tabela+' realizada com sucesso.'
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
    END
    ELSE
    BEGIN
        RAISERROR('Erro, tabela inválida', 16, 1)
    END


DECLARE @out1 VARCHAR(MAX)
EXEC sp_Loja 'e', 1, 1, 'Bola', 3.45, 5, 
	@out1 OUTPUT
PRINT @out1