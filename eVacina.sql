CREATE DATABASE eVacina;

USE eVacina;

#Criar tabelas

CREATE TABLE ENDERECO(
	Cod_end INT PRIMARY KEY AUTO_INCREMENT,
	Rua VARCHAR(100) NOT NULL,
	Numero VARCHAR(10) NOT NULL,
	Complemento VARCHAR(50),
	Bairro VARCHAR(30) NOT NULL,
	Municipio VARCHAR(50) NOT NULL,
	Estado VARCHAR(2) NOT NULL,
	Cep VARCHAR(8) NOT NULL
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
	Obrigatoria BOOLEAN DEFAULT false
);

CREATE TABLE CONTATO(
	Cod_cont INT PRIMARY KEY AUTO_INCREMENT,
	Tipo ENUM('RES', 'COM', 'CEL'),
	Numero VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE CONTATO_CIDADAO(
	Cod_cid INT NOT NULL,
	Cod_cont INT NOT NULL
);

CREATE TABLE CONTATO_POSTO(
	Cod_posto INT NOT NULL,
	Cod_cont INT PRIMARY KEY
);

CREATE TABLE CONTATO_PROD(
	Cod_prod INT NOT NULL,
	Cod_cont INT PRIMARY KEY
);

CREATE TABLE VACINACAO(
	Cod_vcao INT PRIMARY KEY AUTO_INCREMENT,
	Data_aplicacao DATE NOT NULL,
	Cod_frasco VARCHAR(11) NOT NULL, #Chave estrangeira que faz relação com a tabela Frasco
	Cod_posto INT NOT NULL, #Chave estrangeira que faz relação com a tabela Posto
	Cod_func INT NOT NULL, #Chave estrangeira que faz relação com a tabela Funcionario
	Cod_cid INT NOT NULL #Chave estrangeira que faz relação com a tabela Cidadão
);

CREATE TABLE PRODUZ(
	Cod_vac INT NOT NULL,
	Cod_prod INT NOT NULL
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

#Tabela Contato_Cidadao
ALTER TABLE CONTATO_CIDADAO ADD CONSTRAINT fk_Contato_Cidadao_Cidadao FOREIGN KEY(Cod_cid) REFERENCES CIDADAO(Cod_cid);
ALTER TABLE CONTATO_CIDADAO ADD CONSTRAINT fk_Contato_Cidadao_Contato FOREIGN KEY(Cod_cont) REFERENCES CONTATO(Cod_cont);
#Tabela Contato_Posto
ALTER TABLE CONTATO_POSTO ADD CONSTRAINT fk_Contato_Posto_Posto FOREIGN KEY(Cod_posto) REFERENCES POSTO(Cod_posto);
ALTER TABLE CONTATO_POSTO ADD CONSTRAINT fk_Contato_Posto_Contato FOREIGN KEY(Cod_cont) REFERENCES CONTATO(Cod_cont);
#Tabela Contato_Prod
ALTER TABLE CONTATO_PROD ADD CONSTRAINT fk_Contato_Produtora_Produtora FOREIGN KEY(Cod_prod) REFERENCES PRODUTORA(Cod_prod);
ALTER TABLE CONTATO_PROD ADD CONSTRAINT fk_Contato_Produtora_Contato FOREIGN KEY(Cod_cont) REFERENCES CONTATO(Cod_cont);
#Criando dados para as tabelas
#Endereco -> (NULL, Rua, Numero, Complemento, Bairro, Municipio, Estado, CEP)
#Endereços Postos
INSERT INTO ENDERECO VALUES (NULL, "Rua Waldemar Dutra", "55", NULL, "Santo Cristo", "Rio de Janeiro", "RJ", "20220780");
INSERT INTO ENDERECO VALUES (NULL, "Avenida Henrique Valadares", "151", NULL, "Centro", "Rio de Janeiro", "RJ", "20231031");
INSERT INTO ENDERECO VALUES (NULL, "Avenida Doutor Abraão Ribeiro", "283", NULL, "Barra Funda", "São Paulo", "SP", "01133020"); #Telefone: 11 34662500 / Nome: CS Escola Barra Funda
INSERT INTO ENDERECO VALUES (NULL, "Avenida Vital Brasil", "1490", NULL, "Butantã", "São Paulo", "SP", "05503000"); #Telefone: 11 3061 8571 / Nome: Centro de Saúde Escola Samuel Barnsley Pessoa
INSERT INTO ENDERECO VALUES (NULL, "Praca Dom Pedro II, Largo do Campo da Pólvora", "8", NULL, "Nazaré", "Salvador", "BA", "40040280"); #Telefone: (71) 36114135 / Nome: UBS Ramiro De Azevedo
#Endereços cidadao
INSERT INTO ENDERECO VALUES (NULL, "Rua Araújo Lima", "115", "Apartamento 501", "Vila Isabel", "Rio de Janeiro", "RJ", "20541050");
INSERT INTO ENDERECO VALUES (NULL, "Avenida Marechal Rondon", "1045", "Casa 15", "Rocha", "Rio de Janeiro", "RJ", "20950006");
INSERT INTO ENDERECO VALUES (NULL, "Rua Salomé Queiroga", "239", NULL, "Vila Carrão", "São Paulo", "SP", "03434000");
INSERT INTO ENDERECO VALUES (NULL, "Rua Natal Veronez", "615", NULL, "Três Barras", "Minas Gerais", "MG", "32041090");
INSERT INTO ENDERECO VALUES (NULL, "Rua dos Andradas", "67a", NULL, "Boqueirão", "Passo Fundo", "RS", "99025020");
#Produtora
INSERT INTO ENDERECO VALUES (NULL, "Rodovia Presidente Castelo Branco", "32501", "KM 32,5 - Edifício de Manufatura - Entrada B", "Ingahi", "Itapevi", "SP", "06696000");# Telefone: (11) 51800600 / Nome: Pfizer Fábrica
INSERT INTO ENDERECO VALUES (NULL, "Avenida Vital Brasil", "1500", NULL, "Butantã", "São Paulo", "SP", "05503900");#Instituto butantã
INSERT INTO ENDERECO VALUES (NULL, "Estrada dos Bandeirantes", "8464", NULL, "Camorim", "Rio de Janeiro", "RJ", "");#GSK(GloxoSmithKline)
INSERT INTO ENDERECO VALUES (NULL, "Avenida Brasil", "4365", NULL, "Manguinhos", "Rio de Janeiro", "RJ", "21040360");#Fiocruz

#Cidadão -> (Código, Nome, Sexo, Idade, CPF, RG, FK_ENDERECO)
INSERT INTO CIDADAO VALUES (NULL, "Bruno Proença", "M", 25, "06045842707", "263968182", 7);
INSERT INTO CIDADAO VALUES (NULL, "Julio César", "M", 49, "19856960029", "118485672", 11);
INSERT INTO CIDADAO VALUES (NULL, "Carla Maranhos", "F", 34, "27852441092", "192139058", 9);
INSERT INTO CIDADAO VALUES (NULL, "Maria Pires", "F", 58, "44262987094", "390661818", 8);
INSERT INTO CIDADAO VALUES (NULL, "Felipe Souza", "M", 18, "52997141060", "296278245", 10);
INSERT INTO CIDADAO VALUES (NULL, "Luiz Silva", "M", 56, "79656455720", "419189105", 7);
INSERT INTO CIDADAO VALUES (NULL, "Maria Torres", "F", 22, "49472198074", "134356391", 8);
INSERT INTO CIDADAO VALUES (NULL, "Fernanda Lúcia", "F", 67, "62781723053", "172750799", 10);

#Produtora -> (Código, Nome_Comercial, Nome_Fantasia, CNPJ, FK_ENDERECO)
INSERT INTO PRODUTORA VALUES (NULL, "LABORATORIOS PFIZER LTDA", "Pfizer", "46070868001998", 12);
INSERT INTO PRODUTORA VALUES (NULL, "FUNDACAO OSWALDO CRUZ", "Fiocruz", "33781055000135", 15);
INSERT INTO PRODUTORA VALUES (NULL, "FUNDACAO BUTANTAN", "Butantan", "61189445000156", 13);
INSERT INTO PRODUTORA VALUES (NULL, "GLAXOSMITHKLINE BRASIL LTDA", "GSK", "33247743003569", 14);