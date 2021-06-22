--Criação de bancos de dados para fins de aprendizagem:

/*
USE master
DROP DATABASE livraria
DROP DATABASE locadora
DROP DATABASE gerenciador
*/

-- Livraria -----------------------------------------

CREATE DATABASE livraria
GO
USE livraria
GO
CREATE TABLE Autor (
codigoAutor		INT				NOT NULL,
nome			VARCHAR(80)		NULL		UNIQUE,
nascimento		DATE			NULL,
pais			VARCHAR(8)		NULL		CHECK(UPPER(pais) = 'BRASIL' OR UPPER(pais) = 'ALEMANHA'),
biografia		VARCHAR(2100)	NULL,
PRIMARY KEY(codigoAutor)
)
GO
CREATE TABLE Livro (
codigoLivro		INT				NOT NULL,
nome			VARCHAR(100)	NULL,
lingua			VARCHAR(5)		NULL		DEFAULT('PT-BR'),
ano				INT				NULL		CHECK(ano >= 1990)
PRIMARY KEY(codigoLivro)
)
GO
CREATE TABLE Livro_Autor (
autorID			INT				NOT NULL,
livroID			INT				NOT NULL
FOREIGN KEY(autorID) REFERENCES Autor(codigoAutor),
FOREIGN KEY(livroID) REFERENCES Livro(codigoLivro),
PRIMARY KEY(autorID, livroID)
)
GO
CREATE TABLE Edicao (
ISBN			INT				NOT NULL,
preco			DECIMAL(5,2)	NULL		CHECK(preco > 0),
ano				INT				NULL		CHECK(ano > 1993),
numPaginas		INT				NULL		CHECK(numPaginas > 0),
qtdEstoque		INT				NULL,
livroID			INT				NOT NULL
PRIMARY KEY(ISBN)
FOREIGN KEY(livroID) REFERENCES Livro(codigoLivro)
)
GO
CREATE TABLE Editora (
codigoEditora	INT				NOT NULL,
nome			VARCHAR(60)		NULL		UNIQUE,
logradouro		VARCHAR(200)	NULL,
numero			INT				NULL		CHECK(numero > 0),
cep				INT				NULL,
telefone		VARCHAR(15)		NULL
PRIMARY KEY(codigoEditora)
)
GO
CREATE TABLE Edicao_Editora (
ID				INT				NOT NULL,
editoraID		INT				NOT NULL
FOREIGN KEY(ID) REFERENCES Edicao(ISBN),
FOREIGN KEY(editoraID) REFERENCES Editora(codigoEditora),
PRIMARY KEY(ID, editoraID)
)
GO
INSERT INTO Autor VALUES
(1, 'João Almeida', '1995-07-14', 'BRASIL', NULL)
GO
INSERT INTO Livro VALUES
(1, 'Livro_1', NULL, 2015)
GO
INSERT INTO Livro_Autor VALUES
(1, 1)
GO
INSERT INTO Edicao VALUES
(0000000000001, 21.50, 2000, 320, 23, 1)
GO
INSERT INTO Editora VALUES
(1, 'JKDU', 'Rua Nascimento, Penha, SP', 36, 00000800, 0800-0000001)
GO
INSERT INTO Edicao_Editora VALUES
(1, 1)
GO
SELECT * FROM Autor
GO
SELECT * FROM Livro
GO
SELECT * FROM Livro_Autor
GO
SELECT * FROM Edicao
GO
SELECT * FROM Editora
GO
SELECT * FROM Edicao_Editora
GO

-- Locadora -----------------------------------------

CREATE DATABASE locadora
GO
USE locadora
GO
CREATE TABLE Estrela (
ID			INT				NOT NULL,		
nome		VARCHAR(50)		NOT NULL
PRIMARY KEY(ID)
)
GO
CREATE TABLE Filme (
ID			INT				NOT NULL,
titulo		VARCHAR(40)		NOT NULL,
ano			INT				NULL		CHECK(ano < 2021)
PRIMARY KEY(ID)
)
GO
CREATE TABLE Filme_Estrela (
filmeID		INT		NOT NULL,
estrelaID	INT		NOT NULL
FOREIGN KEY(filmeID) REFERENCES Filme(ID),
FOREIGN KEY(estrelaID) REFERENCES Estrela(ID),
PRIMARY KEY(filmeID, estrelaID)
)
GO
CREATE TABLE DVD (
numero		INT		NOT NULL,
dataFabri	DATE	NOT NULL	CHECK(dataFabri < GETDATE()),
filmeID		INT		NOT NULL
PRIMARY KEY(numero)
FOREIGN KEY(filmeID) REFERENCES Filme(ID)
)
GO
CREATE TABLE Cliente (
numCadastro		INT				NOT NULL,
nome			VARCHAR(70)		NOT NULL,
logradouro		VARCHAR(150)	NOT NULL,
num				INT				NOT NULL	CHECK(num > 0),
cep				CHAR(8)			NULL		DEFAULT('00000000')	CHECK(LEN(cep) = 8)
PRIMARY KEY(numCadastro)
)
GO
CREATE TABLE Locacao (
dataLocacao			DATE			NOT NULL	DEFAULT(GETDATE()),
dataDevolucao		DATE			NOT NULL	CHECK(dataDevolucao > '2021-02-18'),
valor				DECIMAL(7,2)	NOT NULL,	CHECK(valor > 0),
DVDnum				INT				NOT NULL,
clienteNumCadastro	INT				NOT NULL
FOREIGN KEY(DVDnum) REFERENCES DVD(numero),
FOREIGN KEY(clienteNumCadastro) REFERENCES Cliente(numCadastro),
PRIMARY KEY(dataLocacao, DVDnum, clienteNumCadastro)
)
GO
ALTER TABLE Estrela
ADD nomeReal			VARCHAR(50)		NOT NULL
GO
ALTER TABLE Filme
ALTER COLUMN titulo		VARCHAR(80)		NOT NULL
GO
INSERT INTO Estrela VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', ''),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')
GO
INSERT INTO Filme VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A Culpa é das estrelas', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
(1006, 'Sing', 2016)
GO
INSERT INTO Filme_Estrela VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)
GO
INSERT INTO DVD VALUES
(10001, '2020-12-02', 1001),
(10002, '2019-10-18', 1002),
(10003, '2020-04-03', 1003),
(10004, '2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007, '2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003)
GO
INSERT INTO Cliente VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')
GO
INSERT INTO Locacao VALUES
('2021-02-18', '2021-02-21', 3.50, 10001, 5502),
('2021-02-18', '2021-02-21', 3.50, 10009, 5502),
('2021-02-18', '2021-02-19', 3.50, 10002, 5503),
('2021-02-20', '2021-02-23', 3.00, 10002, 5505),
('2021-02-20', '2021-02-23', 3.00, 10004, 5505),
('2021-02-20', '2021-02-23', 3.00, 10005, 5505),
('2021-02-24', '2021-02-26', 3.50, 10001, 5501),
('2021-02-24', '2021-02-26', 3.50, 10008, 5501)
GO
UPDATE Cliente
SET cep = '08411150'
WHERE numCadastro = 5503
GO
UPDATE Cliente
SET cep = '02918190'
WHERE numCadastro = 5504
GO
UPDATE Locacao
SET valor = 3.25
WHERE clienteNumCadastro = 5502 AND dataLocacao = ' 2021-02-18'
GO
UPDATE Locacao
SET valor = 3.25
WHERE clienteNumCadastro = 5501 AND dataLocacao = '2021-02-24'
GO
UPDATE DVD
SET dataFabri = '2019-07-14'
WHERE numero = 10005
GO
UPDATE Estrela
SET nomeReal = 'Miles Alexander Teller'
WHERE ID = 9903
GO
DELETE Filme 
WHERE titulo = 'Sing'
GO
SELECT * FROM Estrela
GO
SELECT * FROM Filme
GO
SELECT * FROM Filme_Estrela
GO
SELECT * FROM DVD
GO
SELECT * FROM Cliente
GO
SELECT * FROM Locacao
GO

-- Gerenciador de projetos --------------------------

CREATE DATABASE gerenciador
GO
USE gerenciador
GO
CREATE TABLE Users (
ID			INT				NOT NULL		IDENTITY(1,1),
nome		VARCHAR(45)		NOT NULL		DEFAULT('123mudar'),
apelido		VARCHAR(10)		NOT NULL		UNIQUE,
senha		VARCHAR(8)		NOT NULL,
email		VARCHAR(45)		NOT NULL
PRIMARY KEY(ID)
)
GO
CREATE TABLE Projects (
ID			INT				NOT NULL		IDENTITY(10001,1),
nome		VARCHAR(45)		NOT NULL,		
descricao	VARCHAR(45)		NULL,		
dataP		date			NOT NULL		CHECK(dataP > '2014/09/01')
PRIMARY KEY(ID)
)
GO
CREATE TABLE UsersHasProjects (
usersID		INT				NOT NULL,
projectsID	INT				NOT NULL
FOREIGN KEY(usersID) REFERENCES Users(ID),
FOREIGN KEY(projectsID) REFERENCES Projects(ID),
PRIMARY KEY(usersID, projectsID)
)
GO
INSERT INTO Users (nome, apelido, senha, email) VALUES
('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')
GO
INSERT INTO Projects (nome, descricao, dataP) VALUES
('Re-folha', 'Refatoração das Folhas', '2014/09/05'),
('Manutenção PC´s', 'Manutenção PC´s', '2014/09/06'),
('Auditoria', NULL, '2014/09/07')
GO
INSERT INTO UsersHasProjects VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)
GO
UPDATE Projects
SET	dataP = '2014/09/12'
WHERE ID = 10001
GO
UPDATE Users
SET	apelido = 'Rh_cido'
WHERE apelido = 'Rh_apareci'
GO
UPDATE Users
SET	senha =	'888@*'
WHERE apelido = 'Rh_maria'
GO
DELETE UsersHasProjects
WHERE usersID = 2 AND projectsID = 10002
GO
SELECT * FROM Users
GO
SELECT * FROM Projects
GO
SELECT * FROM UsersHasProjects

-----------------------------------------------------