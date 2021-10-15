USE master
GO

DROP DATABASE manter_filmes
GO

CREATE DATABASE manter_filmes
GO

USE manter_filmes
GO

CREATE TABLE filmes
(
    idFilme         INT         NOT NULL,
    nomeBR          VARCHAR(45) NOT NULL,
    nomeEN          VARCHAR(45) NOT NULL,
    anoLancamento   INT         NOT NULL,
    sinopse         TEXT        NOT NULL

    PRIMARY KEY(idFilme)
)
GO

CREATE PROCEDURE operacao(@entrada CHAR(1), @id INT, @nomeBr VARCHAR(45), @nomeEN VARCHAR(45), @anoLancamento INT, @sinopse TEXT, @saida VARCHAR(50) OUTPUT)
AS
    IF(@entrada = 'I' OR @entrada = 'i')
    BEGIN
        BEGIN TRY
            IF(@nomeBr = '' OR @nomeEN = '')
            BEGIN
                RAISERROR('For input string: nomeBR or nomeEN', 16, 1)
            END
            ELSE
            BEGIN
                INSERT INTO filmes VALUES
                (@id, @nomeBr, @nomeEN, @anoLancamento, @sinopse)

                SET @saida = 'Filme inserido'
            END
        END TRY
        BEGIN CATCH
            IF((SELECT 1 FROM filmes WHERE idFilme = @id) = 1)
            BEGIN
                RAISERROR('Filme já presente no banco', 16, 1)
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
                IF(@nomeBr = '' OR @nomeEN = '')
                BEGIN
                    RAISERROR('For input string: nomeBR or nomeEN', 16, 1)
                END
                ELSE
                BEGIN
                    UPDATE filmes
                    SET nomeBR = @nomeBr, nomeEN = @nomeEN, anoLancamento = @anoLancamento, sinopse = @sinopse
                    WHERE idFilme = @id

                    SET @saida = 'Filme atualizado'
                END
            END TRY
            BEGIN CATCH
                IF((SELECT 1 FROM filmes WHERE idFilme = @id) = 1)
                BEGIN
                    RAISERROR('Error ao processar atualização', 16, 1)
                END
                ELSE
                BEGIN
                    RAISERROR('Filme não encontrado', 16, 1)
                END
            END CATCH
        END
        ELSE
        BEGIN
            IF(@entrada = 'D' OR @entrada = 'd')
            BEGIN
                BEGIN TRY
                    DELETE filmes
                    WHERE idFilme = @id

                    SET @saida = 'Filme deletado'

                END TRY
                BEGIN CATCH
                    IF((SELECT 1 FROM filmes WHERE idFilme = @id) = 1)
                    BEGIN
                        RAISERROR('Error ao processar deleção', 16, 1)
                    END
                    ELSE
                    BEGIN
                        RAISERROR('Filme não encontrado', 16, 1)
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

INSERT INTO filmes VALUES
(1, '123', '321', 2000, 'Teste 1'),
(2, 'sas', 'sas', 2019, 'Teste 2'),
(3, 'vertigo', 'vertigo, the end', 2010, 'Teste 3')
GO

SELECT * FROM filmes

DELETE FROM filmes