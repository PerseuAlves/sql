DROP PROCEDURE sp_operacoes
GO

USE master
GO

DROP DATABASE exer_loja
GO

CREATE DATABASE exer_loja
GO

USE exer_loja
GO

CREATE TABLE produtos
(
    codigo              INT             NOT NULL,
    nome                VARCHAR(30),
    valor_unitario      DECIMAL(7,2),
    qtd_estoque         INT

    PRIMARY KEY(codigo)
)
GO

CREATE TABLE venda
(
    codigo_venda        INT     NOT NULL,
    data_compra         DATE    NOT NULL,
    codigo_produto      INT     NOT NULL,
    quantidade          INT     NOT NULL

    FOREIGN KEY(codigo_produto) REFERENCES produtos(codigo)
    PRIMARY KEY(codigo_venda, data_compra, codigo_produto)
)
GO

CREATE FUNCTION fn_estoque(@margem INT)
RETURNS INT
AS
BEGIN
    DECLARE @quantidade INT,
            @contador   INT,
            @totalProd  INT

    SET @quantidade = 0
    SET @contador   = 0

    SET @totalProd = (SELECT COUNT(codigo) FROM produtos)

    WHILE(@contador < @totalProd)
    BEGIN
        SET @contador = @contador + 1
        
        IF((SELECT qtd_estoque FROM produtos WHERE codigo = @contador) < @margem)
        BEGIN
            SET @quantidade = @quantidade + 1
        END
    END

    RETURN @quantidade
END
GO

CREATE FUNCTION fn_tab_estoque(@margem INT)
RETURNS @tempTable TABLE
(
    codigo              INT,
    nome                VARCHAR(30),
    qtd_estoque         INT
)
AS
BEGIN
    INSERT INTO @tempTable(codigo, nome, qtd_estoque) SELECT codigo, nome, qtd_estoque FROM produtos WHERE qtd_estoque < @margem

    RETURN
END
GO

CREATE PROCEDURE sp_operacoes(@entrada CHAR(1), @codigo INT, @nome VARCHAR(30), @valor_unitario DECIMAL(7,2), @qtd_estoque INT, @saida VARCHAR(30) OUTPUT)
AS
    IF(@entrada = 'I' OR @entrada = 'i')
    BEGIN
        BEGIN TRY
            INSERT INTO produtos VALUES
            (@codigo, @nome, @valor_unitario, @qtd_estoque)

            SET @saida = 'Produto inserido'
        END TRY
        BEGIN CATCH
            IF((SELECT 1 FROM produtos WHERE codigo = @codigo) = 1)
            BEGIN
                RAISERROR('Produto já presente no banco', 16, 1)
            END
            ELSE
            BEGIN
                RAISERROR('Error ao processar inserção', 16, 1)
            END
        END CATCH
    END
    ELSE
    BEGIN
        IF(@entrada = 'U' OR @entrada = 'u')
        BEGIN
            BEGIN TRY
                BEGIN
                    UPDATE produtos
                    SET nome = @nome, valor_unitario = @valor_unitario, qtd_estoque = @qtd_estoque
                    WHERE codigo = @codigo

                    SET @saida = 'Produto atualizado'
                END
            END TRY
            BEGIN CATCH
                IF((SELECT 1 FROM produtos WHERE codigo = @codigo) = 1)
                BEGIN
                    RAISERROR('Error ao processar atualização', 16, 1)
                END
                ELSE
                BEGIN
                    RAISERROR('Produto não encontrado', 16, 1)
                END
            END CATCH
        END
        ELSE
        BEGIN
            IF(@entrada = 'D' OR @entrada = 'd')
            BEGIN
                BEGIN TRY
                    DELETE produtos
                    WHERE codigo = @codigo

                    SET @saida = 'Produto deletado'

                END TRY
                BEGIN CATCH
                    IF((SELECT 1 FROM produtos WHERE codigo = @codigo) = 1)
                    BEGIN
                        RAISERROR('Error ao processar deleção', 16, 1)
                    END
                    ELSE
                    BEGIN
                        RAISERROR('Produto não encontrado', 16, 1)
                    END
                END CATCH
            END
            ELSE
            BEGIN
                RAISERROR('Operação inválida', 16, 1)
            END
        END
    END
GO

INSERT INTO produtos VALUES
(1, 'Bola', 14.87, 6),
(2, 'carrinho', 21.40, 10)
GO

SELECT * FROM produtos

GO

CREATE TRIGGER t_insertVenda ON venda
AFTER INSERT
AS
BEGIN
    DECLARE @quantidade INT

    SELECT @quantidade = quantidade FROM INSERTED

    IF(@quantidade = 0)
    BEGIN
        ROLLBACK TRANSACTION
    END
END

SELECT * FROM venda

DELETE FROM venda