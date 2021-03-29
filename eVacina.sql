CREATE DATABASE eVacina;

USE eVacina;

#Criar tabelas

CREATE TABLE ENDERECO(
	Cod_end INT PRIMARY KEY AUTO_INCREMENT,
	Rua VARCHAR(100) NOT NULL,
	Cep VARCHAR(8) NOT NULL,
	Numero VARCHAR(10) NOT NULL,
	Complemento VARCHAR(50)
);

CREATE TABLE CIDADAO(
	Cod_cid INT PRIMARY KEY AUTO_INCREMENT,
	Nome VARCHAR(70) NOT NULL,
	Sexo ENUM('F', 'M') NOT NULL,
	Idade INT NOT NULL,
	CPF VARCHAR(11) UNIQUE NOT NULL, #Utilizamos o unique, pois somente pode haver um cadastro de CPF e RG
	RG VARCHAR(9) UNIQUE NOT NULL,
	Cod_end INT #Será a chave estrangeira que vai fazer relação com a tabela endereço
);
	
CREATE TABLE PRODUTORA(
	Cod_prod INT PRIMARY KEY AUTO_INCREMENT,
	Nome_comercial VARCHAR(70) UNIQUE NOT NULL,#Razão Social da empresa
	Nome_fantasia VARCHAR(70) NOT NULL,#Nome popular da empresa
	CNPJ VARCHAR(14) UNIQUE NOT NULL,
	Cod_end INT #Chave estrangeira que faz relação com a tabela endereço
);

CREATE TABLE POSTO(
	Cod_posto INT PRIMARY KEY AUTO_INCREMENT,
	Nome VARCHAR(100) NOT NULL,
	Cod_end INT #Chave estrangeira que faz relação com a tabela endereço
);

CREATE TABLE FUNCIONARIO(
	Cod_func INT PRIMARY KEY AUTO_INCREMENT,
	Cargo VARCHAR(30) NOT NULL,
	Cod_posto INT NOT NULL, #Chave estrangeira que faz relação com a tabela posto
	Cod_cid INT NOT NULL #Chave estrangeira que faz relação com a tabela cidadao
);

CREATE TABLE LOTE(
	Cod_lote INT(11) PRIMARY KEY, #Não vai ser auto increment, pois vai ser um código de lote
	Data_estoque DATE,
	Cod_posto INT #Chave estrangeira que faz relação com a tabela posto
);

CREATE TABLE FRASCO(
	Cod_frasco VARCHAR(11) PRIMARY KEY, #Não vai ser auto increment, pois vai ser código de lote
	Doses_disponiveis SMALLINT, #Utiliza o smallint para diminuir espaço na memória, já que será um valor baixo
	Data_vencimento DATE NOT NULL,
	Cod_vac INT NOT NULL #Chave estrangeira que faz relação com a tabela Vacina
);

CREATE TABLE VACINA(
	Cod_vac INT PRIMARY KEY AUTO_INCREMENT,
	Nome VARCHAR(30) NOT NULL UNIQUE,
	Descricao VARCHAR(100) NOT NULL,
	Obrigatoria BOOLEAN DEFAULT false,
	Cod_prod INT NOT NULL
);

CREATE TABLE CONTATO(
	Cod_cont INT PRIMARY KEY AUTO_INCREMENT,
	Tipo ENUM('RES', 'COM', 'CEL'),
	Numero VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE CONTATO_CIDADAO(
	Cod_cont_cid INT PRIMARY KEY AUTO_INCREMENT,
	Cod_cid INT NOT NULL,
	Cod_cont INT NOT NULL
);

CREATE TABLE CONTATO_POSTO(
	Cod_cont_posto INT PRIMARY KEY AUTO_INCREMENT,
	Cod_posto INT NOT NULL,
	Cod_cont INT NOT NULL
);

CREATE TABLE CONTATO_PROD(
	Cod_cont_prod INT PRIMARY KEY AUTO_INCREMENT,
	Cod_prod INT NOT NULL,
	Cod_cont INT NOT NULL
);

CREATE TABLE VACINACAO(
	Cod_vcao INT PRIMARY KEY AUTO_INCREMENT,
	Data_aplicacao DATE NOT NULL,
	Cod_frasco INT NOT NULL, #Chave estrangeira que faz relação com a tabela Frasco
	Cod_posto INT NOT NULL, #Chave estrangeira que faz relação com a tabela Posto
	Cod_func INT NOT NULL, #Chave estrangeira que faz relação com a tabela Funcionario
	Cod_cid INT NOT NULL #Chave estrangeira que faz relação com a tabela Cidadão
);

#Vincular as chaves estrangeiras - Construção do nome da chave fk_TabelaComChave_TabelaDeReferencia
#Tabela Cidadao
ALTER TABLE CIDADAO ADD CONSTRAINT fk_Cidadao_Endereco FOREIGN KEY(Cod_end) REFERENCES ENDERECO(Cod_end);
#Tabela Produtora
ALTER TABLE PRODUTORA ADD CONSTRAINT fk_Produtora_Endereco FOREIGN KEY(Cod_end) REFERENCES ENDERECO(Cod_end);
#Tabela Posto
ALTER TABLE POSTO ADD CONSTRAINT fk_Posto_Endereco FOREIGN KEY(Cod_end) REFERENCES ENDERECO(Cod_end);
#Tabela Funcionario
ALTER TABLE FUNCIONARIO ADD CONSTRAINT fk_Funcionario_Posto FOREIGN KEY(Cod_posto) REFERENCES POSTO(Cod_posto);
ALTER TABLE FUNCIONARIO ADD CONSTRAINT fk_Funcionario_Cidadao FOREIGN KEY(Cod_cid) REFERENCES CIDADAO(Cod_cid);
#Tabela Lote
ALTER TABLE LOTE ADD CONSTRAINT fk_Lote_Posto FOREIGN KEY(Cod_posto) REFERENCES POSTO(Cod_posto);
#Tabela Frasco
ALTER TABLE FRASCO ADD CONSTRAINT fk_Frasco_Vacina FOREIGN KEY(Cod_vac) REFERENCES VACINA(Cod_vac);
#Tabela Contato_posto
ALTER TABLE CONTATO_POSTO ADD CONSTRAINT fk_Contato_Posto FOREIGN KEY(Cod_posto) REFERENCES POSTO(Cod_posto);
#Tabela Contato_prod
ALTER TABLE CONTATO_PROD ADD CONSTRAINT fk_Contato_Produtora FOREIGN KEY(Cod_prod) REFERENCES PRODUTORA(Cod_prod);
#Tabela Contato_cid
ALTER TABLE CONTATO_CIDADAO ADD CONSTRAINT fk_Contato_Cidadao FOREIGN KEY(Cod_cid) REFERENCES CIDADAO(Cod_cid);
#Tabela Vacina
ALTER TABLE VACINA ADD CONSTRAINT fk_Vacina_Produtora FOREIGN KEY(Cod_prod) REFERENCES PRODUTORA(Cod_prod);
#Tabela Vacinacao
ALTER TABLE VACINACAO ADD CONSTRAINT fk_Vacinacao_Frasco FOREIGN KEY(Cod_frasco) REFERENCES FRASCO(Cod_frasco);
ALTER TABLE VACINACAO ADD CONSTRAINT fk_Vacinacao_Posto FOREIGN KEY(Cod_posto) REFERENCES POSTO(Cod_posto);
ALTER TABLE VACINACAO ADD CONSTRAINT fk_Vacinacao_Funcionario FOREIGN KEY(Cod_func) REFERENCES FUNCIONARIO(Cod_func);
ALTER TABLE VACINACAO ADD CONSTRAINT fk_Vacinacao_Cidadao FOREIGN KEY(Cod_cid) REFERENCES CIDADAO(Cod_cid);