CREATE DATABASE Exercicio_1
GO
USE Exercicio_1
GO
CREATE TABLE aluno(
    ra INT					NOT NULL,
    nome VARCHAR(20)		NOT NULL,
    sobrenome VARCHAR(20)	NOT NULL,
    rua VARCHAR(30)			NOT NULL,
    num VARCHAR(4)			NOT NULL,
    bairro VARCHAR(30)		NOT NULL,
    CEP CHAR(9)				NOT NULL,
    telefone CHAR(8)
    PRIMARY KEY(ra)
)
GO
CREATE TABLE cursos(
    codigo INT				NOT NULL,
    nome VARCHAR(20)		NOT NULL,
    carga_horaria INT		NOT NULL,
    turno VARCHAR(10),
    PRIMARY KEY(codigo)
)
GO
CREATE TABLE disciplinas(
    codigo INT				NOT NULL,
    nome VARCHAR(30)		NOT NULL,
    carga_horaria INT		NOT NULL,
    turno VARCHAR(10)		NOT NULL,
    semestre INT			NOT NULL
    PRIMARY KEY(codigo)
)

--1)
SELECT al.nome + ' ' + al.sobrenome AS nome_completo
FROM aluno al

--2)
SELECT al.rua + ' ' + al.bairro + ' ' + al.cep AS endereco
FROM aluno al
WHERE al.telefone IS NULL

--3)
SELECT telefone
FROM aluno
WHERE ra = 12348

--4)
SELECT nome, turno
FROM cursos
WHERE carga_horaria = 2800

--5)
SELECT semestre
FROM disciplinas
WHERE nome LIKE 'Banco de Dados I'
