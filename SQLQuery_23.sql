-- 1) Fazer uma SP que receba um CHAR(11) na variável @cpf e, conforme o algoritmo de validação, determine se o cpf é válido ou inválido,
--    a procedure deve retornar uma variável do tipo BIT com 0 para inválido e 1 para válido. Apesar de válidos, CPFs com todos os números iguais devem ser descartados.

USE master
GO
DROP DATABASE cadastro
GO
CREATE DATABASE cadastro
GO
USE cadastro
GO

CREATE TABLE cadastro_cpf
(
    cpf         CHAR(11)                NOT NULL,
    nome        VARCHAR(250)            NOT NULL,
    logradouro  VARCHAR(250)            NOT NULL,
    numero      INT                     NOT NULL
    PRIMARY KEY(cpf)
)
GO

-- DROP PROCEDURE sp_cpf

CREATE PROCEDURE sp_cpf(@cpf CHAR(11), @nome VARCHAR(250), @logradouro VARCHAR(250), @numero INT, @saida VARCHAR(200) OUTPUT)
AS
    DECLARE @contador           INT,
            @digito             INT,
            @resultado          INT,
            @digito1            INT,
            @digito2            INT,
            @validadorIgual     INT,
            @numeroIgual        INT,
            @i                  INT

    SET @contador = 0
    SET @digito  = 1
    SET @resultado = 0
    SET @digito1 = 0
    SET @digito2 = 0
    SET @validadorIgual = 1
    SET @i = 1

    IF(LEN(@cpf) < 11)
    BEGIN
        RAISERROR('CPF inválido por falta de caracteres', 16, 1)
    END
    ELSE
    IF(@cpf = '00000000000')
    BEGIN
        RAISERROR('CPF inválido: não pode estar zerado', 16, 1)
    END
    ELSE
    BEGIN
        SET @numeroIgual = SUBSTRING(@cpf, @i, 1)
        WHILE(@i < 10)
        BEGIN
            SET @i = @i + 1
            IF(@numeroIgual = SUBSTRING(@cpf, @i, 1))
            BEGIN
                SET @numeroIgual = SUBSTRING(@cpf, @i, 1)
                SET @validadorIgual = @validadorIgual + 1
            END
        END
        IF(@validadorIgual = 10)
        BEGIN
            RAISERROR('CPF provavelmente inválido: todos os números são iguais', 16, 1)
        END
        ELSE
        BEGIN
            WHILE(@digito < 3)
            BEGIN
                IF(@digito = 1)
                BEGIN
                    WHILE(@contador < 9)
                    BEGIN
                        SET @contador = @contador + 1
                        SET @resultado = (@resultado + ((11 - @contador) * CONVERT(INT, SUBSTRING(@cpf, @contador, 1))))
                    END
                    SET @digito = 2
                    SET @resultado = (@resultado % 11)
                    IF(@resultado < 2)
                    BEGIN
                        SET @resultado = 0
                    END
                    ELSE
                    BEGIN
                        SET @resultado = (11 - @resultado)
                        SET @digito1 = @resultado
                    END
                    SET @resultado = 0
                    SET @contador = 0
                END
                ELSE
                IF(@digito = 2)
                BEGIN
                    WHILE(@contador < 9)
                    BEGIN
                        SET @contador = @contador + 1
                        SET @resultado = (@resultado + ((12 - @contador) * CONVERT(INT, SUBSTRING(@cpf, @contador, 1))))
                    END
                    SET @digito = 3
                    SET @resultado = (@resultado + (@digito1 * 2))
                    SET @resultado = (@resultado % 11)
                    IF(@resultado < 2)
                    BEGIN
                        SET @resultado = 0
                    END
                    ELSE
                    BEGIN
                        SET @resultado = (11 - @resultado)
                        SET @digito2 = @resultado
                    END
                END
            END
            PRINT('')
            PRINT('Digito 1: ' + CAST(@digito1 AS CHAR(1)))
            PRINT('')
            PRINT('Digito 2: ' + CAST(@digito2 AS CHAR(1)))
            PRINT('')
            IF((@cpf = (SUBSTRING(@cpf, 1, 9) + (CONVERT(CHAR(1), @digito1) + CONVERT(CHAR(1), @digito2)))) AND (@cpf <> '00000000000') AND (LEN(@cpf) = 11))
            BEGIN
                PRINT('1 - Válido')
                PRINT('')
                INSERT INTO cadastro_cpf VALUES
                (@cpf, @nome, @logradouro, @numero);
                RAISERROR('Dados cadastrados com sucesso', 16, 1)
            END
            ELSE
            BEGIN
                PRINT('0 - Inválido')
            END
        END
    END

-- Válido
DECLARE @out VARCHAR(200)
EXEC sp_cpf '22233366638', 'João 1', "Rua 123", 3, @out OUTPUT
PRINT @out

-- Inválido
DECLARE @out0 VARCHAR(200)
EXEC sp_cpf '', 'João 2', "Rua 123", 3, @out0 OUTPUT
PRINT @out0

-- Válido
DECLARE @out2 VARCHAR(200)
EXEC sp_cpf '88877723203', 'João 3', "Rua 123", 3, @out2 OUTPUT
PRINT @out2

-- Inválido
DECLARE @out3 VARCHAR(200)
EXEC sp_cpf '88877726726', 'João 4', "Rua 123", 3, @out3 OUTPUT
PRINT @out3

-- Inválido
DECLARE @out4 VARCHAR(200)
EXEC sp_cpf '31328657044', 'João 5', "Rua 123", 3, @out4 OUTPUT
PRINT @out4

-- Válido
DECLARE @out5 VARCHAR(200)
EXEC sp_cpf '31328657027', 'João 6', "Rua 123", 3, @out5 OUTPUT
PRINT @out5

-- Inválido
DECLARE @out6 VARCHAR(200)
EXEC sp_cpf '00000000000', 'João 7', "Rua 123", 3, @out6 OUTPUT
PRINT @out6

-- Inválido
DECLARE @out7 VARCHAR(200)
EXEC sp_cpf '11111111111', 'João 8', "Rua 123", 3, @out7 OUTPUT
PRINT @out7

SELECT * FROM cadastro_cpf
ORDER BY nome