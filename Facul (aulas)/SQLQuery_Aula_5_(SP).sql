/*STORED PROCEDURES - Procedimentos Armazenados

Entrada de n parâmetros
Saída escalar de n parâmetros
Aceitam DDL
Aceitam DML
Aceitam Raise Error
Aceitam Chamadas de Stored Procedures
Permitem fazer tratamento de regras de negócio diretamente no BD

Criar procedure:

CREATE PROCEDURE sp_nome (variáveis de entrada - com tipo)
AS
.
.
.

Chamar Procedure (CALL)
SQL Server	- EXEC sp_nome param
Oracle		- EXECUTE sp_nome param
MySQL		- CALL sp_nome param
*/
/* EXEMPLO:
Um sistema necessita que o usuário cadastre,obrigatoriamente, 
um telefone celular e um telefone fixo.
O sistema funciona em São Paulo e não cadastrará pessoas de outros 
estados da federação.
A pessoa pode não ter um dos dois telefones, mas não é permitido 
omitir os 2 telefones, bem como cadastrar 2 fixos ou 2 celulares
*/
CREATE DATABASE AulaProc
GO
USE AulaProc

CREATE TABLE pessoa (
id			INT				NOT NULL,
nome		VARCHAR(100)	NOT NULL,
tel_fixo	CHAR(10)		NULL,
tel_cel		CHAR(11)		NULL
PRIMARY KEY(id)
)

CREATE PROCEDURE sp_pessoa_valida_tels_null(@tel_fixo CHAR(11), 
	@tel_cel CHAR(11), @valido BIT OUTPUT)
AS
	IF (@tel_fixo IS NULL AND @tel_cel IS NULL)
	BEGIN
		SET @valido = 0
	END
	ELSE
	BEGIN
		SET @valido = 1
	END

DECLARE @v1 BIT
EXEC sp_pessoa_valida_tels_null NULL, NULL, @v1 OUTPUT
PRINT @v1

CREATE PROCEDURE sp_pessoa_valida_dois_tels(@tel_fixo CHAR(11), 
	@tel_cel CHAR(11), @valido BIT OUTPUT)
AS
	DECLARE @tamanho_fixo INT,
			@tamanho_cel  INT
	SET @tamanho_fixo = LEN(@tel_fixo)
	SET @tamanho_cel  = LEN(@tel_cel)
	IF (@tamanho_fixo = @tamanho_cel)
	BEGIN
		SET @valido = 0
	END
	ELSE
	BEGIN
		SET @valido = 1
	END

DECLARE @v2 BIT
EXEC sp_pessoa_valida_dois_tels '1122222222', '1122222222', 
	@v2 OUTPUT
PRINT @v2

CREATE
ALTER PROCEDURE sp_pessoa_valida_tamanho_tels(@tel_fixo CHAR(11), 
	@tel_cel CHAR(11), @valido BIT OUTPUT)
AS
	DECLARE @tamanho_fixo INT,
			@tamanho_cel  INT
	SET @tamanho_fixo = LEN(@tel_fixo)
	SET @tamanho_cel  = LEN(@tel_cel)
	IF (@tamanho_fixo < 10 OR @tamanho_cel < 11)
	BEGIN
		SET @valido = 0
	END
	ELSE
	BEGIN
		SET @valido = 1
	END

DECLARE @v3 BIT
EXEC sp_pessoa_valida_tamanho_tels '1122222222', '1192222222', 
	@v3 OUTPUT
PRINT @v3

--Op = D (Delete) ; Op = U (Update) ; Op = I (Insert)
CREATE PROCEDURE sp_pessoa (@op CHAR(1), @id INT, 
	@nome VARCHAR(100), @tel_fixo CHAR(11), @tel_cel CHAR(11), 
	@saida VARCHAR(200) OUTPUT)
AS
	DECLARE @valido_null	BIT,
			@valido_iguais	BIT,
			@valido_tam		BIT,
			@cont			INT,
			@novo_id		INT

	IF (UPPER(@op)='D' AND @id IS NOT NULL)
	BEGIN
		DELETE pessoa WHERE id = @id
		SET @saida = 'Pessoa ID = '+CAST(@id AS VARCHAR(5))+
			' excluída'
	END
	ELSE
	BEGIN
		IF (UPPER(@op)='D' AND @id IS NULL)
		BEGIN
			RAISERROR('ID não pode ser nulo', 16, 1)
		END
		ELSE
		BEGIN
			EXEC sp_pessoa_valida_tels_null @tel_fixo, @tel_cel, 
				@valido_null OUTPUT
			PRINT @valido_null
			EXEC sp_pessoa_valida_dois_tels @tel_fixo, @tel_cel, 
				@valido_iguais OUTPUT
			PRINT @valido_iguais
			EXEC sp_pessoa_valida_tamanho_tels @tel_fixo, @tel_cel, 
				@valido_tam OUTPUT
			PRINT @valido_tam

			IF (@valido_null = 0 OR @valido_iguais = 0 OR @valido_tam = 0)
			BEGIN
				RAISERROR('Telefones inválidos (Iguais, nulos ou incorretos)', 16, 1)
			END
			ELSE 
				IF (UPPER(@op) = 'I')
				BEGIN
					SET @cont = (SELECT COUNT(id) FROM pessoa)
					IF (@cont = 0)
					BEGIN
						SET @novo_id = 1
					END
					ELSE
					BEGIN
						SELECT @novo_id = MAX(id) + 1 FROM pessoa
					END
			
					INSERT INTO pessoa VALUES
					(@novo_id, @nome, @tel_fixo, @tel_cel)

					SET @saida = 'Pessoa cadastrada'
				END
				ELSE
				BEGIN
					IF (UPPER(@op) = 'U')
					BEGIN
						UPDATE pessoa
						SET nome = @nome, tel_fixo = @tel_fixo,
							tel_cel = @tel_cel
						WHERE id = @id

						SET @saida = 'Pessoa ID = ' +
							CAST(@id AS VARCHAR(5)) + ' atualizada'
					END
					ELSE
					BEGIN
						RAISERROR('Operação Inválida', 16, 1)
					END
				END
			END
		END
    END

DELETE pessoa
SELECT * FROM pessoa

DECLARE @out VARCHAR(200)
EXEC sp_pessoa 'I', NULL, 'Fulano', '1122222222', '922222222', 
	@out OUTPUT
PRINT @out

DECLARE @out VARCHAR(200)
EXEC sp_pessoa 'I', NULL, 'Fulano', '1122222222', '1122222222', 
	@out OUTPUT
PRINT @out

DECLARE @out VARCHAR(200)
EXEC sp_pessoa 'I', NULL, 'Fulano', NULL, NULL, 
	@out OUTPUT
PRINT @out

DECLARE @out VARCHAR(200)
EXEC sp_pessoa 'I', NULL, 'Fulano', '1122222222', '11922222222', 
	@out OUTPUT
PRINT @out

DECLARE @out VARCHAR(200)
EXEC sp_pessoa 'I', NULL, 'Beltrano', '1122222222', '11922222222', 
	@out OUTPUT
PRINT @out

DECLARE @out VARCHAR(200)
EXEC sp_pessoa 'U', 1, 'Fulano', '1122222222', '1122222222', 
	@out OUTPUT
PRINT @out

DECLARE @out VARCHAR(200)
EXEC sp_pessoa 'U', 1, 'Fulano', '1122222222', '11932222222', 
	@out OUTPUT
PRINT @out

DECLARE @out VARCHAR(200)
EXEC sp_pessoa 'D', 2, NULL, NULL, NULL, @out OUTPUT
PRINT @out