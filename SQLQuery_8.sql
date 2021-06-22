CREATE DATABASE ativi8
GO
USE ativi8
GO
CREATE TABLE cliente
(
	codigo					INT				NOT NULL,
	nome					VARCHAR(80)		NOT NULL,
	endereço				VARCHAR(80)		NOT NULL,
	telefone				VARCHAR(11)		NOT NULL,
	telefone_comercial		VARCHAR(11)		NULL
	PRIMARY KEY(codigo)
)
GO
CREATE TABLE tipos_mercadorias
(
	codigo		INT				NOT NULL,
	nome		VARCHAR(30)		NOT NULL
	PRIMARY KEY(codigo)
)
GO
CREATE TABLE corredores
(
	codigo		INT				NOT NULL,
	tipo		INT				NULL,
	nome		VARCHAR(30)		NULL
	PRIMARY KEY(codigo)
	FOREIGN KEY(tipo) REFERENCES tipos_mercadorias(codigo)
)
GO
CREATE TABLE mercadoria
(
	codigo			INT				NOT NULL,
	nome			VARCHAR(30)		NOT NULL,
	corredor		INT				NOT NULL,
	tipo			INT				NOT NULL,
	valor			FLOAT			NOT NULL
	PRIMARY KEY(codigo)
	FOREIGN KEY(corredor) REFERENCES corredores(codigo),
	FOREIGN KEY(tipo) REFERENCES tipos_mercadorias(codigo),
)
GO
CREATE TABLE compra
(
	nota_fiscal			INT				NOT NULL,
	codigo_cliente		INT				NOT NULL,
	valor				FLOAT			NOT NULL
	PRIMARY KEY(nota_fiscal)
	FOREIGN KEY(codigo_cliente) REFERENCES cliente(codigo)
)

-- Valor da Compra de Luis Paulo
SELECT cmp.valor
FROM compra cmp, cliente cli
WHERE cmp.codigo_cliente = cli.codigo
AND cli.nome = 'Luis Paulo'

-- Valor da Compra de Marcos Henrique
SELECT cmp.valor
FROM compra cmp, cliente cli
WHERE cmp.codigo_cliente = cli.codigo
AND cli.nome = 'Marcos Henrique'

-- Endereço e telefone do comprador de Nota Fiscal = 4567
SELECT cli.endereço, cli.telefone
FROM compra cmp, cliente cli
WHERE cmp.codigo_cliente = cli.codigo
AND cmp.nota_fiscal = 4567

-- Valor da mercadoria cadastrada do tipo "Pães"
SELECT merc.valor
FROM mercadoria merc, tipos_mercadorias tip
WHERE merc.tipo = tip.codigo
AND tip.nome = 'Pães'

-- Nome do corredor onde está a Lasanha
SELECT cor.nome
FROM corredores cor, mercadoria merc
WHERE merc.corredor = cor.codigo
AND merc.nome = 'Lasanha'

-- Nome do corredor onde estão os clorados
SELECT cor.nome
FROM corredores cor, tipos_mercadorias tip
WHERE cor.tipo = tip.codigo
AND tip.nome = 'clorados'