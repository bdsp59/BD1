CREATE DATABASE eVacina;

USE eVacina;

#Criar tabelas

CREATE TABLE ENDERECO(
	IdEnd INT PRIMARY KEY AUTO_INCREMENT,
	Rua VARCHAR(100) NOT NULL,
	Cep VARCHAR(10) NOT NULL,
	Numero VARCHAR(10) NOT NULL,
	Complemento VARCHAR(50)
);

CREATE TABLE CIDADAO(
	IdCidadao INT PRIMARY KEY AUTO_INCREMENT,
	Nome VARCHAR(70) NOT NULL,
	Sexo ENUM('F', 'M') NOT NULL,
	Idade INT NOT NULL,
	CPF VARCHAR(11) UNIQUE NOT NULL,#Utilizamos o UNIQUE, pois somente pode haver um cadastro de CPF e RG
	RG VARCHAR(9) UNIQUE NOT NULL,
	Id_Endereco INT #Será a chave estrangeira que vai fazer relação com a tabela endereço
);

CREATE TABLE PRODUTORA(
	IdProdutora INT PRIMARY KEY AUTO_INCREMENT,
	NomeComercial VARCHAR(70) UNIQUE NOT NULL,#Razão Social da empresa
	NomeFantasia VARCHAR(70) NOT NULL,#Nome popular da empresa
	CNPJ VARCHAR(14) UNIQUE NOT NULL,
	Id_Endereco INT #Chave estrangeira que faz relação com a tabela endereço
);

CREATE TABLE POSTO(
	IdPosto INT PRIMARY KEY AUTO_INCREMENT,
	Nome VARCHAR(100) NOT NULL,
	Id_Endereco INT #Chave estrangeira que faz relação com a tabela endereço
);

CREATE TABLE FUNCIONARIO(
	IdFuncionario INT PRIMARY KEY AUTO_INCREMENT,
	Cargo VARCHAR(30) NOT NULL,
	Id_Posto INT, #Chave estrangeira que faz relação com a tabela posto
	Id_Cidadao INT #Chave estrangeira que faz relação com a tabela cidadao
);

CREATE TABLE LOTE(
	IdLote INT(11) PRIMARY KEY, #Não vai ser auto increment, pois vai ser um código de lote
	Id_Posto INT #Chave estrangeira que faz relação com a tabela posto
);

CREATE TABLE FRASCO(
	IdFrasco INT PRIMARY KEY, #Não vai ser auto increment, pois vai ser código de lote
	DosesDisponiveis SMALLINT, #Utiliza o smallint para diminuir espaço na memória, já que será um valor baixo
	DataVencimento DATE NOT NULL,
	Id_Lote INT, #Chave estrangeira que faz relação com a tabela Lote
	Id_Vacina INT #Chave estrangeira que faz relação com a tabela Vacina
);

CREATE TABLE VACINA(
	IdVacina INT PRIMARY KEY AUTO_INCREMENT,
	Nome VARCHAR(30) NOT NULL UNIQUE,
	Descricao VARCHAR(100) NOT NULL,
	Obrigatoria ENUM('S', 'N')
);

CREATE TABLE CONTATO(
	IdContato INT PRIMARY KEY AUTO_INCREMENT,
	Tipo ENUM('RES', 'COM', 'CEL'),
	Numero VARCHAR(10) NOT NULL UNIQUE,
	Id_Posto INT, #Chave estrangeira que faz relação com a tabela Posto
	Id_Produtora INT, #Chave estrangeira que faz relação com a tabela Produtora
	Id_Cidadao INT #Chave estrangeria que faz relação com a tabela Cidadão
);

CREATE TABLE VACINA_PRODUTORA( #Essa tabela existe pelo simples fato de que uma produtora pode produzir nenhuma ou várias vacinas e ao mesmo tempo um tipo de vacina pode ser fabricada por mais de uma produtora
	IdVacinaProdutora INT PRIMARY KEY AUTO_INCREMENT,
	Id_Vacina INT, #Chave estrangeira que faz relação com a tabela Vacina
	Id_Produtora INT #Chave estrangeira que faz relação com a tabela Produtora
);

CREATE TABLE VACINACAO(
	IdVacinacao INT PRIMARY KEY AUTO_INCREMENT,
	DataAplicacao DATE NOT NULL,
	Id_Frasco INT, #Chave estrangeira que faz relação com a tabela Frasco
	Id_Posto INT, #Chave estrangeira que faz relação com a tabela Posto
	Id_Funcionario INT, #Chave estrangeira que faz relação com a tabela Funcionario
	Id_Cidadao INT #Chave estrangeira que faz relação com a tabela Cidadão
);

#Vincular as chaves estrangeiras - Construção do nome da chave fk_TabelaComChave_TabelaDeReferencia
#Tabela Cidadao
ALTER TABLE CIDADAO ADD CONSTRAINT fk_Cidadao_Endereco FOREIGN KEY(Id_Endereco) REFERENCES ENDERECO;
#Tabela Produtora
ALTER TABLE PRODUTORA ADD CONSTRAINT fk_Produtora_Endereco FOREIGN KEY(Id_Endereco) REFERENCES ENDERECO;
#Tabela Posto
ALTER TABLE POSTO ADD CONSTRAINT fk_Posto_Endereco FOREIGN KEY(Id_Endereco) REFERENCES ENDERECO;
#Tabela Funcionario
ALTER TABLE FUNCIONARIO CONSTRAINT fk_Funcionario_Posto FOREIGN KEY(Id_Posto) REFERENCES POSTO;
ALTER TABLE FUNCIONARIO CONSTRAINT fk_Funcionario_Cidadao FOREIGN KEY(Id_Cidadao) REFERENCES CIDADAO;
#Tabela Lote
ALTER TABLE LOTE CONSTRAINT fk_Lote_Posto FOREIGN KEY(Id_Posto) REFERENCES POSTO;
#Tabela Frasco
ALTER TABLE FRASCO CONSTRAINT fk_Frasco_Lote FOREIGN KEY(Id_Lote) REFERENCES LOTE;
ALTER TABLE FRASCO CONSTRAINT fk_Frasco_Vacina FOREIGN KEY(Id_Vacina) REFERENCES VACINA;
#Tabela Contato
ALTER TABLE CONTATO CONSTRAINT fk_Contato_Posto FOREIGN KEY(Id_Posto) REFERENCES POSTO;
ALTER TABLE CONTATO CONSTRAINT fk_Contato_Produtora FOREIGN KEY(Id_Produtora) REFERENCES PRODUTORA;
ALTER TABLE CONTATO CONSTRAINT fk_Contato_Cidadao FOREIGN KEY(Id_Cidadao) REFERENCES CIDADAO;
#Tabela Vacina_Produtora
ALTER TABLE VACINA_PRODUTORA CONSTRAINT fk_Vacina_Produtora_Vacina FOREIGN KEY(Id_Vacina) REFERENCES VACINA;
ALTER TABLE VACINA_PRODUTORA CONSTRAINT fk_Vacina_Produtora_Produtora FOREIGN KEY(Id_Produtora) REFERENCES PRODUTORA;
#Tabela Vacinacao
ALTER TABLE VACINACAO CONSTRAINT fk_Vacinacao_Frasco FOREIGN KEY(Id_Frasco) REFERENCES FRASCO;
ALTER TABLE VACINACAO CONSTRAINT fk_Vacinacao_Posto FOREIGN KEY(Id_Posto) REFERENCES POSTO;
ALTER TABLE VACINACAO CONSTRAINT fk_Vacinacao_Funcionario FOREIGN KEY(Id_Funcionario) REFERENCES FUNCIONARIO;
ALTER TABLE VACINACAO CONSTRAINT fk_Vacinacao_Cidadao FOREIGN KEY(Id_Cidadao) REFERENCES CIDADAO;

