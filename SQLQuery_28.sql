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
    SET @data_valida    = 1
    
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

    SET @contador = 0

    SET @saida = 'Sucesso'