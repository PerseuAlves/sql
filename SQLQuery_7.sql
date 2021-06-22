CREATE DATABASE exaula2
GO
USE exaula2
GO
CREATE TABLE fornecedor (
ID				INT				NOT NULL	PRIMARY KEY,
nome			VARCHAR(50)		NOT NULL,
logradouro		VARCHAR(100)	NOT NULL,
numero			INT				NOT NULL,
complemento		VARCHAR(30)		NOT NULL,
cidade			VARCHAR(70)		NOT NULL
)
GO
CREATE TABLE cliente (
cpf			CHAR(11)		NOT NULL		PRIMARY KEY,
nome		VARCHAR(50)		NOT NULL,	
telefone	VARCHAR(9)		NOT NULL,
)
GO
CREATE TABLE produto (
codigo		INT				NOT NULL	PRIMARY KEY,
descricao	VARCHAR(50)		NOT NULL,
fornecedor	INT				NOT NULL,
preco		DECIMAL(7,2)	NOT NULL
FOREIGN KEY (fornecedor) REFERENCES fornecedor(ID)
)
GO
CREATE TABLE venda (
codigo			INT				NOT NULL,
produto			INT				NOT NULL,
cliente			CHAR(11)		NOT NULL,
quantidade		INT				NOT NULL,
data			DATE			NOT NULL
PRIMARY KEY (codigo, produto, cliente, data)
FOREIGN KEY (produto) REFERENCES produto (codigo),
FOREIGN KEY (cliente) REFERENCES cliente (cpf)
)

--Quantos produtos não foram vendidos (nome da coluna qtd_prd_nao_vend)?

SELECT COUNT(prd.codigo) AS qtd_prd_nao_vend
FROM produto prd LEFT OUTER JOIN venda vnd
ON vnd.produto = prd.codigo
WHERE vnd.cliente IS NULL

--Descrição do produto, Nome do fornecedor, count() do produto nas vendas

SELECT prd.descricao, fnc.nome, COUNT(prd.codigo) AS qtd_prd_vend
FROM produto prd, fornecedor fnc, venda vnd
WHERE prd.fornecedor = fnc.ID AND vnd.produto = prd.codigo
GROUP BY prd.descricao, fnc.nome
																																				--FALTA
--Nome do cliente e Quantos produtos cada um comprou ordenado pela quantidade

SELECT cli.nome, COUNT(prd.codigo) AS qtd_prd_produtos_comprados
FROM cliente cli, produto prd, venda vnd
WHERE cli.cpf = vnd.cliente AND vnd.produto = prd.codigo
GROUP BY cli.nome
ORDER BY COUNT(prd.codigo)

--Descrição do produto e Quantidade de vendas do produto com menor valor do catálogo de produtos

SELECT prd.descricao, vnd.quantidade
FROM produto prd, venda vnd
WHERE prd.codigo = vnd.produto
AND prd.preco IN
(
	SELECT MIN(preco)
	FROM produto
)
GROUP BY prd.descricao, vnd.quantidade

--Nome do Fornecedor e Quantos produtos cada um fornece

SELECT fnc.nome, COUNT(prd.codigo) AS qtd_de_produtos
FROM fornecedor fnc, produto prd
WHERE prd.fornecedor = fnc.ID
GROUP BY fnc.nome

--Considerando que hoje é 20/10/2019, consultar, sem repetições, o código da compra, nome do cliente,
--telefone do cliente (Mascarado XXXX-XXXX ou XXXXX-XXXX) e quantos dias da data da compra

SELECT vnd.codigo, cli.nome,
	CASE
		WHEN LEN(cli.telefone) > 8 THEN
			SUBSTRING(cli.telefone, 1, 5) + '-' + SUBSTRING(cli.telefone, 6, 4)
		ELSE
			SUBSTRING(cli.telefone, 1, 4) + '-' + SUBSTRING(cli.telefone, 5, 4)
	END AS Telefone,
	DATEDIFF(DAY, vnd.data, '2019/10/20') AS dias_apos_a_compra
FROM cliente cli, venda vnd
WHERE vnd.cliente = cli.cpf
GROUP BY vnd.codigo, cli.nome, cli.telefone, vnd.data

--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do cliente e quantidade comprada dos clientes que compraram mais de 2 produtos

SELECT SUBSTRING(cli.cpf, 1, 3) + '.' + SUBSTRING(cli.cpf, 4, 3) + '.' + SUBSTRING(cli.cpf, 7, 3) + '-' + SUBSTRING(cli.cpf, 10, 2) AS CEP, cli.nome, COUNT(cli.cpf) AS qtd_de_clientes_que_compraram_mais_de_2_produtos
FROM cliente cli, venda vnd, produto prd
WHERE vnd.cliente = cli.cpf AND vnd.produto = prd.codigo
GROUP BY cli.cpf, cli.nome, vnd.quantidade
HAVING COUNT(vnd.quantidade) > 2

--Sem repetições, Código da venda, CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do Cliente e
--Soma do valor_total gasto(valor_total_gasto = preco do produto * quantidade de venda).Ordenar por nome do cliente

SELECT vnd.codigo, SUBSTRING(cli.cpf, 1, 3) + '.' + SUBSTRING(cli.cpf, 4, 3) + '.' + SUBSTRING(cli.cpf, 7, 3) + '-' + SUBSTRING(cli.cpf, 10, 2) AS CEP, cli.nome, SUM(prd.preco * vnd.quantidade) AS valor_total_gasto
FROM venda vnd, cliente cli, produto prd
WHERE vnd.cliente = cli.cpf AND vnd.produto = prd.codigo
GROUP BY vnd.codigo, cli.cpf, cli.nome
ORDER BY cli.nome

--Código da venda, data da venda em formato (DD/MM/AAAA) e uma coluna, chamada dia_semana, que escreva o dia da semana por extenso
--Exemplo: Caso dia da semana 1, escrever domingo. Caso 2, escrever segunda-feira, assim por diante, até caso dia 7, escrever sábado

SELECT DISTINCT vnd.codigo, CONVERT(CHAR(10), vnd.data, 103) AS Data,
	dia_semana = CASE (DATEPART(WEEKDAY, vnd.data))
		WHEN 1 THEN 'Domingo'
		WHEN 2 THEN 'Segunda-feira'
		WHEN 3 THEN 'Terça-feira'
		WHEN 4 THEN 'Quarta-feira'
		WHEN 5 THEN 'Quinta-feira'
		WHEN 6 THEN 'Sexta-feira'
		ELSE 'Sábado'
	END
FROM venda vnd