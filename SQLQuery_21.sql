USE master
GO
CREATE DATABASE Ex_1
GO
USE Ex_1
GO
CREATE TABLE curso
(
    codigo_curso        INT             NOT NULL,
    nome                VARCHAR(70)     NOT NULL,
    sigla               VARCHAR(10)     NOT NULL
    PRIMARY KEY(codigo_curso)
)
GO
CREATE TABLE palestrante
(
    codigo_palestrante  INT             NOT NULL    IDENTITY(1,1),
    nome                VARCHAR(250)    NOT NULL,
    empresa             VARCHAR(100)    NOT NULL
    PRIMARY KEY(codigo_palestrante)
)
GO
CREATE TABLE aluno
(
    ra                  CHAR(7)         NOT NULL,
    nome                VARCHAR(250)    NOT NULL,
    codigo_curso        INT             NOT NULL
    FOREIGN KEY(codigo_curso) REFERENCES curso(codigo_curso),
    PRIMARY KEY(ra)
)
GO
CREATE TABLE palestra
(
    codigo_palestra     INT             NOT NULL    IDENTITY(1,1),
    titulo              VARCHAR(MAX)    NOT NULL,
    carga_horaria       INT             NULL,
    dataP               DATETIME        NOT NULL,
    codigo_palestrante  INT             NOT NULL
    FOREIGN KEY(codigo_palestrante) REFERENCES palestrante(codigo_palestrante),
    PRIMARY KEY(codigo_palestra)
)
GO
CREATE TABLE alunos_inscritos
(
    ra                  CHAR(7)         NOT NULL,
    codigo_palestra     INT             NOT NULL
    FOREIGN KEY(ra) REFERENCES aluno(ra),
    FOREIGN KEY(codigo_palestra) REFERENCES palestra(codigo_palestra),
    PRIMARY KEY(ra, codigo_palestra)
)
GO
CREATE TABLE nao_alunos
(
    rg                  VARCHAR(9)      NOT NULL,
    orgao_exp           CHAR(5)         NOT NULL,
    nome                VARCHAR(250)    NOT NULL
    PRIMARY KEY(rg, orgao_exp)
)
GO
CREATE TABLE nao_alunos_inscritos
(
    codigo_palestra     INT             NOT NULL,
    rg                  VARCHAR(9)      NOT NULL,
    orgao_exp           CHAR(5)         NOT NULL,
    FOREIGN KEY(codigo_palestra) REFERENCES palestra(codigo_palestra),
    FOREIGN KEY(rg, orgao_exp) REFERENCES nao_alunos(rg, orgao_exp),
    PRIMARY KEY(codigo_palestra, rg, orgao_exp)
)
GO
SELECT *
FROM curso
GO
SELECT *
FROM palestrante
GO
SELECT *
FROM aluno
GO
SELECT *
FROM palestra
GO
SELECT *
FROM alunos_inscritos
GO
SELECT *
FROM nao_alunos
GO
SELECT *
FROM nao_alunos_inscritos
GO

--Forma 1:

DROP VIEW v_presentes
GO
CREATE VIEW v_presentes
AS
    SELECT alun.ra AS Identificacao, alun.nome AS Nome, '' AS Complemento
    FROM alunos_inscritos alins, aluno alun
    WHERE alins.ra = alun.ra
    AND alins.codigo_palestra = 1
UNION
    SELECT nai.rg AS Identificacao, na.nome AS Nome, nai.orgao_exp AS Complemento
    FROM nao_alunos_inscritos nai, nao_alunos na
    WHERE nai.rg = na.rg
    AND nai.codigo_palestra = 1
GO
--SELECT * FROM v_presentes
GO
SELECT 
    CASE
        WHEN(LEN(vPre.Identificacao) = 9) THEN
            'RG: ' + vPre.Identificacao + ' - ' + vPre.Complemento
        ELSE
            'RA: ' + vPre.Identificacao
    END AS Identificacao,
    vPre.Nome, plt.titulo AS Titulo, pltt.nome AS Nome_Palestrante, plt.carga_horaria AS Carga_Horaria, plt.dataP AS Data
FROM v_presentes vPre, palestra plt, palestrante pltt
WHERE plt.codigo_palestrante = pltt.codigo_palestrante
AND plt.codigo_palestra = 1
ORDER BY vPre.Complemento
GO

--Forma 2:

DROP VIEW Lista_Presenca
Go
CREATE VIEW Lista_Presenca
AS
    SELECT a.ra AS Num_Documento, a.nome AS Nome_Pessoa, p.titulo, pa.nome, p.carga_horaria, p.dataP
    FROM aluno a, palestra p, palestrante pa, alunos_inscritos ains
    WHERE a.ra = ains.ra
    AND ains.codigo_palestra = p.codigo_palestra
    AND p.codigo_palestrante = pa.codigo_palestrante
UNION
    SELECT na.rg +na.orgao_exp AS Num_Documento, na.nome AS Nome_Pessoa, p.titulo, pa.nome, p.carga_horaria, p.dataP
    FROM nao_alunos na, nao_alunos_inscritos nai, palestra p , palestrante pa
    WHERE p.codigo_palestra = nai.codigo_palestra
    AND nai.orgao_exp = na.orgao_exp
    AND nai.rg = na.rg
    AND pa.codigo_palestrante = p.codigo_palestrante
GO
SELECT * FROM Lista_Presenca
ORDER BY Nome_Pessoa