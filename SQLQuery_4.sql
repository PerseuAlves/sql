-- Locadora --------------------------------------------------------------

USE master
GO
DROP DATABASE locadora
GO
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
ano			INT				NULL		CHECK(ano <= 2021)
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

-- INSERT ----------------------------------------------------------------

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

-- UPDATE ----------------------------------------------------------------

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

-- DELETE ----------------------------------------------------------------

DELETE Filme 
WHERE titulo = 'Sing'
GO

-- SELECT ----------------------------------------------------------------

/*
	Fazer um select que retorne os nomes dos filmes de 2014
*/
SELECT titulo
FROM Filme
WHERE ano = 2014
GO

/*
	Fazer um select que retorne o id e o ano do filme Birdman
*/
SELECT ID, ano
FROM Filme
WHERE titulo = 'Birdman'
GO

/*
	Fazer um select que retorne o id e o ano do filme que chama ___plash
*/
SELECT ID, ano
FROM Filme
WHERE titulo LIKE '%plash'
GO

/*
	Fazer um select que retorne o id, o nome e o nome_real da estrela cujo nome começa com Steve
*/
SELECT ID, nome, nomeReal
FROM Estrela
WHERE nome LIKE 'Steve%'
GO

/*
	Fazer um select que retorne FilmeId e a data_fabricação em formato
	(DD/MM/YYYY) (apelidar de fab) dos filmes fabricados a partir de 01-01-2020 
*/
SELECT filmeID, CONVERT(CHAR(10), dataFabri , 103) AS fab
FROM DVD
WHERE dataFabri >= '2020-01-01'
GO

/*
	Fazer um select que retorne DVDnum, data_locacao, data_devolucao, valor e
	valor com multa de acréscimo de 2.00 da locação do cliente 5505  
*/
SELECT DVDnum, CONVERT(CHAR(10), dataLocacao , 103) AS dataLocacao, CONVERT(CHAR(10), dataDevolucao , 103) AS dataDevolucao, valor, CAST(valor + 2.00 AS DECIMAL(3,2)) AS valorComMulta
FROM Locacao
WHERE clienteNumCadastro = 5505
GO

/*
	Fazer um select que retorne Logradouro, num e CEP de Matilde Luz
*/
SELECT logradouro + ', ' + CAST(num AS VARCHAR(5)) + ', ' + CAST(cep AS VARCHAR(8)) AS Endereco
FROM Cliente
WHERE nome = 'Matilde Luz'
GO

/*
	Fazer um select que retorne Nome real de Michael Keaton
*/
SELECT nomeReal
FROM Estrela
WHERE nome = 'Michael Keaton'
GO

/*
	Fazer um select que retorne o num_cadastro, o nome e o endereço completo,
	concatenando (logradouro, numero e CEP), apelido end_comp,
	dos clientes cujo ID é maior ou igual 5503
*/
SELECT numCadastro, nome, logradouro + ', ' + CAST(num AS VARCHAR(5)) + ', ' + CAST(cep AS VARCHAR(8)) AS  EndComp
FROM Cliente
WHERE numCadastro >= 5503
GO

/*
	Fazer uma consulta que retorne ID, Ano, nome do Filme (Caso o nome do filme tenha 
	mais de 10 caracteres, para caber no campo da tela, mostrar os 10 primeiros 
	caracteres, seguidos de reticências ...) dos filmes cujos DVDs foram fabricados depois 
	de 01/01/2020
*/
SELECT ID,
	   ano AS Ano,
	   CASE
			WHEN LEN(titulo) > 10 THEN
				SUBSTRING(titulo, 1, 10) + '...'
			ELSE
				titulo
	   END AS Titulo
FROM Filme
WHERE ID IN
(
	SELECT filmeID
	FROM DVD
	WHERE dataFabri > CONVERT(DATE, '2020-01-01')
)
GO

/*
	Fazer uma consulta que retorne num, data_fabricacao, qtd_meses_desde_fabricacao 
	(Quantos meses desde que o dvd foi fabricado até hoje) do filme Interestelar
*/
SELECT numero AS Num,
	   dataFabri AS DataFabri,
	   DATEDIFF(MONTH, DataFabri, GETDATE()) AS DataDif
FROM DVD
WHERE filmeID IN
(
	SELECT ID
	FROM Filme
	WHERE titulo = 'Interestelar'
)
GO

/*
	Fazer uma consulta que retorne num_dvd, data_locacao, data_devolucao, 
	dias_alugado(Total de dias que o dvd ficou alugado) e valor das locações da cliente que 
	tem, no nome, o termo Rosa
*/
SELECT DVDnum AS DVD_num,
	   dataLocacao AS DataLocação,
	   dataDevolucao AS DataDevolucao,
	   DATEDIFF(DAY, dataLocacao, dataDevolucao) AS DiasAlugados,
	   valor AS Valor
FROM Locacao
WHERE clienteNumCadastro IN
(
	SELECT numCadastro
	FROM Cliente
	WHERE nome LIKE '%Rosa%'
)
GO

/*
	Nome, endereço_completo (logradouro e número concatenados), cep (formato 
	XXXXX-XXX) dos clientes que alugaram DVD de num 10002
*/
SELECT nome AS Nome,
	   logradouro + ', ' + CAST(num AS CHAR(6)) AS Endereço,
	   SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 5, 3) AS CEP
FROM Cliente
WHERE numCadastro IN
(
	SELECT clienteNumCadastro
	FROM Locacao
	WHERE DVDnum = '10002'
)
GO

/*
	Consultar num_cadastro do cliente, nome do cliente, data_locacao (Formato 
	dd/mm/aaaa), Qtd_dias_alugado (total de dias que o filme ficou alugado), titulo do 
	filme, ano do filme da locação do cliente cujo nome inicia com Matilde
*/
SELECT loc.clienteNumCadastro AS Numero_Cadastro_Do_Cliente,
	   cli.nome AS Nome,
	   CONVERT(CHAR(10), loc.dataLocacao, 103) AS Data_Locacao,
	   DATEDIFF(DAY, loc.dataLocacao, loc.dataDevolucao) AS DiasAlugados,
	   fil.titulo AS Titulo,
	   fil.ano AS Ano
FROM Cliente cli, Locacao loc, DVD dvd, Filme fil
WHERE cli.numCadastro = loc.clienteNumCadastro AND loc.DVDnum = dvd.numero AND fil.ID = dvd.filmeID
	AND cli.nome LIKE 'Matilde%'
ORDER BY cli.numCadastro
GO

/*
	Consultar nome da estrela, nome_real da estrela, título do filme dos filmes 
	cadastrados do ano de 2015
*/
SELECT est.nome AS Nome,
	   est.nomeReal AS NomeReal,
	   fil.titulo AS TituloFilme
FROM Estrela est, Filme_Estrela fst, Filme fil
WHERE est.ID = fst.estrelaID AND fil.ID = fst.filmeID
	AND fil.ano = '2015'
ORDER BY fil.titulo
GO

/*
	Consultar título do filme, data_fabricação do dvd (formato dd/mm/aaaa), caso a 
	diferença do ano do filme com o ano atual seja maior que 6, deve aparecer a diferença 
	do ano com o ano atual concatenado com a palavra anos (Exemplo: 7 anos), caso 
	contrário só a diferença (Exemplo: 4).
*/
SELECT fil.titulo AS Titulos,
	   CONVERT(CHAR(10), dvd.dataFabri, 113) AS DataFabri,
	   CASE 
		   WHEN (YEAR(GETDATE()) - fil.ano) > 6 THEN
			    CAST((YEAR(GETDATE()) - fil.ano) AS VARCHAR(3)) + ' Anos'
		   ELSE
				 CAST((YEAR(GETDATE()) - fil.ano) AS VARCHAR(3))
	   END AS DiferencaEntreDatas
FROM Filme fil, DVD dvd
WHERE fil.ID = dvd.filmeID
ORDER BY fil.ID
GO

/*
	Consultar, num_cadastro do cliente, nome do cliente, titulo do filme, data_fabricação 
	do dvd e o valor da locação, dos dvds que possuem a maior data de fabricação dentre todos os 
	cadastrados.
*/

--SQL2:
SELECT loc.clienteNumCadastro, Cli.nome, Fil.titulo, Dvd.dataFabri, Loc.valor
FROM Locacao loc INNER JOIN Cliente Cli
ON loc.clienteNumCadastro = Cli.numCadastro INNER JOIN DVD Dvd
ON loc.DVDnum = Dvd.numero INNER JOIN Filme Fil
ON Dvd.filmeID = Fil.ID
WHERE Dvd.numero IN
(
	SELECT Dvd.numero
	FROM DVD Dvd
	WHERE Dvd.dataFabri IN
	(
		SELECT MAX(Dvd.dataFabri)
		FROM DVD Dvd
		GROUP BY Dvd.filmeID
	)
)
GO

--SQL3:
SELECT loc.clienteNumCadastro, Cli.nome, Fil.titulo, Dvd.dataFabri, Loc.valor
FROM Locacao loc, Cliente Cli, DVD Dvd, Filme Fil
WHERE loc.clienteNumCadastro = Cli.numCadastro
	AND loc.DVDnum = Dvd.numero
	AND Dvd.filmeID = Fil.ID
	AND Dvd.numero IN
(
	SELECT Dvd.numero
	FROM DVD Dvd
	WHERE Dvd.dataFabri IN
	(
		SELECT MAX(Dvd.dataFabri)
		FROM DVD Dvd
		GROUP BY Dvd.filmeID
	)
)
GO

/*
	Consultar, num_cadastro do cliente, nome do cliente, data de locação 
	(Formato DD/MM/AAAA) e a quantidade de DVD´s alugados por cliente (Chamar essa 
	coluna de qtd), ordenar por data de locação
*/

--SQL2:
SELECT loc.clienteNumCadastro, Cli.nome, CONVERT(CHAR(10), loc.dataLocacao, 103) AS DataLocacao, COUNT(Loc.DVDnum) AS qtd
FROM Locacao loc INNER JOIN Cliente Cli
ON loc.clienteNumCadastro = Cli.numCadastro
WHERE Cli.num IN
(
	SELECT Cli.num
	FROM Cliente Cli
	GROUP BY Cli.num
)
GROUP BY loc.clienteNumCadastro, Cli.nome, loc.dataLocacao
ORDER BY loc.dataLocacao
GO

--SQL3:
SELECT loc.clienteNumCadastro, Cli.nome, CONVERT(CHAR(10), loc.dataLocacao, 103) AS DataLocacao, COUNT(Loc.DVDnum) AS qtd
FROM Locacao loc, Cliente Cli
WHERE loc.clienteNumCadastro = Cli.numCadastro
	AND Cli.num IN
(
	SELECT Cli.num
	FROM Cliente Cli
	GROUP BY Cli.num
)
GROUP BY loc.clienteNumCadastro, Cli.nome, loc.dataLocacao
ORDER BY loc.dataLocacao
GO

/*
	Consultar, num_cadastro do cliente, nome do cliente, data de locação 
	(Formato DD/MM/AAAA) e o valor total de todos os dvd´s alugados (Chamar essa 
	coluna de valor_total), por data de locação
*/

--SQL2:
SELECT loc.clienteNumCadastro, Cli.nome, CONVERT(CHAR(10), loc.dataLocacao, 103) AS DataLocacao, SUM(Loc.valor) AS valor_total
FROM Locacao loc INNER JOIN Cliente Cli
ON loc.clienteNumCadastro = Cli.numCadastro
WHERE Cli.num IN
(
	SELECT Cli.num
	FROM Cliente Cli
	GROUP BY Cli.num
)
GROUP BY loc.clienteNumCadastro, Cli.nome, loc.dataLocacao
ORDER BY loc.dataLocacao
GO


--SQL3:
SELECT loc.clienteNumCadastro, Cli.nome, CONVERT(CHAR(10), loc.dataLocacao, 103) AS DataLocacao, SUM(Loc.valor) AS valor_total
FROM Locacao loc, Cliente Cli
WHERE loc.clienteNumCadastro = Cli.numCadastro
	AND Cli.num IN
(
	SELECT Cli.num
	FROM Cliente Cli
	GROUP BY Cli.num
)
GROUP BY loc.clienteNumCadastro, Cli.nome, loc.dataLocacao
ORDER BY loc.dataLocacao
GO

/*
	Consultar, num_cadastro do cliente, nome do cliente, Endereço 
	concatenado de logradouro e numero como Endereco, data de locação (Formato 
	DD/MM/AAAA) dos clientes que alugaram mais de 2 filmes simultaneamente
*/

--SQL2:
SELECT Loc.clienteNumCadastro, Cli.nome, Cli.logradouro + ', ' + CAST(Cli.num AS VARCHAR(5)) AS Endereco, CONVERT(CHAR(10), Loc.dataLocacao, 103) AS DataLocacao
FROM Locacao Loc INNER JOIN Cliente Cli
ON Loc.clienteNumCadastro = Cli.numCadastro
WHERE Cli.num IN
(
	SELECT Cli.num
	FROM Cliente Cli
	WHERE Cli.numCadastro IN
	(
		SELECT clienteNumCadastro
		FROM Locacao Loc
		GROUP BY Loc.clienteNumCadastro
		HAVING COUNT(Loc.DVDnum) > 2
	)
)
GROUP BY Loc.clienteNumCadastro, Cli.nome, Loc.dataLocacao, Cli.logradouro, Cli.num
ORDER BY Loc.dataLocacao
GO

--SQL3:
SELECT Loc.clienteNumCadastro, Cli.nome, Cli.logradouro + ', ' + CAST(Cli.num AS VARCHAR(5)) AS Endereco, CONVERT(CHAR(10), Loc.dataLocacao, 103) AS DataLocacao
FROM Locacao Loc, Cliente Cli
	WHERE Loc.clienteNumCadastro = Cli.numCadastro
	AND Cli.num IN
(
	SELECT Cli.num
	FROM Cliente Cli
	WHERE Cli.numCadastro IN
	(
		SELECT clienteNumCadastro
		FROM Locacao Loc
		GROUP BY Loc.clienteNumCadastro
		HAVING COUNT(Loc.DVDnum) > 2
	)
)
GROUP BY Loc.clienteNumCadastro, Cli.nome, Loc.dataLocacao, Cli.logradouro, Cli.num
ORDER BY Loc.dataLocacao
GO

-- Gerenciador -----------------------------------------------------------

USE master
GO
DROP DATABASE gerenciador
GO
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

-- INSERT ----------------------------------------------------------------

INSERT INTO Users (nome, apelido, senha, email) VALUES
('Maria', 'Rh_maria', '123mudar', 'maria@empresa.com'),
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
('Ana', 'Rh_ana', '123mudar', 'ana@empresa.com'),
('Clara', 'Ti_clara', '123mudar', 'clara@empresa.com'),
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com'),
('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')
GO
INSERT INTO Projects (nome, descricao, dataP) VALUES
('Re-folha', 'Refatoração das Folhas', '2014/09/05'),
('Manutenção PC´s', 'Manutenção PC´s', '2014/09/06'),
('Auditoria', NULL, '2014/09/07'),
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '12/09/2014')
GO
INSERT INTO UsersHasProjects VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)
GO

-- UPDATE ----------------------------------------------------------------

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

-- DELETE ----------------------------------------------------------------

DELETE UsersHasProjects
WHERE usersID = 2 AND projectsID = 10002
GO

-- SELECT ----------------------------------------------------------------

/*
	Fazer uma consulta que retorne id, nome, email, username e caso a senha seja diferente de 
	123mudar, mostrar ******** (8 asteriscos), caso contrário, mostrar a própria senha
*/
SELECT ID,
	   nome AS Nome,
	   email AS Email,
	   apelido AS Username,
	   CASE
		   WHEN senha != '123mudar' THEN
			   '********'
		   ELSE
			   senha
	   END AS Senha
FROM Users
GO

/*
	Considerando que o projeto 10001 durou 15 dias, fazer uma consulta que mostre o nome do 
	projeto, descrição, data, data_final do projeto realizado por usuário de e-mail 
	aparecido@empresa.com
*/
SELECT nome AS Nome,
	   descricao AS Descrição,
	   dataP AS DataP,
	   DATEADD(DAY, 15, dataP) AS DataFinal,
	   (
			SELECT nome
			FROM Users
			WHERE email = 'aparecido@empresa.com'
	   ) AS Último_Acesso_Feito_Por
FROM Projects
WHERE ID = '10001'
GO

/*
	Fazer uma consulta que retorne o nome e o email dos usuários que estão envolvidos no 
	projeto de nome Auditoria
*/
SELECT nome AS Nome,
	   email AS Email
FROM Users
WHERE ID IN
(
	SELECT usersID
	FROM UsersHasProjects
	WHERE projectsID IN
	(
		SELECT ID
		FROM Projects
		WHERE nome = 'Auditoria'
	)
)
SELECT * FROM UsersHasProjects
GO

/*
	Considerando que o custo diário do projeto, cujo nome tem o termo Manutenção, é de 79.85 
	e ele deve finalizar 16/09/2014, consultar, nome, descrição, data, data_final e custo_total do 
	projeto
*/
SELECT nome AS Nome,
	   descricao AS Descrição,
	   CONVERT(CHAR(10), dataP, 103) AS DataP,
	   CONVERT(CHAR(10), DATEADD(DAY, 10, dataP), 103) AS DataFinal,
	   10 * 79.85 AS CustoTotal
FROM Projects
WHERE nome LIKE '%Manutenção%'
GO

/*
	Consultar Id, Name e Email de Users, Id, Name, Description e Data de Projects, dos usuários que
	participaram do projeto Name Re-folha
*/

-- SQL2
SELECT usr.ID AS ID,
	   usr.nome AS Names,
	   usr.email AS Email,
	   prj.ID AS ID,
	   prj.nome AS Names,
	   prj.descricao AS Descricao,
	   prj.dataP AS Data_Do_Projeto
FROM Users usr INNER JOIN UsersHasProjects uhp
ON usr.ID = uhp.usersID INNER JOIN Projects prj
ON prj.ID = uhp.projectsID
WHERE prj.nome = 'Re-folha'
ORDER BY usr.ID
GO

-- SQL3
SELECT usr.ID AS ID,
	   usr.nome AS Names,
	   usr.email AS Email,
	   prj.ID AS ID,
	   prj.nome AS Names,
	   prj.descricao AS Descricao,
	   prj.dataP AS Data_Do_Projeto
FROM Users usr, Projects prj, UsersHasProjects uhp
WHERE usr.ID = uhp.usersID AND prj.ID = uhp.projectsID
	AND prj.nome = 'Re-folha'
ORDER BY usr.ID
GO

/*
	Name dos Projects que não tem Users
*/

SELECT prj.nome
FROM Projects prj LEFT OUTER JOIN UsersHasProjects uhp
ON prj.ID = uhp.projectsID
WHERE uhp.usersID IS NULL
GO

/*
	Name dos Users que não tem Projects
*/
SELECT usr.nome
FROM Users usr LEFT OUTER JOIN UsersHasProjects uhp
ON usr.ID = uhp.usersID
WHERE uhp.projectsID IS NULL
GO

/*
	Quantos projetos não possuem usuários associados a ele. A coluna 
	deve se chamar "qty_projects_no_users"
*/
SELECT COUNT(prj.ID) AS qty_projects_no_users
FROM Projects prj LEFT OUTER JOIN UsersHasProjects uhp
ON prj.ID = uhp.projectsID
WHERE uhp.usersID IS NULL
GO

/*
	Id do projeto, nome do projeto, qty_users_project (quantidade de usuários por 
	projeto) em ordem alfabética crescente pelo nome do projeto
*/

--SQL2:
SELECT prj.ID, prj.nome, COUNT(usr.ID) AS qty_users_project
FROM Projects prj INNER JOIN UsersHasProjects uhp
ON uhp.projectsID = prj.ID INNER JOIN Users usr
ON uhp.usersID = usr.ID
GROUP BY prj.nome, prj.ID
ORDER BY prj.nome
GO

--SQL3:
SELECT prj.ID, prj.nome, COUNT(usr.ID) AS qty_users_project
FROM Projects prj, UsersHasProjects uhp, Users usr
WHERE prj.ID = uhp.projectsID
	AND usr.ID = uhp.usersID
GROUP BY prj.nome, prj.ID
ORDER BY prj.nome