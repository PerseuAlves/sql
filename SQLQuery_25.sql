use master

go

drop database campeonato_paulista

go

-- Criação das tabelas:

create database campeonato_paulista

go

use campeonato_paulista

go 

create table times(

codigo int not null,
nome   varchar(50) not null,
cidade varchar(50) not null,
estadio varchar(50) not null


primary key(codigo)

)

go

create table grupo(

grupo varchar not null,
codigo_time int not null,

foreign key(codigo_time) references  times(codigo),
primary key(grupo, codigo_time)

)

go

create table jogos(
    
codigo_time_a int not null,
codigo_time_b int not null,
gols_time_a	  int null,
gols_time_b	  int null,
data_partida  date not null

foreign key(codigo_time_a) references  times(codigo),
foreign key(codigo_time_b) references  times(codigo),
primary key(codigo_time_a,codigo_time_b,data_partida)

)

go

-- Criação das SP:

-- Parte 1 (Criação dos grupos)

-- sp que irá sortear grupos aleatórios com base nos 4 números de entrada (são esses números que dão a aleatoriedade do algoritmo)

CREATE PROCEDURE sp_sortear_grupos(@A INT, @B INT, @C INT, @D INT, @saida CHAR(1) OUTPUT, @saida2 CHAR(1) OUTPUT, @saida3 CHAR(1) OUTPUT, @saida4 CHAR(1) OUTPUT)
AS
    IF(@A = 1)
    BEGIN
        SET @saida = 'A'
    END
    ELSE
    IF(@A = 2)
    BEGIN
        SET @saida = 'B'
    END
    ELSE
    IF(@A = 3)
    BEGIN
        SET @saida = 'C'
    END
    ELSE
    IF(@A = 4)
    BEGIN
        SET @saida = 'D'
    END

    ----------------------

    IF(@B = 1)
    BEGIN
        SET @saida2 = 'A'
    END
    ELSE
    IF(@B = 2)
    BEGIN
        SET @saida2 = 'B'
    END
    ELSE
    IF(@B = 3)
    BEGIN
        SET @saida2 = 'C'
    END
    ELSE
    IF(@B = 4)
    BEGIN
        SET @saida2 = 'D'
    END

    ----------------------

    IF(@C = 1)
    BEGIN
        SET @saida3 = 'A'
    END
    ELSE
    IF(@C = 2)
    BEGIN
        SET @saida3 = 'B'
    END
    ELSE
    IF(@C = 3)
    BEGIN
        SET @saida3 = 'C'
    END
    ELSE
    IF(@C = 4)
    BEGIN
        SET @saida3 = 'D'
    END
    ----------------------
    IF(@D = 1)
    BEGIN
        SET @saida4 = 'A'
    END
    ELSE
    IF(@D = 2)
    BEGIN
        SET @saida4 = 'B'
    END
    ELSE
    IF(@D = 3)
    BEGIN
        SET @saida4 = 'C'
    END
    ELSE
    IF(@D = 4)
    BEGIN
        SET @saida4 = 'D'
    END
GO

-- OBS: Gerar um número aleatório (INT):

-- SELECT FLOOR(RAND()*(b-a+1))+a;  Where "a" is the smallest number and "b" is the largest number that you want to generate a random number for.

-- sp que irá alocar os grandes times primeiro nos grupos (é aqui que a sp criada anteriormente é usada)

CREATE PROCEDURE sp_alocar_times_grandes(@saida VARCHAR(200) OUTPUT)
AS
    DECLARE @codigoTime INT,
            @A          INT,
            @B          INT,
            @C          INT,
            @D          INT,
            @grupo_1    CHAR(1),
            @grupo_2    CHAR(1),
            @grupo_3    CHAR(1),
            @grupo_4    CHAR(1)

    SET @codigoTime = 0
    SET @A = (SELECT FLOOR(RAND()*(4-1+1))+1)
    SET @B = (SELECT FLOOR(RAND()*(4-1+1))+1)

    IF(@B = @A)
    BEGIN
        WHILE(@B = @A)
        BEGIN
            SET @B = (SELECT FLOOR(RAND()*(4-1+1))+1)
        END
    END

    SET @C = (SELECT FLOOR(RAND()*(4-1+1))+1)

    IF(@C = @A OR @C = @B)
    BEGIN
        WHILE(@C = @A OR @C = @B)
        BEGIN
            SET @C = (SELECT FLOOR(RAND()*(4-1+1))+1)
        END
    END

    SET @D = (SELECT FLOOR(RAND()*(4-1+1))+1)

    IF(@D = @A OR @D = @B OR @D = @C)
    BEGIN
        WHILE(@D = @A OR @D = @B OR @D = @C)
        BEGIN
            SET @D = (SELECT FLOOR(RAND()*(4-1+1))+1)
        END
    END

    --após alocar um número aleatório entre 0 e 4 nas variáveis, é usado a sp de sorteio

    EXEC sp_sortear_grupos @A, @B, @C, @D, @grupo_1 OUTPUT, @grupo_2 OUTPUT, @grupo_3 OUTPUT, @grupo_4 OUTPUT

    -- inserção dos times na tabela

    INSERT INTO grupo VALUES (@grupo_1, 3)
    INSERT INTO grupo VALUES (@grupo_2, 10)
    INSERT INTO grupo VALUES (@grupo_3, 13)
    INSERT INTO grupo VALUES (@grupo_4, 16)

GO

-- sp que irá alocar o restante dos times nos grupos

CREATE PROCEDURE sp_alocar_times_pequenos(@saida CHAR(1) OUTPUT) 
AS
    DECLARE @contador       INT,
            @numAleatorio   INT

    SET @contador = 0
    SET @numAleatorio = 0

    WHILE(@contador < 15)
    BEGIN
        SET @contador = @contador + 1
        IF(@contador != 3 AND @contador != 10 AND @contador != 13 AND @contador != 16)
        BEGIN  
            SET @numAleatorio = (SELECT FLOOR(RAND()*(4-1+1))+1)
            IF(@numAleatorio = 1 AND (SELECT COUNT(codigo_time) FROM grupo WHERE grupo = 'A') < 4)
            BEGIN
                INSERT INTO grupo VALUES ('A', @contador)
            END
            ELSE
            IF(@numAleatorio = 2 AND (SELECT COUNT(codigo_time) FROM grupo WHERE grupo = 'B') < 4)
            BEGIN
                INSERT INTO grupo VALUES ('B', @contador)
            END
            ELSE
            IF(@numAleatorio = 3 AND (SELECT COUNT(codigo_time) FROM grupo WHERE grupo = 'C') < 4)
            BEGIN
                INSERT INTO grupo VALUES ('C', @contador)
            END
            ELSE
            IF(@numAleatorio = 4 AND (SELECT COUNT(codigo_time) FROM grupo WHERE grupo = 'D') < 4)
            BEGIN
                INSERT INTO grupo VALUES ('D', @contador)
            END
            ELSE
            BEGIN
                SET @contador = @contador - 1
            END
        END
    END

GO

INSERT INTO times VALUES
(1,'Botafogo-sp','Ribeirão Preto','Santa Cruz'),
(2,'Bragantino','São Paulo','Arena Corinthians'),
(3,'Corinthians','São Paulo','Arena Corinthians'),
(4,'Ferroviária','Araraquara','Fonte Luminosa'),
(5,'Guarani','Campinas','Brinco de Ouro da Princesa'),
(6,'Ituano','Itu','Novelli Júnior'),
(7,'Mirassol','Mirassol','José Maria de Campos Maia'),
(8,'Novorizontino','Novo Horizonte','Jorge Ismael de Biasi'),
(9,'Oeste','Barueri','Arena Barueri'),
(10,'Palmeiras','São Paulo','Allianz Parque'),
(11,'Ponte Preta','Campinas','Moisés Lucarelli'),
(12,'Red Bull Brasil','Campinas','Moisés Lucarelli'),
(13,'Santos','Santos','Vila Belmiro'),
(14,'São Bento','Sorocaba','Walter Ribeiro'),
(15,'São Caetano','São Caetano do Sul','Anacletto Campanella'),
(16,'São Paulo','São Paulo','Morumbi')

GO

-- main sp que irá chamar todas as outras

CREATE PROCEDURE sp_gerar_grupos(@saida VARCHAR(15) OUTPUT)
AS
    DECLARE @resultado  VARCHAR(30),
            @resultado2 VARCHAR(30),
            @times      INT

    SET @times = (SELECT COUNT(codigo) FROM times);

    DISABLE TRIGGER t_block_operacoes_grupo ON grupo

    IF(@times = 16)
    BEGIN
        DELETE FROM grupo

        -- chama a procedure para preencher times grandes (sp_alocar_times_grandes)
        EXEC sp_alocar_times_grandes @resultado OUTPUT

        -- chama a procedure que preenche o resto dos times (sp_alocar_times_pequenos)
        EXEC sp_alocar_times_pequenos @resultado2 OUTPUT;

        ENABLE TRIGGER  t_block_operacoes_grupo ON grupo

        SET @saida = 'Grupos gerados'
    END
    ELSE
    BEGIN
        RAISERROR('Não há times suficientes para gerar os grupos', 16, 1)
    END
GO

-- Parte 2 (Pareamento e inser��o dos jogos com base nos dados inseridos na tabela "grupo")
----------------------------------------------------------------------------------------

-- 4 grupos com 4 times = 16 times no total 
-- Os times que est�o em grupo n�o se enfrentam
-- Os times que jogaram no mesmo dia n�o podem jogar novamente

CREATE PROCEDURE sp_verificar_se_jogo_ja_existe(@codigo1 INT,@codigo2 INT, @saida INT OUTPUT)
AS 
	DECLARE 
		@verificador INT

    SET @verificador = 0

	SET @verificador = (SELECT 1 FROM jogos WHERE 
		(codigo_time_a = @codigo1 AND codigo_time_b = @codigo2) OR
		(codigo_time_b = @codigo1 AND codigo_time_a = @codigo2) OR
		(codigo_time_a = @codigo1 AND codigo_time_b = @codigo1) OR
		(codigo_time_a = @codigo2 AND codigo_time_b = @codigo2))

		SELECT 1 FROM jogos WHERE 
		(codigo_time_a = 5 AND codigo_time_b = 1) OR
		(codigo_time_b = 1 AND codigo_time_a = 5) OR
		(codigo_time_a = 5 AND codigo_time_b = 5) OR
		(codigo_time_a = 1 AND codigo_time_b = 1)

		select* from jogos 

	IF(@verificador = 1)
	BEGIN 
		SET @saida = 1
	END 
	ELSE 
	BEGIN
		SET @saida = 0
	END

GO 

CREATE PROCEDURE sp_verificar_grupos_dos_times(@codigo1 INT,@codigo2 INT, @saida INT OUTPUT)
AS 
	DECLARE 
		@grupo_time1 CHAR(1),
		@grupo_time2 CHAR(1)

		SET @grupo_time1 = (SELECT grupo FROM grupo WHERE codigo_time = @codigo1)
		SET @grupo_time2 = (SELECT grupo FROM grupo WHERE codigo_time = @codigo2)
	
	IF(@grupo_time1 = @grupo_time2)
	BEGIN 
		SET @saida = 1
	END 
	ELSE 
	BEGIN
		SET @saida = 0
	END

GO



CREATE PROCEDURE sp_valida_datas (@data_partida DATE, @codigo_time1 INT, @codigo_time2 INT, @saida_datas_iguais INT OUTPUT)
AS
    DECLARE 
		@verificador1 INT,
        @verificador2 INT,
        @verificador3 INT,
        @verificador4 INT
	

    SET @verificador1 = 0
    SET @verificador2 = 0
    SET @verificador3 = 0
    SET @verificador4 = 0

		SET @verificador1 = (SELECT COUNT(data_partida) FROM jogos WHERE data_partida = @data_partida AND codigo_time_a = @codigo_time1)
		SET @verificador2 = (SELECT COUNT(data_partida) FROM jogos WHERE data_partida = @data_partida AND codigo_time_a = @codigo_time2)

		SET @verificador3 = (SELECT COUNT(data_partida) FROM jogos WHERE data_partida = @data_partida AND codigo_time_b = @codigo_time1)
		SET @verificador4 = (SELECT COUNT(data_partida) FROM jogos WHERE data_partida = @data_partida AND codigo_time_b = @codigo_time2)

		IF(@verificador1 > 0 OR @verificador2 > 0 OR @verificador3 > 0 OR @verificador4 > 0)
		BEGIN
			SET @saida_datas_iguais = 1
		END
		ELSE
		BEGIN
			SET @saida_datas_iguais = 0
		END

GO

-- GERA DATAS DA FASE INICIAL
CREATE PROCEDURE sp_gera_data(@contador INT, @saida DATE OUTPUT)
AS 

		IF(@contador = 1)
		BEGIN
			SET @saida = '2019-01-20'
		END
		ELSE
		BEGIN
			IF(@contador = 2)
			BEGIN
				SET @saida = '2019-01-23'
			END
			ELSE
			BEGIN
				IF(@contador = 3)
				BEGIN
					SET @saida = '2019-01-27'
				END
				ELSE
				BEGIN
					IF(@contador = 4)
					BEGIN
						SET @saida = '2019-01-30'
					END
					ELSE
					BEGIN
						IF(@contador = 5)
						BEGIN
							SET @saida = '2019-02-03'
						END
						ELSE
						BEGIN
							IF(@contador = 6)
							BEGIN
								SET @saida = '2019-02-06'
							END
							ELSE
							BEGIN
								IF(@contador = 7)
								BEGIN
									SET @saida = '2019-02-10'
								END
								ELSE
								BEGIN
									IF(@contador = 8)
									BEGIN
										SET @saida = '2019-02-13'
									END
									ELSE
									BEGIN
									IF(@contador = 9)
									BEGIN
										SET @saida = '2019-02-17'
									END
									ELSE
									BEGIN
										IF(@contador = 10)
										BEGIN
											SET @saida = '2019-02-20'
										END
										ELSE
										BEGIN
											IF(@contador = 11)
											BEGIN
												SET @saida = '2019-02-24'
											END
											ELSE
											BEGIN
												IF(@contador = 12)
												BEGIN
													SET @saida = '2019-02-27'
												END
											END
										END
									END
								END
							END
						END
					END
				END
			END
		END
	END

GO 

-- GERA AS DATAS DA FASE ELIMINATORIA
CREATE PROCEDURE sp_gera_data_eliminatorias (@contador INT, @saida DATE OUTPUT)
AS 
    IF(@contador = 40)
    BEGIN
        SET @saida = '2019-03-03' -- QUARTAS DE FINAL
    END
    ELSE
    BEGIN
        IF(@contador = 20)
        BEGIN
            SET @saida = '2019-03-06' -- SEMIFINAL
        END
        ELSE
        BEGIN
            IF(@contador = 10)
            BEGIN
                SET @saida = '2019-03-10' -- FINAL 1
            END
            ELSE
            BEGIN
                IF(@contador = 11)
                BEGIN
                    SET @saida = '2019-03-13'-- FINAL 2
                END
            END
        END
    END

GO

GO

----------------------|
---------------------||
---------------------||
---------------------||
-- A - B / C - D     ||
---------------------||
---- J: 16  /  16    ||
---------------------||
---------- D: 4      ||
---------------------||
-- B - C / A - D     ||
---------------------||
---- J: 16  /  16    ||
---------------------||
---------- D: 4      ||
---------------------||
-- C - A / D - B     ||
---------------------||
---- J: 16  /  16    ||
---------------------||
---------- D: 4      ||
---------------------||
---------------------||
---------------------||
---------------------|/

-- GRUPO A  GRUPO B
-- 1        5 
-- 2        6
-- 3        7
-- 4        8

-- 1 X 5 DATA 1
-- 1 X 6 DATA 2
-- 1 X 7 DATA 3 
-- 1 X 8 DATA 4

-- 2 X 5 DATA 2
-- 2 X 6 DATA 1
-- 2 X 7 DATA 4
-- 2 X 8 DATA 3

-- 3 X 5 DATA 3
-- 3 X 6 DATA 4
-- 3 X 7 DATA 1 
-- 3 X 8 DATA 2
--
-- 4 X 5 DATA 4
-- 4 X 6 DATA 3
-- 4 X 7 DATA 2
-- 4 X 8 DATA 1
--
-- SET = 2019-01-20
--
-- JOGO JÁ EXISTE ?
--
--     VERIFICA SE É SABADO OU DOMINGO 
--
--    E ADICIONA VALOR A DATA 
--
-- SE NAO EXISTE
--
-- ELE FAZ A INSERÇÃO DIRETO

---------------------
---------------------

CREATE PROCEDURE sp_gerar_jogos(@saida VARCHAR(30) OUTPUT)
AS
    DECLARE @contador       INT,
            @contador_2     INT,
            @cotnador_times INT,
            @contador_jogos INT,
            @index_time     INT,
            @index_time_2   INT,

            @gols_time_1    INT,
            @gols_time_2    INT,
            @data_valida    INT,
            @data           DATE
            

    SET @contador       = 0
    SET @contador_2     = 0
    SET @cotnador_times = 0
    SET @contador_jogos = 0
    SET @index_time     = 0
    SET @index_time_2   = 0
    SET @gols_time_1    = 0
    SET @gols_time_2    = 0
    SET @data_valida    = 1;

    DISABLE TRIGGER t_block_operacoes_jogos ON jogos

    IF((SELECT COUNT(codigo_time_a) FROM jogos) > 0)
    BEGIN
        DELETE FROM jogos
    END
    
    WHILE(@contador < 3)
    BEGIN
        SET @contador = @contador + 1

        IF(@contador = 1)
        BEGIN
            -- A - B / C - D

            WHILE(@contador_2 < 2)
            BEGIN
                SET @contador_2 = @contador_2 + 1

                IF(@contador_2 = 1)
                BEGIN
                    --table_1 = A, table_2 = B

                    -- jogos com o time A

                    WHILE(@cotnador_times < 4)
                    BEGIN
                        SET @cotnador_times = @cotnador_times + 1

                        SET @data = '2019-01-20'

                        -- Pega o time de index @cotnador_times

                        SET @index_time = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'A') AS foo WHERE RowNum = @cotnador_times)

                        -- jogos com o time B

                        WHILE(@contador_jogos < 4)
                        BEGIN
                            SET @contador_jogos = @contador_jogos + 1

                            -- Pega o time de index @contador_jogos

                            SET @index_time_2 = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'B') AS foo WHERE RowNum = @contador_jogos)

                            EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT

                            WHILE(@data_valida = 1)
                            BEGIN
                                IF(DATEPART(WEEKDAY, @data) = 1) --Se for domingo, adiciona mais 3 dias a data do jogo
                                BEGIN
                                    SET @data = DATEADD(DAY, 3, @data)
                                END
                                ELSE --Se não for domingo, adiciona mais 4 dias a data do jogo
                                BEGIN
                                    SET @data = DATEADD(DAY, 4, @data)
                                END

                                EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                            END

                            INSERT INTO jogos VALUES
                            (@index_time, @index_time_2, @gols_time_1, @gols_time_2, @data)

                            SET @data = '2019-01-20'
                        END

                        -- Zerar o contador de jogos do grupo_2

                        SET @contador_jogos = 0
                    END

                    -- Zerar o contador de jogos do grupo_1

                    SET @cotnador_times = 0

                END
                ELSE
                BEGIN
                    IF(@contador_2 = 2)
                    BEGIN
                        --table_1 = C, table_2 = D

                        WHILE(@cotnador_times < 4)
                        BEGIN
                            SET @cotnador_times = @cotnador_times + 1

                            SET @data = '2019-01-20'

                            -- PEGA O TIME DE INDEX @cotnador_times

                            SET @index_time = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'C') AS foo WHERE RowNum = @cotnador_times)

                            -- jogos com o time B
                            
                            WHILE(@contador_jogos < 4)
                            BEGIN
                                SET @contador_jogos = @contador_jogos + 1

                                -- Pega o time de index @contador_jogos

                                SET @index_time_2 = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'D') AS foo WHERE RowNum = @contador_jogos)

                                EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                                
                                WHILE(@data_valida = 1)
                                BEGIN
                                    IF(DATEPART(WEEKDAY, @data) = 1) --Se for domingo, adiciona mais 3 dias a data do jogo
                                    BEGIN
                                        SET @data = DATEADD(DAY, 3, @data)
                                    END
                                    ELSE --Se não for domingo, adiciona mais 4 dias a data do jogo
                                    BEGIN
                                        SET @data = DATEADD(DAY, 4, @data)
                                    END

                                    EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                                END

                                INSERT INTO jogos VALUES
                                (@index_time, @index_time_2, @gols_time_1, @gols_time_2, @data)

                                SET @data = '2019-01-20'
                            END

                            -- Zerar o contador de jogos do grupo_2

                            SET @contador_jogos = 0
                        END

                        -- Zerar o contador de jogos do grupo_1

                        SET @cotnador_times = 0

                    END
                END
            END

            -- Zerar o contador da inserção

            SET @contador_2 = 0
        END
        ELSE
        BEGIN
            IF(@contador = 2)
            BEGIN
                -- B - C / A - D

                WHILE(@contador_2 < 2)
                BEGIN
                    SET @contador_2 = @contador_2 + 1

                    IF(@contador_2 = 1)
                    BEGIN
                        --table_1 = B, table_2 = C

                        WHILE(@cotnador_times < 4)
                        BEGIN
                            SET @cotnador_times = @cotnador_times + 1

                            SET @data = '2019-02-03'

                            -- Pega o time de index @cotnador_times

                            SET @index_time = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'B') AS foo WHERE RowNum = @cotnador_times)

                            -- jogos com o time B
                            
                            WHILE(@contador_jogos < 4)
                            BEGIN
                                SET @contador_jogos = @contador_jogos + 1

                                -- Pega o time de index @contador_jogos

                                SET @index_time_2 = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'C') AS foo WHERE RowNum = @contador_jogos)

                                EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                                
                                WHILE(@data_valida = 1)
                                BEGIN
                                    IF(DATEPART(WEEKDAY, @data) = 1) --Se for domingo, adiciona mais 3 dias a data do jogo
                                    BEGIN
                                        SET @data = DATEADD(DAY, 3, @data)
                                    END
                                    ELSE --Se não for domingo, adiciona mais 4 dias a data do jogo
                                    BEGIN
                                        SET @data = DATEADD(DAY, 4, @data)
                                    END

                                    EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                                END

                                INSERT INTO jogos VALUES
                                (@index_time, @index_time_2, @gols_time_1, @gols_time_2, @data)

                                SET @data = '2019-02-03'
                            END

                            -- Zerar o contador de jogos do grupo_2

                            SET @contador_jogos = 0
                        END

                        -- Zerar o contador de jogos do grupo_1

                        SET @cotnador_times = 0

                    END
                    ELSE
                    BEGIN
                        IF(@contador_2 = 2)
                        BEGIN
                            --table_1 = A, table_2 = D

                            WHILE(@cotnador_times < 4)
                            BEGIN
                                SET @cotnador_times = @cotnador_times + 1

                                SET @data = '2019-02-03'

                                -- PEGA O TIME DE INDEX @cotnador_times

                                SET @index_time = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'A') AS foo WHERE RowNum = @cotnador_times)

                                -- jogos com o time B
                                
                                WHILE(@contador_jogos < 4)
                                BEGIN
                                    SET @contador_jogos = @contador_jogos + 1

                                    -- Pega o time de index @contador_jogos

                                    SET @index_time_2 = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'D') AS foo WHERE RowNum = @contador_jogos)

                                    EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                                    
                                    WHILE(@data_valida = 1)
                                    BEGIN
                                        IF(DATEPART(WEEKDAY, @data) = 1) --Se for domingo, adiciona mais 3 dias a data do jogo
                                        BEGIN
                                            SET @data = DATEADD(DAY, 3, @data)
                                        END
                                        ELSE --Se não for domingo, adiciona mais 4 dias a data do jogo
                                        BEGIN
                                            SET @data = DATEADD(DAY, 4, @data)
                                        END

                                        EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                                    END

                                    INSERT INTO jogos VALUES
                                    (@index_time, @index_time_2, @gols_time_1, @gols_time_2, @data)

                                    SET @data = '2019-02-03'
                                END

                                -- Zerar o contador de jogos do grupo_2

                                SET @contador_jogos = 0
                            END

                            -- Zerar o contador de jogos do grupo_1

                            SET @cotnador_times = 0

                        END
                    END
                END

                -- Zerar o contador da inserção

                SET @contador_2 = 0
            END
            ELSE
            BEGIN
                IF(@contador = 3)
                BEGIN
                    -- C - A / D - B

                WHILE(@contador_2 < 2)
                BEGIN
                    SET @contador_2 = @contador_2 + 1

                    IF(@contador_2 = 1)
                    BEGIN
                        --table_1 = C, table_2 = A

                        WHILE(@cotnador_times < 4)
                        BEGIN
                            SET @cotnador_times = @cotnador_times + 1

                            SET @data = '2019-02-17'

                            -- Pega o time de index @cotnador_times

                            SET @index_time = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'C') AS foo WHERE RowNum = @cotnador_times)

                            -- jogos com o time B
                            
                            WHILE(@contador_jogos < 4)
                            BEGIN
                                SET @contador_jogos = @contador_jogos + 1

                                -- Pega o time de index @contador_jogos

                                SET @index_time_2 = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'A') AS foo WHERE RowNum = @contador_jogos)

                                EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                                
                                WHILE(@data_valida = 1)
                                BEGIN
                                    IF(DATEPART(WEEKDAY, @data) = 1) --Se for domingo, adiciona mais 3 dias a data do jogo
                                    BEGIN
                                        SET @data = DATEADD(DAY, 3, @data)
                                    END
                                    ELSE --Se não for domingo, adiciona mais 4 dias a data do jogo
                                    BEGIN
                                        SET @data = DATEADD(DAY, 4, @data)
                                    END

                                    EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                                END

                                INSERT INTO jogos VALUES
                                (@index_time, @index_time_2, @gols_time_1, @gols_time_2, @data)

                                SET @data = '2019-02-17'
                            END

                            -- Zerar o contador de jogos do grupo_2

                            SET @contador_jogos = 0
                        END

                        -- Zerar o contador de jogos do grupo_1

                        SET @cotnador_times = 0

                        END
                        ELSE
                        BEGIN
                            IF(@contador_2 = 2)
                            BEGIN
                                --table_1 = D, table_2 = B

                                WHILE(@cotnador_times < 4)
                                BEGIN
                                    SET @cotnador_times = @cotnador_times + 1

                                    SET @data = '2019-02-17'

                                    -- PEGA O TIME DE INDEX @cotnador_times

                                    SET @index_time = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'D') AS foo WHERE RowNum = @cotnador_times)

                                    -- jogos com o time B
                                    
                                    WHILE(@contador_jogos < 4)
                                    BEGIN
                                        SET @contador_jogos = @contador_jogos + 1

                                        -- Pega o time de index @contador_jogos

                                        SET @index_time_2 = (SELECT codigo_time FROM (SELECT codigo_time,  ROW_NUMBER() OVER(ORDER BY grupo) as RowNum  FROM grupo WHERE grupo = 'B') AS foo WHERE RowNum = @contador_jogos)

                                        EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                                        
                                        WHILE(@data_valida = 1)
                                        BEGIN
                                            IF(DATEPART(WEEKDAY, @data) = 1) --Se for domingo, adiciona mais 3 dias a data do jogo
                                            BEGIN
                                                SET @data = DATEADD(DAY, 3, @data)
                                            END
                                            ELSE --Se não for domingo, adiciona mais 4 dias a data do jogo
                                            BEGIN
                                                SET @data = DATEADD(DAY, 4, @data)
                                            END

                                            EXEC sp_valida_datas @data, @index_time, @index_time_2, @data_valida OUTPUT
                                        END

                                        INSERT INTO jogos VALUES
                                        (@index_time, @index_time_2, @gols_time_1, @gols_time_2, @data)

                                        SET @data = '2019-02-17'
                                    END

                                    -- Zerar o contador de jogos do grupo_2

                                    SET @contador_jogos = 0
                                END

                                -- Zerar o contador de jogos do grupo_1

                                SET @cotnador_times = 0
                            END
                        END
                    END

                    -- Zerar o contador da inserção

                    SET @contador_2 = 0
                END
            END
        END
    END

    SET @contador = 0;

    ENABLE TRIGGER  t_block_operacoes_jogos ON jogos

    SET @saida = 'Sucesso'

GO

-- Teste da parte 1 (Criação dos grupos)
----------------------------------------------------------------------------------------
DECLARE @resultado VARCHAR(30)
EXEC sp_gerar_grupos @resultado OUTPUT

GO

-- Teste da parte 2 (Cria��o dos jogos)
----------------------------------------------------------------------------------------
DECLARE @saidaFinal INT
EXEC sp_gerar_jogos @saidaFinal OUTPUT

GO

/*

GO

SELECT * FROM times

GO

SELECT * FROM grupo

GO

SELECT * FROM jogos ORDER BY data_partida

--GO

DELETE FROM times

GO

DELETE FROM grupo

GO

DELETE FROM jogos

GO

DROP TABLE grupo

GO

DROP TABLE jogos

GO

DROP TABLE times

GO

DROP PROCEDURE sp_alocar_times_grandes
GO
DROP PROCEDURE sp_alocar_times_pequenos
GO
DROP PROCEDURE sp_gerar_jogos
GO
DROP PROCEDURE sp_gerar_grupos
GO
DROP PROCEDURE sp_sortear_grupos
GO
DROP PROCEDURE sp_alocar_times_grandes
GO
DROP PROCEDURE sp_alocar_times_pequenos
GO
DROP PROCEDURE sp_gera_data
GO
DROP PROCEDURE sp_gerar_jogos
GO
DROP PROCEDURE sp_main
GO
DROP PROCEDURE sp_sortear_grupos
GO
DROP PROCEDURE sp_valida_datas
GO
DROP PROCEDURE sp_verificar_grupos_dos_times
GO
DROP PROCEDURE sp_verificar_se_jogo_ja_existe
GO
DROP PROCEDURE sp_gera_data_eliminatorias
GO

INSERT INTO jogos VALUES
(1, 16, 1, 2, '2019-01-01'),
(2, 14, 1, 2, '2019-01-01'),
(3, 15, 1, 2, '2019-01-01'),
(4, 13, 1, 2, '2019-01-01'),
(5, 12, 1, 2, '2019-01-01'),
(6, 9, 1, 2, '2019-01-01'),
(7, 8, 1, 2, '2019-01-01'),
(10, 11, 1, 2, '2019-01-01')
GO

SELECT * FROM jogos WHERE data_partida = '2019-01-01'

*/

-- AV 2:
----------------------------------------------------------------------------------------

USE campeonato_paulista

GO

CREATE FUNCTION f_gols_marcados (@codigo INT)
RETURNS INT
AS
BEGIN 
	DECLARE @gols_marcados INT
	SET @gols_marcados = (SELECT SUM(gols_time_a) AS gols_marcados FROM jogos WHERE codigo_time_a = @codigo AND gols_time_a IS NOT NULL)
	SET @gols_marcados = @gols_marcados + (SELECT SUM(gols_time_b) AS gols_marcados FROM jogos WHERE codigo_time_b = @codigo AND gols_time_b IS NOT NULL)

	RETURN @gols_marcados
END

GO 

CREATE FUNCTION f_gols_sofrido (@codigo INT)
RETURNS INT
AS
BEGIN 
	DECLARE @gols_sofridos INT
	SET @gols_sofridos = (SELECT SUM(gols_time_b) AS gols_marcados FROM jogos WHERE codigo_time_a = @codigo AND gols_time_b IS NOT NULL)
	SET @gols_sofridos = @gols_sofridos + (SELECT SUM(gols_time_a) AS gols_marcados FROM jogos WHERE codigo_time_b = @codigo AND gols_time_a IS NOT NULL)

	RETURN @gols_sofridos
END

GO

CREATE FUNCTION f_calc_vitorias (@codigo INT)
RETURNS INT
AS
BEGIN 
	DECLARE @vitorias INT

	SET @vitorias = (SELECT COUNT(data_partida) AS vitorias FROM jogos WHERE codigo_time_a = @codigo AND gols_time_a > gols_time_b AND gols_time_a IS NOT NULL)
	SET @vitorias = @vitorias + (SELECT COUNT(data_partida) AS vitorias FROM jogos WHERE codigo_time_b = @codigo AND gols_time_b > gols_time_a AND gols_time_b IS NOT NULL)

	RETURN @vitorias
END

GO

CREATE FUNCTION f_calc_derrotas (@codigo INT)
RETURNS INT
AS
BEGIN 
	DECLARE @derrotas INT

	SET @derrotas = (SELECT COUNT(data_partida) AS derrotas FROM jogos WHERE codigo_time_a = @codigo AND gols_time_b > gols_time_a AND gols_time_a IS NOT NULL)
	SET @derrotas = @derrotas + (SELECT COUNT(data_partida) AS derrotas FROM jogos WHERE codigo_time_b = @codigo AND gols_time_a > gols_time_b AND gols_time_b IS NOT NULL)

	RETURN @derrotas
END

GO

CREATE FUNCTION f_calc_empates (@codigo INT)
RETURNS INT
AS
BEGIN 
	DECLARE @empates INT

	SET @empates = (SELECT COUNT(data_partida) AS empates FROM jogos WHERE codigo_time_a = @codigo AND gols_time_b = gols_time_a AND gols_time_a IS NOT NULL)
	SET @empates = @empates + (SELECT COUNT(data_partida) AS empates FROM jogos WHERE codigo_time_b = @codigo AND gols_time_a = gols_time_b AND gols_time_b IS NOT NULL)

	RETURN @empates
END

GO

CREATE FUNCTION f_calc_qtd_jogos (@codigo INT)
RETURNS INT
AS
BEGIN 
	DECLARE @jogos INT

	SET @jogos = (SELECT COUNT(data_partida) AS qtd_de_jogos FROM jogos WHERE codigo_time_a = @codigo OR  codigo_time_b = @codigo AND gols_time_a IS NOT NULL)

	RETURN @jogos
END

GO

----------------------------------------------------------------------------------------

CREATE FUNCTION f_classificacao_grupos (@grupo CHAR(1))
RETURNS @table TABLE(
nome_time					VARCHAR(100),
pontos						INT,
jogos						INT,
vitorias					INT,
empates						INT,
derrotas					INT, 
gols_marcados				INT,
gols_sofridos				INT, 
saldo_de_gols				INT
)
AS
BEGIN 
	
	-- INSERINDO OS NOMES DO TIMES 
	INSERT INTO @table(nome_time)
		SELECT nome FROM times, grupo WHERE codigo = codigo_time AND grupo = @grupo

	-- INSERINDO OS GOLS MARCADOS 
	UPDATE @table
		SET gols_marcados = (SELECT dbo.f_gols_marcados((SELECT codigo FROM times WHERE nome = nome_time)))

	-- INSERINDO OS GOLS SOFRIDOS
	UPDATE @table
		SET gols_sofridos = (SELECT dbo.f_gols_sofrido((SELECT codigo FROM times WHERE nome = nome_time)))

	--INSERINDO SALDO DE GOLS 
	UPDATE @table
		SET saldo_de_gols = gols_sofridos- gols_marcados

	--INSERINDO SALDO DE GOLS 
	UPDATE @table
		SET saldo_de_gols = gols_marcados- gols_sofridos
	
	-- INSERINDO OS VITORIAS
	UPDATE @table
		SET vitorias = (SELECT dbo.f_calc_vitorias((SELECT codigo FROM times WHERE nome = nome_time)))

	-- INSERINDO OS DERROTAS
	UPDATE @table
		SET derrotas = (SELECT dbo.f_calc_derrotas((SELECT codigo FROM times WHERE nome = nome_time)))

	-- INSERINDO OS EMPATES
	UPDATE @table
		SET empates = (SELECT dbo.f_calc_empates((SELECT codigo FROM times WHERE nome = nome_time)))

	-- INSERINDO OS PONTOS
	UPDATE @table
		SET pontos = + empates+(vitorias*3)

	-- INSERINDO OS QUANTIDADE DE JOGOS
	UPDATE @table
		SET jogos = (SELECT dbo.f_calc_qtd_jogos((SELECT codigo FROM times WHERE nome = nome_time)))

	RETURN 
END

GO

CREATE FUNCTION f_classificacao_geral ()
RETURNS @table TABLE(
nome_time					VARCHAR(100) ,
pontos						INT,
jogos						INT,
vitorias					INT,
empates						INT,
derrotas					INT, 
gols_marcados				INT,
gols_sofridos				INT, 
saldo_de_gols				INT
)
AS
BEGIN 
	
	-- INSERINDO OS NOMES DO TIMES DO GRUPO A
	INSERT INTO @table 
		SELECT * FROM f_classificacao_grupos('A') 

	-- INSERINDO OS NOMES DO TIMES DO GRUPO B
	INSERT INTO @table
		SELECT * FROM f_classificacao_grupos('B') 

	-- INSERINDO OS NOMES DO TIMES DO GRUPO C
	INSERT INTO @table
		SELECT * FROM f_classificacao_grupos('C') 

	-- INSERINDO OS NOMES DO TIMES DO GRUPO D
	INSERT INTO @table
		SELECT * FROM f_classificacao_grupos('D') 

	RETURN 
END

GO

CREATE FUNCTION f_quartas_de_final()
RETURNS @table TABLE(
id							INT,
nome_time1					VARCHAR(100),
nome_time2					VARCHAR(100)
)
AS
BEGIN 

		INSERT INTO @table (id)VALUES (1),(2),(3),(4)

		--INSERINDO PRIMEIRO CONFRONTO DAS QUARTAS GRUPO A
		UPDATE  @table 
			SET nome_time1=		(SELECT top 1 nome_time FROM f_classificacao_grupos('A') 
								ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_de_gols DESC)
								WHERE id = 1

		UPDATE @table
			SET nome_time2 = (SELECT nome_time FROM (SELECT nome_time,  ROW_NUMBER() OVER(ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_de_gols DESC) as RowNum 
								FROM f_classificacao_grupos('A')) AS foo WHERE RowNum = 2)
								WHERE id = 1

		--INSERINDO PRIMEIRO CONFRONTO DAS QUARTAS GRUPO B
		UPDATE  @table 
			SET nome_time1=		(SELECT top 1 nome_time FROM f_classificacao_grupos('B') 
								ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_de_gols DESC)
								WHERE id = 2

		UPDATE @table
			SET nome_time2 = (SELECT nome_time FROM (SELECT nome_time,  ROW_NUMBER() OVER(ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_de_gols DESC) as RowNum 
								FROM f_classificacao_grupos('B')) AS foo WHERE RowNum = 2)
								WHERE id = 2

		--INSERINDO PRIMEIRO CONFRONTO DAS QUARTAS GRUPO C
		UPDATE  @table 
			SET nome_time1=		(SELECT top 1 nome_time FROM f_classificacao_grupos('C') 
								ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_de_gols DESC)
								WHERE id = 3

		UPDATE @table
			SET nome_time2 = (SELECT nome_time FROM (SELECT nome_time,  ROW_NUMBER() OVER(ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_de_gols DESC) as RowNum 
								FROM f_classificacao_grupos('C')) AS foo WHERE RowNum = 2)
								WHERE id = 3

		--INSERINDO PRIMEIRO CONFRONTO DAS QUARTAS GRUPO D
		UPDATE  @table 
			SET nome_time1=		(SELECT top 1 nome_time FROM f_classificacao_grupos('D') 
								ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_de_gols DESC)
								WHERE id = 4

		UPDATE @table
			SET nome_time2 = (SELECT nome_time FROM (SELECT nome_time,  ROW_NUMBER() OVER(ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_de_gols DESC) as RowNum 
								FROM f_classificacao_grupos('D')) AS foo WHERE RowNum = 2)
								WHERE id = 4
	RETURN 
END

GO

SELECT * FROM dbo.f_quartas_de_final() as Quartas

GO

----------------------------------------------------------------------------------------

CREATE PROCEDURE atualiza_gols(@codigo_time_a INT, @codigo_time_b INT, @gols_time_a INT, @gols_time_b INT, @saida VARCHAR(100) OUTPUT)
AS
	DECLARE @erro VARCHAR(MAX)
			
	
	BEGIN TRY
        DISABLE TRIGGER t_block_operacoes_jogos ON jogos
		UPDATE jogos
		SET gols_time_a = @gols_time_a, gols_time_b = @gols_time_b
		WHERE codigo_time_a = @codigo_time_a AND codigo_time_b = @codigo_time_b;
        ENABLE TRIGGER t_block_operacoes_jogos ON jogos
		SET @saida = (SELECT data_partida FROM jogos WHERE codigo_time_a = @codigo_time_a AND codigo_time_b = @codigo_time_b)
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		RAISERROR(@erro, 16,1)
	END CATCH

GO

-- BLOQUEANDO DELETE, INSERT E UPDATE NA TABELA GRUPO 
CREATE TRIGGER t_block_operacoes_grupo ON grupo
FOR DELETE, INSERT, UPDATE
AS
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR('NÃO É PERMITIDO FAZER DELETE, UPDATE OU INSERT NESSA TABELA',16,1)
END 

GO

-- BLOQUEANDO DELETE, INSERT E UPDATE NA TABELA TIMES
CREATE TRIGGER t_block_operacoes_times ON times
FOR  DELETE, INSERT, UPDATE
AS
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR('NÃO É PERMITIDO FAZER DELETE, UPDATE OU INSERT NESSA TABELA',16,1)
END

GO

-- BLOQUEANDO DELETE, INSERT E UPDATE NA TABELA JOGOS
CREATE TRIGGER t_block_operacoes_jogos ON jogos
FOR  DELETE, INSERT
AS
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR('NÃO É PERMITIDO FAZER DELETE OU INSERT NESSA TABELA',16,1)
END

GO
-----------------------

-- ATIVANDO E DESATIVANDO TRIGGERS
DISABLE TRIGGER t_block_operacoes_grupo ON grupo

GO

ENABLE TRIGGER  t_block_operacoes_grupo ON grupo

GO

-- ATIVANDO E DESATIVANDO TRIGGERS
DISABLE TRIGGER t_block_operacoes_jogos ON jogos

GO

ENABLE TRIGGER  t_block_operacoes_jogos ON jogos