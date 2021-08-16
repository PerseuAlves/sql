--Fazer um algoritmo que leia 1 número e mostre se é múltiplo de 2,3,5 ou nenhum deles

DECLARE @numero     INT,
        @resultado  DECIMAL(5,2),
        @contador   INT,
        @boolean    INT

SET @numero = 30
SET @resultado = 0
SET @contador = 1
SET @boolean = 0

PRINT('')
PRINT('Entrada: ' + CAST(@numero AS VARCHAR(1000)))

WHILE (@contador < 5)
BEGIN
    SET @contador = @contador + 1
    IF(@contador = 2 OR @contador = 3 OR @contador = 5)
    BEGIN
        SET @resultado = (@numero % @contador)
        IF (@resultado <> 0)
        BEGIN
            SET @boolean = @boolean + 1
        END
        ELSE
        BEGIN
            PRINT('É múltiplo de ' + CAST(@contador AS VARCHAR(1)))
        END
    END
END
IF(@boolean = 3)
BEGIN
    PRINT('Não é múltiplo de nenhum')
END
PRINT('')

--Fazer um algoritmo que inverta uma palavra e mostre a palavra original toda minúscula (independente da entrada) e a invertida toda maiúscula.

DECLARE @palavra            VARCHAR(MAX),
        @palavraInvertida   VARCHAR(MAX),
        @aux                VARCHAR(MAX),
        @contador2          INT,
        @lenPalvra          INT

PRINT('')
SET @palavra = 'PAnela'
SET @contador2 = 0
SET @palavra = LOWER(@palavra)

PRINT('Palavra: ' + @palavra)
PRINT('')

SET @lenPalvra = LEN(@palavra)

WHILE(@lenPalvra > @contador2)
BEGIN
    SET @lenPalvra = @lenPalvra - 1
    SET @aux = SUBSTRING(@palavra, @lenPalvra + 1, 1)
    SET @palavraInvertida = CONCAT(@palavraInvertida, @aux)
END
PRINT('Palavra invertida: ' + UPPER(@palavraInvertida))
PRINT('')

--Exercícios:

--1. Fazer um algoritmo que leia 3 valores e retorne se os valores formam um triângulo e se ele é isóceles, escaleno ou equilátero. Condições para formar um triângulo:
--	Nenhum valor pode ser = 0
--	Um lado não pode ser maior que a soma dos outros 2.

DECLARE @ladoA       INT,
        @ladoB       INT,
        @ladoC       INT

SET @ladoA = 3
SET @ladoB = 5
SET @ladoC = 3

PRINT('')

IF(@ladoA <= 0 OR @ladoB <= 0 OR @ladoC <= 0)
BEGIN
    PRINT('Error, medidas inválidas')
END
ELSE
BEGIN
    IF(@ladoA = @ladoB AND @ladoB = @ladoC)
    BEGIN
        PRINT('É um triângulo equilátero')
    END
    ELSE
    BEGIN
        IF(@ladoA <> @ladoB AND @ladoA <> @ladoC AND @ladoB <> @ladoC)
        BEGIN
            PRINT('É um triângulo escaleno')
        END
        ELSE
        BEGIN
            PRINT('É um triângulo isóceles')
        END
    END
END
PRINT('')

--2. Fazer um algoritmo que calcule e exiba, os 15 primeiros termos da série de Fibonacci:
--1,1,2,3,5,8,13,21,...
--Ao final, deve calcular e exibir a soma dos 15 termos

DECLARE @aux1       INT,
        @aux2       INT,
        @termo      INT,
        @contador3  INT

SET @aux1 = 1
SET @aux2 = 1
SET @termo = 1
SET @contador3 = 0

PRINT('')
PRINT(0)
PRINT(1)
PRINT(1)

WHILE(@contador3 < 12)
BEGIN
    SET @contador3 = @contador3 + 1
    SET @aux1 = @termo
    SET @termo = @termo + @aux2
    SET @aux2 = @aux1
    PRINT(@termo)
END
PRINT('')

--3. Fazer um algoritmo que retorne se duas cadeias de caracteres são palíndromos

DECLARE @palavra1            VARCHAR(MAX),
        @palavraInvertida1   VARCHAR(MAX),
        @aux3                VARCHAR(MAX),
        @contador4           INT,
        @lenPalvra1          INT

PRINT('')
SET @palavra1 = 'eve'
SET @contador4 = 0

PRINT('Palavra: ' + @palavra1)
PRINT('')

SET @lenPalvra1 = LEN(@palavra1)

WHILE(@lenPalvra1 > @contador4)
BEGIN
    SET @lenPalvra1 = @lenPalvra1 - 1
    SET @aux3 = SUBSTRING(@palavra1, @lenPalvra1 + 1, 1)
    SET @palavraInvertida1 = CONCAT(@palavraInvertida1, @aux3)
END
PRINT('Palavra invertida: ' + @palavraInvertida1)
PRINT('')

IF(@palavra1 = @palavraInvertida1)
BEGIN
    PRINT('É palíndromo')
END
ELSE
BEGIN
    PRINT('Não é palíndromo')
END   
PRINT('') 

--4. Fazer um algoritmo que verifique em uma entrada no formato de uma frase, quantas palavras tem e exiba a quantidade de palavras.

DECLARE @frase               VARCHAR(MAX),
        @aux4                VARCHAR(MAX),
        @contador5           INT,
        @lenFrase            INT,
        @palavras            INT

PRINT('')
SET @frase = '    Vou chegar tarde hoje   '
SET @contador5 = 0
SET @palavras = 0

PRINT('Frase: ' + @frase)
PRINT('')

SET @frase = LTRIM(RTRIM(@frase))
SET @lenFrase = LEN(@frase)

WHILE(@contador5 < @lenFrase)
BEGIN
    SET @contador5 = @contador5 + 1
    SET @aux4 = SUBSTRING(@frase, @contador5, 1)
    IF(@aux4 = ' ')
    BEGIN
        SET @palavras = @palavras + 1
    END
END

IF(LEN(@frase) = 0)
BEGIN
    PRINT('Palavras na frase: 0')
    PRINT('')
END
ELSE
BEGIN
    IF(LEN(@frase) <> 0 AND @palavras = 0)
    BEGIN
        PRINT('Palavras na frase: 1')
        PRINT('')
    END
    ELSE
    BEGIN
        SET @palavras = @palavras + 1
        PRINT('Palavras na frase: ' + CAST(@palavras AS VARCHAR(10)))
        PRINT('')
    END
END