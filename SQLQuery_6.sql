USE master
GO
DROP DATABASE Livraria2
GO
CREATE DATABASE Livraria2
GO
USE Livraria2
GO

CREATE TABLE clientes
(
	cod			INT				NOT NULL,
	nome		VARCHAR(80)		NOT NULL,
	logradouro	VARCHAR(100)	NULL,
	numero		INT				NULL,
	telefone	CHAR(9)			NULL
	PRIMARY KEY(cod)
)
GO

CREATE TABLE corredor
(
	cod			INT				NOT NULL,
	tipo		VARCHAR(50)		NOT NULL
	PRIMARY KEY(cod)
)
GO

CREATE TABLE autores
(
	cod			INT				NOT NULL,
	nome		VARCHAR(70)		NOT NULL,
	pais		VARCHAR(15)		NOT NULL,
	biografia	VARCHAR(200)	NOT NULL
	PRIMARY KEY(cod)
)
GO

CREATE TABLE livros
(
	cod				INT				NOT NULL,
	cod_autor		INT				NOT NULL,
	cod_corredor	INT				NOT NULL,
	nome			VARCHAR(50)		NOT NULL,
	pag				INT				NOT NULL,
	idioma			VARCHAR(30)		NOT NULL
	PRIMARY KEY(cod)
	FOREIGN KEY(cod_autor) REFERENCES autores(cod),
	FOREIGN KEY(cod_corredor) REFERENCES corredor(cod)
)
GO

CREATE TABLE emprestimo
(
	cod_cli			INT				NOT NULL,
	dataEmprestimo	DATETIME		NOT NULL,
	cod_livro		INT				NOT NULL
	FOREIGN KEY(cod_cli) REFERENCES clientes(cod),
	FOREIGN KEY(cod_livro) REFERENCES livros(cod),
	PRIMARY KEY(dataEmprestimo, cod_cli, cod_livro)
)
GO
SELECT * FROM autores
GO
SELECT * FROM corredor
GO
SELECT * FROM clientes
GO
SELECT * FROM livros
GO
SELECT * FROM emprestimo

/*
	Fazer uma consulta que retorne o nome do cliente e a data do empréstimo formatada padrão BR (dd/mm/yyyy)
*/

SELECT DISTINCT cli.nome AS Nome, CONVERT(CHAR(10), emp.dataEmprestimo, 103) AS Data_Emprestimo
FROM emprestimo emp, clientes cli
WHERE emp.cod_cli = cli.cod
GO

/*
	Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos por Cada autor,
	ordenado pelo número de livros. Se o nome do autor tiver mais de 25 caracteres,
	mostrar só os 13 primeiros.
*/

SELECT
	CASE
		WHEN LEN(aut.nome) > 25 THEN
			SUBSTRING(aut.nome, 1, 13)
		ELSE
			aut.nome
	END AS Nome,
COUNT(liv.cod) AS Qtd_De_Livros_Escritos
FROM autores aut, livros liv
WHERE aut.cod = liv.cod_autor
GROUP BY aut.nome
ORDER BY COUNT(liv.cod)

/*
	Fazer uma consulta que retorne o nome e o país de origem do autor do livro com maior número de páginas cadastrados no sistema
*/

SELECT aut.nome AS Nome, aut.pais AS Pais, liv.pag
FROM autores aut, livros liv
WHERE aut.cod = liv.cod_autor
AND liv.pag IN
(
	SELECT MAX(pag)
	FROM livros
)
GROUP BY aut.nome, aut.pais, liv.pag
HAVING liv.pag = MAX(liv.pag)

/*
	Fazer uma consulta que retorne nome e endereço concatenado dos clientes que tem livros emprestados
*/

SELECT cli.nome AS Nome, cli.logradouro + ', ' + CONVERT(VARCHAR(5), cli.numero) AS endereço
FROM emprestimo emp LEFT OUTER JOIN clientes cli
ON emp.cod_cli = cli.cod
WHERE emp.cod_livro IS NOT NULL

/*
	Nome dos Clientes (sem repetir), concatenados como enderço_telefone: o logradouro, o numero e o telefone, dos clientes que Não pegaram livros.
	Se o logradouro e o número forem nulos e o telefone não for nulo, mostrar só o telefone.
	Se o telefone for nulo e o logradouro e o número não forem nulos, mostrar só logradouro e número.
	Se os três existirem, mostrar os três.
*/

SELECT cli.nome AS Nome,
	CASE 
		WHEN cli.logradouro IS NOT NULL AND cli.numero IS NOT NULL AND cli.telefone IS NOT NULL THEN
			cli.logradouro + ', ' + CONVERT(VARCHAR(5), cli.numero) + CONVERT(VARCHAR(11), cli.telefone)
		ELSE
			CASE 
				WHEN cli.logradouro IS NULL AND cli.numero IS NULL AND cli.telefone IS NOT NULL THEN
					cli.telefone
				ELSE
					CASE
						WHEN cli.logradouro IS NOT NULL AND cli.numero IS NOT NULL AND cli.telefone IS NULL THEN
							cli.logradouro + ', ' + CONVERT(VARCHAR(5), cli.numero)
					END
			END
	END AS Endereco
FROM emprestimo emp RIGHT OUTER JOIN clientes cli
ON emp.cod_cli = cli.cod
WHERE emp.cod_livro IS NULL

/*
	Fazer uma consulta que retorne quantos livros não foram emprestados
*/

SELECT COUNT(liv.cod) AS qtd_de_livros
FROM livros liv LEFT OUTER JOIN emprestimo emp
ON liv.cod = emp.cod_livro
WHERE emp.cod_cli IS NULL

/*
	Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos livros,
	ordenados por quantidade de livro
*/

SELECT aut.nome, cor.tipo, COUNT(liv.cod) AS qtd_de_livros
FROM autores aut, corredor cor, livros liv
WHERE liv.cod_autor = aut.cod AND liv.cod_corredor = cor.cod
GROUP BY aut.cod, aut.nome, cor.tipo
ORDER BY COUNT(liv.cod)

/*
	Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente,
	o nome do livro, o total de dias que cada um está com o livro e, uma coluna que,
	caso o número de dias seja superior a 4, apresente 'Atrasado', caso contrário, apresente 'No Prazo'
*/

SELECT cli.nome, liv.nome, DATEDIFF(DAY, emp.dataEmprestimo, '2012/05/18') AS dias_alugados,
	CASE 
		WHEN DATEDIFF(DAY, emp.dataEmprestimo, '2012/05/18') > 4 THEN
			'Atrasado'
		ELSE
			'No Prazo'
	END AS Situacao
FROM clientes cli, livros liv, emprestimo emp
WHERE emp.cod_cli = cli.cod AND emp.cod_livro = liv.cod

/*
	Fazer uma consulta que retorne cod de corredores, tipo de corredores e quantos livros tem em cada corredor
*/

SELECT cor.cod, cor.tipo, COUNT(liv.cod) AS qtd_de_livros
FROM corredor cor, livros liv
WHERE liv.cod_corredor = cor.cod
GROUP BY cor.cod, cor.tipo

/*
	Fazer uma consulta que retorne o Nome dos autores cuja quantidade de livros cadastrado é maior ou igual a 2.
*/

SELECT aut.nome
FROM autores aut, livros liv
WHERE aut.cod = liv.cod_autor
GROUP BY aut.nome
HAVING COUNT(liv.cod_autor) > 2

/*
	Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente,
	o nome do livro dos empréstimos que tem 7 dias ou mais
*/

SELECT cli.nome, liv.nome
FROM clientes cli, livros liv, emprestimo emp
WHERE emp.cod_cli = cli.cod AND emp.cod_livro = liv.cod
GROUP BY cli.nome, liv.nome, emp.dataEmprestimo
HAVING DATEDIFF(DAY,  emp.dataEmprestimo, '2012/05/18') >= 7