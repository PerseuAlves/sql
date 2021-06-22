CREATE DATABASE ativi9
GO
USE ativi9
GO
CREATE TABLE editora
(
	codigo		INT				NOT NULL,
	nome		VARCHAR(30)		NOT NULL,
	site		VARCHAR(30)		NULL
	PRIMARY KEY(codigo)
)
GO
CREATE TABLE autor
(
	codigo					INT				NOT NULL,
	nome					VARCHAR(30)		NOT NULL,
	breve_biografia			VARCHAR(80)		NOT NULL
	PRIMARY KEY(codigo)
)
GO
CREATE TABLE estoque
(
	codigo				INT				NOT NULL		UNIQUE,
	nome				VARCHAR(50)		NOT NULL,
	quantidade			INT				NOT NULL,
	valor				FLOAT			NOT NULL		CHECK(valor > 0),
	cod_editora			INT				NOT NULL,
	cod_autor			INT				NOT NULL
	PRIMARY KEY(codigo)
	FOREIGN KEY(cod_editora) REFERENCES editora(codigo),
	FOREIGN KEY(cod_autor) REFERENCES autor(codigo)
)
GO
CREATE TABLE compras
(
	codigo				INT				NOT NULL,
	cod_livro			INT				NOT NULL,
	qtd_comprada		INT				NOT NULL		CHECK(qtd_comprada > 0),
	valor				FLOAT			NOT NULL		CHECK(valor > 0),
	data_compra			DATE			NOT NULL
	PRIMARY KEY(codigo, cod_livro)
	FOREIGN KEY(cod_livro) REFERENCES estoque(codigo)
)

-- Consultar nome, valor unitário, nome da editora e nome do autor dos livros do estoque que foram vendidos.
-- Não podem haver repetições.
SELECT est.nome, est.valor, edt.nome, aut.nome
FROM editora edt, autor aut, estoque est, compras cmp
WHERE cmp.cod_livro = est.codigo AND est.cod_autor = aut.codigo AND est.cod_editora = edt.codigo
AND cmp.codigo IS NOT NULL
GROUP BY est.nome, est.valor, edt.nome, aut.nome

-- Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
SELECT est.nome, cmp.qtd_comprada, cmp.valor
FROM estoque est, compras cmp
WHERE cmp.cod_livro = est.codigo
AND cmp.codigo = 15051

-- Consultar Nome do livro e site da editora dos livros da Makron books
-- (Caso o site tenha mais de 10 dígitos, remover o www.).
SELECT est.nome, 
	CASE
		WHEN LEN(edt.site) > 10 THEN
			SUBSTRING(edt.site, 5, LEN(edt.site))
		ELSE
			edt.site
	END AS Site
FROM estoque est, editora edt
WHERE est.cod_editora = edt.codigo
AND edt.nome = 'Makron books'

-- Consultar nome do livro e Breve Biografia do David Halliday
SELECT est.nome, aut.breve_biografia
FROM estoque est, autor aut
WHERE est.cod_autor = aut.codigo
AND aut.nome = 'David Halliday'

-- Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos
SELECT est.codigo, cmp.qtd_comprada
FROM estoque est, compras cmp
WHERE cmp.cod_livro = est.codigo
AND	est.nome = 'Sistemas Operacionais Modernos'

-- Consultar quais livros não foram vendidos
SELECT *
FROM estoque est LEFT OUTER JOIN compras cmp
ON cmp.cod_livro = est.codigo
WHERE cmp.codigo IS NULL

-- Consultar quais livros foram vendidos e não estão cadastrados
SELECT *
FROM estoque est LEFT OUTER JOIN compras cmp
ON cmp.cod_livro = est.codigo
WHERE cmp.codigo IS NOT NULL AND est.codigo IS NULL

-- Consultar Nome e site da editora que não tem Livros no estoque
-- (Caso o site tenha mais de 10 dígitos, remover o www.)
SELECT est.nome, 
	CASE
		WHEN LEN(edt.site) > 10 THEN
			SUBSTRING(edt.site, 5, LEN(edt.site))
		ELSE
			edt.site
	END AS Site
FROM estoque est, editora edt
WHERE est.cod_editora = edt.codigo
AND est.codigo IN
(
	SELECT codigo
	FROM estoque
	WHERE estoque.quantidade <= 0
)

-- Consultar Nome e biografia do autor que não tem Livros no estoque
-- (Caso a biografia inicie com Doutorado, substituir por Ph.D.)
SELECT aut.nome,
	CASE
		WHEN SUBSTRING(aut.breve_biografia, 1, 9) LIKE 'Doutorado' THEN
			'Ph.D.' + SUBSTRING(aut.breve_biografia, 10, LEN(aut.breve_biografia))
		ELSE
			aut.breve_biografia
	END AS Biografia
FROM autor aut, estoque est
WHERE est.codigo IN
(
	SELECT estoque.codigo
	FROM estoque
	WHERE estoque.quantidade <= 0
)

-- Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente
SELECT aut.nome, est.valor
FROM autor aut, estoque est
WHERE est.cod_autor = aut.codigo
AND est.valor IN
(
	SELECT MAX(est.valor)
	FROM estoque est, autor aut
	WHERE est.cod_autor = aut.codigo
	GROUP BY aut.nome
)
ORDER BY valor DESC

-- Consultar o código da compra, o total de livros comprados e a soma dos valores gastos.
-- Ordenar por Código da Compra ascendente.
SELECT cmp.codigo, SUM(cmp.qtd_comprada) AS qtd_comprada, SUBSTRING(CAST(SUM(cmp.valor) AS VARCHAR(5)), 1, 3) + ',' +  SUBSTRING(CAST(SUM(cmp.valor) AS VARCHAR(5)), 4, 2) AS valor
FROM compras cmp
GROUP BY cmp.codigo
ORDER BY cmp.codigo ASC

-- Consultar o nome da editora e a média de preços dos livros em estoque.
-- Ordenar pela Média de Valores ascendente.
SELECT edt.nome, (SUM(est.valor)/COUNT(est.codigo)) AS media
FROM editora edt, estoque est
WHERE edt.codigo = est.cod_editora
GROUP BY edt.nome
ORDER BY media ASC

-- Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora
-- (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:
--		Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
--		Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
--		Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
--		A Ordenação deve ser por Quantidade ascendente
SELECT est.nome, est.quantidade, edt.nome,
	CASE
		WHEN LEN(edt.site) > 10 THEN
			SUBSTRING(edt.site, 5, LEN(edt.site))
		ELSE
			edt.site
	END AS site,
	status = CASE est.quantidade
		WHEN 1 THEN 'Produto em Ponto de Pedido'
		WHEN 2 THEN 'Produto em Ponto de Pedido'
		WHEN 3 THEN 'Produto em Ponto de Pedido'
		WHEN 4 THEN 'Produto em Ponto de Pedido'
		WHEN 5 THEN 'Produto Acabando'
		WHEN 6 THEN 'Produto Acabando'
		WHEN 7 THEN 'Produto Acabando'
		WHEN 8 THEN 'Produto Acabando'
		WHEN 9 THEN 'Produto Acabando'
		WHEN 10 THEN 'Produto Acabando'
		ELSE 'Estoque Suficiente'
	END
FROM editora edt, estoque est
WHERE est.cod_editora = edt.codigo
ORDER BY est.quantidade ASC

-- Para montar um relatório, é necessário montar uma consulta com a seguinte saída:
-- Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros
--		Só pode concatenar sites que não são nulos
SELECT est.codigo, est.nome, aut.nome,
	CASE
		WHEN edt.site = '' THEN
			edt.nome
		ELSE
			edt.nome + ', site: ' + edt.site
	END AS info_editora
FROM estoque est, editora edt, autor aut

-- Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje
SELECT cmp.codigo, DATEDIFF(DAY, cmp.data_compra, GETDATE()) AS dias_da_compra_até_hoje, DATEDIFF(MONTH, cmp.data_compra, GETDATE()) AS meses_da_compra_até_hoje
FROM compras cmp

-- Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00
SELECT cmp.codigo,
	CASE
		WHEN SUM(cmp.valor) > 200 THEN
			SUM(cmp.valor)
	END AS valor_total
FROM compras cmp, estoque est
WHERE cmp.cod_livro = est.codigo
GROUP BY cmp.codigo