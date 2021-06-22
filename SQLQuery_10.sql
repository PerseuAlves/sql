CREATE DATABASE ativi10
GO
USE ativi10
GO
CREATE TABLE medicamentos
(
	 codigo						INT				NOT NULL,
	 nome						VARCHAR(50)		NOT NULL,
	 apresentacao				VARCHAR(40)		NOT NULL,
	 unidade_de_cadastro		VARCHAR(20)		NOT NULL,
	 preco_proposto				FLOAT			NOT NULL
	 PRIMARY KEY(codigo)
)
GO
CREATE TABLE cliente
(
	cpf				CHAR(11)		NOT NULL,
	nome			VARCHAR(40)		NOT NULL,
	rua				VARCHAR(40)		NOT NULL,
	n				INT				NOT NULL,
	bairro			VARCHAR(40)		NOT NULL,
	telefone		VARCHAR(11)		NOT NULL
	PRIMARY KEY(cpf)
)
GO
CREATE TABLE venda
(
	nota_fiscal				INT				NOT NULL,
	cpf_cliente				CHAR(11)		NOT NULL,
	codigo_medicamento		INT				NOT NULL,
	quantidade				INT				NOT NULL,
	valor_total				FLOAT			NOT NULL,
	data					DATE			NOT NULL
	FOREIGN KEY(cpf_cliente) REFERENCES cliente(cpf),
	FOREIGN KEY(codigo_medicamento) REFERENCES medicamentos(codigo),
	PRIMARY KEY(nota_fiscal, cpf_cliente, codigo_medicamento)
)

-- Nome, apresentação, unidade e valor unitário dos remédios que ainda não foram vendidos.
-- Caso a unidade de cadastro seja comprimido, mostrar Comp.
SELECT med.nome, med.apresentacao, 
	CASE
		WHEN RTRIM(LTRIM(med.unidade_de_cadastro)) = 'Comprimido' THEN
			'Comp'
		ELSE
			med.unidade_de_cadastro
	END AS unidade_de_cadastro,
	med.preco_proposto
FROM medicamentos med LEFT OUTER JOIN venda vnd
ON vnd.codigo_medicamento = med.codigo
WHERE vnd.codigo_medicamento IS NULL

-- Nome dos clientes que compraram Amiodarona
SELECT cli.nome
FROM cliente cli, venda vnd, medicamentos med
WHERE vnd.cpf_cliente = cli.cpf AND vnd.codigo_medicamento = med.codigo
AND vnd.codigo_medicamento IN
(
	SELECT med.codigo
	FROM medicamentos med
	WHERE RTRIM(LTRIM(med.nome)) = 'Amiodarona'
)

-- CPF do cliente, endereço concatenado, nome do medicamento (como nome de remédio), 
-- apresentação do remédio, unidade, preço proposto, quantidade vendida e
-- valor total dos remédios vendidos a Maria Zélia
SELECT cli.cpf, cli.bairro + ',' + cli.rua + ',' + CONVERT(VARCHAR(5), cli.n) AS endereco, med.nome AS nome_de_remédio, med.apresentacao, med.unidade_de_cadastro, med.preco_proposto, vnd.quantidade, vnd.valor_total
FROM cliente cli, medicamentos med, venda vnd
WHERE cli.nome = 'Maria Zélia'

-- Data de compra, convertida, de Carlos Campos
SELECT CONVERT(VARCHAR(10), vnd.data, 103) AS data_da_compra
FROM venda vnd, cliente cli
WHERE vnd.cpf_cliente = cli.cpf
AND cli.nome = RTRIM(LTRIM('Carlos Campos'))