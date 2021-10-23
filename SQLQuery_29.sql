USE master

GO

CREATE DATABASE cursores

GO

USE cursores

GO

CREATE TABLE cursos
(
    codigo              INT              NOT NULL       IDENTITY(1,1),
    nome                VARCHAR(150)     NOT NULL,
    duracao             INT              NOT NULL

    PRIMARY KEY(codigo)
)

GO

CREATE TABLE disciplinas
(
    codigo              INT              NOT NULL       IDENTITY(1,1),
    nome                VARCHAR(150)     NOT NULL,
    carga_horaria       INT              NOT NULL

    PRIMARY KEY(codigo)
)

GO

CREATE TABLE disciplinas_cursos
(
    codigo_d              INT              NOT NULL,
    codigo_c              INT              NOT NULL

    FOREIGN KEY(codigo_d) REFERENCES disciplinas (codigo),
    FOREIGN KEY(codigo_c) REFERENCES cursos (codigo),

    PRIMARY KEY(codigo_d, codigo_c)
)

GO

CREATE FUNCTION fn_visualizar_informacao_do_curso(@codigo INT)
RETURNS @tabela TABLE(
codigo_disciplina    		INT,
nome_disciplina             VARCHAR(100),
carga_horaria               INT,
nome_curso                  VARCHAR(100)
)
AS
BEGIN
	DECLARE @codigo_disciplina			INT,
			@nome_disciplina    		VARCHAR(50),
			@carga_horaria	            INT,
			@nome_curso	                VARCHAR(100)

	DECLARE cur CURSOR FOR
		SELECT dp.codigo, dp.nome, dp.carga_horaria, cr.nome
        FROM cursos cr, disciplinas dp, disciplinas_cursos dc
        WHERE dc.codigo_c = cr.codigo AND dc.codigo_d = dp.codigo
        AND cr.codigo = @codigo

	OPEN cur
	FETCH NEXT FROM cur INTO @codigo_disciplina, @nome_disciplina, @carga_horaria, @nome_curso
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @tabela VALUES
		(@codigo_disciplina, @nome_disciplina, @carga_horaria, @nome_curso)

		FETCH NEXT FROM cur INTO @codigo_disciplina, @nome_disciplina, @carga_horaria, @nome_curso
	END

	CLOSE cur
	DEALLOCATE cur

	RETURN
END

GO

SELECT * FROM fn_visualizar_informacao_do_curso(1)

GO

SELECT dp.codigo, dp.nome, dp.carga_horaria, cr.nome
FROM cursos cr, disciplinas dp, disciplinas_cursos dc
WHERE dc.codigo_c = cr.codigo AND dc.codigo_d = dp.codigo
AND cr.codigo = 1