CREATE DATABASE eVacina;

USE eVacina;

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
	Data_nascimento DATE NOT NULL,
	CPF VARCHAR(11) UNIQUE NOT NULL,
	RG VARCHAR(9) UNIQUE NOT NULL,
	Cod_end INT
);
	
CREATE TABLE PRODUTORA(
	Cod_prod INT PRIMARY KEY AUTO_INCREMENT,
	Nome_comercial VARCHAR(70) UNIQUE NOT NULL,
	Nome_fantasia VARCHAR(70) NOT NULL,
	CNPJ VARCHAR(14) UNIQUE NOT NULL,
	Cod_end INT
);

CREATE TABLE POSTO(
	Cod_posto INT PRIMARY KEY AUTO_INCREMENT,
	Nome VARCHAR(100) NOT NULL,
	Cod_end INT
);

CREATE TABLE FUNCIONARIO(
	Cod_func INT PRIMARY KEY AUTO_INCREMENT,
	Cargo VARCHAR(30) NOT NULL,
	Cod_posto INT NOT NULL,
	Cod_cid INT NOT NULL
);

CREATE TABLE LOTE(
	Cod_lote VARCHAR(8) PRIMARY KEY,
	Data_estoque DATE,
	Cod_posto INT,
  Cod_prod INT NOT NULL
);

CREATE TABLE FRASCO(
	Cod_frasco VARCHAR(10) PRIMARY KEY,
	Doses_disponiveis SMALLINT,
	Data_vencimento DATE NOT NULL,
	Cod_lote VARCHAR(8) NOT NULL,
	Cod_vac INT NOT NULL
);

CREATE TABLE VACINA(
	Cod_vac INT PRIMARY KEY,
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
	Cod_cont INT NOT NULL,
  PRIMARY KEY(Cod_cid, Cod_cont)
);

CREATE TABLE CONTATO_POSTO(
	Cod_cont INT PRIMARY KEY,
	Cod_posto INT NOT NULL
);

CREATE TABLE CONTATO_PROD(
	Cod_cont INT PRIMARY KEY,
	Cod_prod INT NOT NULL
);

CREATE TABLE VACINACAO(
	Cod_vcao INT PRIMARY KEY AUTO_INCREMENT,
	Data_aplicacao DATE NOT NULL,
	Cod_frasco VARCHAR(11) NOT NULL,
	Cod_posto INT NOT NULL,
	Cod_func INT NOT NULL,
	Cod_cid INT NOT NULL
);



ALTER TABLE CIDADAO ADD CONSTRAINT fk_Cidadao_Endereco FOREIGN KEY(Cod_end) REFERENCES ENDERECO(Cod_end)
	ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE PRODUTORA ADD CONSTRAINT fk_Produtora_Endereco FOREIGN KEY(Cod_end) REFERENCES ENDERECO(Cod_end)
	ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE POSTO ADD CONSTRAINT fk_Posto_Endereco FOREIGN KEY(Cod_end) REFERENCES ENDERECO(Cod_end)
	ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE FUNCIONARIO ADD CONSTRAINT fk_Funcionario_Posto FOREIGN KEY(Cod_posto) REFERENCES POSTO(Cod_posto)
	ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE FUNCIONARIO ADD CONSTRAINT fk_Funcionario_Cidadao FOREIGN KEY(Cod_cid) REFERENCES CIDADAO(Cod_cid)
	ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE LOTE ADD CONSTRAINT fk_Lote_Posto FOREIGN KEY(Cod_posto) REFERENCES POSTO(Cod_posto)
	ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE LOTE ADD CONSTRAINT fk_Lote_Prod FOREIGN KEY(Cod_prod) REFERENCES POSTO(Cod_prod)
	ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE FRASCO ADD CONSTRAINT fk_Frasco_Vacina FOREIGN KEY(Cod_vac) REFERENCES VACINA(Cod_vac)
	ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE FRASCO ADD CONSTRAINT fk_Frasco_Lote FOREIGN KEY(Cod_lote) REFERENCES LOTE(Cod_lote)
	ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE CONTATO_POSTO ADD CONSTRAINT fk_Contato_Posto FOREIGN KEY(Cod_posto) REFERENCES POSTO(Cod_posto)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE CONTATO_POSTO ADD CONSTRAINT fk_Posto_Contato FOREIGN KEY(Cod_cont) REFERENCES CONTATO(Cod_cont)
	ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE CONTATO_PROD ADD CONSTRAINT fk_Contato_Produtora FOREIGN KEY(Cod_prod) REFERENCES PRODUTORA(Cod_prod)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE CONTATO_PROD ADD CONSTRAINT fk_Prod_Contato FOREIGN KEY(Cod_cont) REFERENCES CONTATO(Cod_cont)
	ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE CONTATO_CIDADAO ADD CONSTRAINT fk_Contato_Cidadao FOREIGN KEY(Cod_cid) REFERENCES CIDADAO(Cod_cid)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE CONTATO_CIDADAO ADD CONSTRAINT fk_Cidadao_Contato FOREIGN KEY(Cod_cont) REFERENCES CONTATO(Cod_cont)
	ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE VACINACAO ADD CONSTRAINT fk_Vacinacao_Frasco FOREIGN KEY(Cod_frasco) REFERENCES FRASCO(Cod_frasco)
	ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE VACINACAO ADD CONSTRAINT fk_Vacinacao_Posto FOREIGN KEY(Cod_posto) REFERENCES POSTO(Cod_posto)
	ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE VACINACAO ADD CONSTRAINT fk_Vacinacao_Funcionario FOREIGN KEY(Cod_func) REFERENCES FUNCIONARIO(Cod_func)
	ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE VACINACAO ADD CONSTRAINT fk_Vacinacao_Cidadao FOREIGN KEY(Cod_cid) REFERENCES CIDADAO(Cod_cid)
	ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE PRODUZ ADD CONSTRAINT fk_Prod_Produz FOREIGN KEY(Cod_prod) REFERENCES PRODUTORA(Cod_prod)
  ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE PRODUZ ADD CONSTRAINT fk_Lote_Produz FOREIGN KEY(Cod_lote) REFERENCES PRODUTORA(Cod_lote)
  ON DELETE RESTRICT ON UPDATE CASCADE;


INSERT INTO ENDERECO VALUES (NULL, "Rua Waldemar Dutra", "55", NULL, "Santo Cristo", "Rio de Janeiro", "RJ", "20220780");
INSERT INTO ENDERECO VALUES (NULL, "Avenida Henrique Valadares", "151", NULL, "Centro", "Rio de Janeiro", "RJ", "20231031");
INSERT INTO ENDERECO VALUES (NULL, "Avenida Doutor Abraão Ribeiro", "283", NULL, "Barra Funda", "São Paulo", "SP", "01133020");
INSERT INTO ENDERECO VALUES (NULL, "Avenida Vital Brasil", "1490", NULL, "Butantã", "São Paulo", "SP", "05503000");
INSERT INTO ENDERECO VALUES (NULL, "Praca Dom Pedro II, Largo do Campo da Pólvora", "8", NULL, "Nazaré", "Salvador", "BA", "40040280");

INSERT INTO ENDERECO VALUES (NULL, "Rua Araújo Lima", "115", "Apartamento 501", "Vila Isabel", "Rio de Janeiro", "RJ", "20541050");
INSERT INTO ENDERECO VALUES (NULL, "Avenida Marechal Rondon", "1045", "Casa 15", "Rocha", "Rio de Janeiro", "RJ", "20950006");
INSERT INTO ENDERECO VALUES (NULL, "Rua Salomé Queiroga", "239", NULL, "Vila Carrão", "São Paulo", "SP", "03434000");
INSERT INTO ENDERECO VALUES (NULL, "Rua Natal Veronez", "615", NULL, "Três Barras", "Minas Gerais", "MG", "32041090");
INSERT INTO ENDERECO VALUES (NULL, "Rua dos Andradas", "67a", NULL, "Boqueirão", "Passo Fundo", "RS", "99025020");

INSERT INTO ENDERECO VALUES (NULL, "Rodovia Presidente Castelo Branco", "32501", "KM 32,5 - Edifício de Manufatura - Entrada B", "Ingahi", "Itapevi", "SP", "06696000");
INSERT INTO ENDERECO VALUES (NULL, "Avenida Vital Brasil", "1500", NULL, "Butantã", "São Paulo", "SP", "05503900");
INSERT INTO ENDERECO VALUES (NULL, "Estrada dos Bandeirantes", "8464", NULL, "Camorim", "Rio de Janeiro", "RJ", "43543123");
INSERT INTO ENDERECO VALUES (NULL, "Avenida Brasil", "4365", NULL, "Manguinhos", "Rio de Janeiro", "RJ", "21040360");


INSERT INTO CIDADAO VALUES (NULL, "Bruno Proença", "M", '1993-04-22', "06045842707", "263968182", 7);
INSERT INTO CIDADAO VALUES (NULL, "Julio César", "M", '1994-04-22', "19856960029", "118485672", 6);
INSERT INTO CIDADAO VALUES (NULL, "Carla Maranhos", "F", '1995-04-22', "27852441092", "192139058", 9);
INSERT INTO CIDADAO VALUES (NULL, "Maria Pires", "F", '1996-04-22', "44262987094", "390661818", 8);
INSERT INTO CIDADAO VALUES (NULL, "Felipe Souza", "M", '1997-04-22', "52997141060", "296278245", 10);
INSERT INTO CIDADAO VALUES (NULL, "Luiz Silva", "M", '1998-04-22', "79656455720", "419189105", 7);
INSERT INTO CIDADAO VALUES (NULL, "Maria Torres", "F", '1999-04-22', "49472198074", "134356391", 8);
INSERT INTO CIDADAO VALUES (NULL, "Fernanda Lúcia", "F", '1992-04-22', "62781723053", "172750799", 10);


INSERT INTO PRODUTORA VALUES (NULL, "LABORATORIOS PFIZER LTDA", "Pfizer", "46070868001998", 12);
INSERT INTO PRODUTORA VALUES (NULL, "FUNDACAO OSWALDO CRUZ", "Fiocruz", "33781055000135", 14);
INSERT INTO PRODUTORA VALUES (NULL, "FUNDACAO BUTANTAN", "Butantan", "61189445000156", 13);
INSERT INTO PRODUTORA VALUES (NULL, "GLAXOSMITHKLINE BRASIL LTDA", "GSK", "33247743003569", 11);	

INSERT INTO POSTO VALUES (NULL, "ERNANI AGRICOLA", 1);
INSERT INTO POSTO VALUES (NULL, "BENJAMIN CONSTANT", 2);
INSERT INTO POSTO VALUES (NULL, "ALMIRA DA GRAÇA", 3);
INSERT INTO POSTO VALUES (NULL, "SAMIR ALBERTO", 4);
INSERT INTO POSTO VALUES (NULL, "TAVARES BASTOS", 5);

INSERT INTO FUNCIONARIO VALUES (NULL, "Enfermeiro", 2, 1);
INSERT INTO FUNCIONARIO VALUES (NULL, "Médico", 3, 2);
INSERT INTO FUNCIONARIO VALUES (NULL, "Pediatra", 4, 3);


INSERT INTO CONTATO VALUES (NULL, 'COM', "2187763212");
INSERT INTO CONTATO VALUES (NULL, 'RES', "3166632233");
INSERT INTO CONTATO VALUES (NULL, 'RES', "4177662233");
INSERT INTO CONTATO VALUES (NULL, 'COM', "7194568432");
INSERT INTO CONTATO VALUES (NULL, 'COM', "2154932345");
INSERT INTO CONTATO VALUES (NULL, 'CEL', "7183940323");
INSERT INTO CONTATO VALUES (NULL, 'RES', "6144883399");
INSERT INTO CONTATO VALUES (NULL, 'COM', "3130234234");
INSERT INTO CONTATO VALUES (NULL, 'COM', "1145634563");
INSERT INTO CONTATO VALUES (NULL, 'RES', "1174567567");
INSERT INTO CONTATO VALUES (NULL, 'CEL', "1135733473");
INSERT INTO CONTATO VALUES (NULL, 'COM', "2173468334");
INSERT INTO CONTATO VALUES (NULL, 'COM', "2183455284");
INSERT INTO CONTATO VALUES (NULL, 'CEL', "9123583456");
INSERT INTO CONTATO VALUES (NULL, 'COM', "5124572468");
INSERT INTO CONTATO VALUES (NULL, 'COM', "2122334455");
INSERT INTO CONTATO VALUES (NULL, 'CEL', "2136568457");
INSERT INTO CONTATO VALUES (NULL, 'CEL', "2123424546");
INSERT INTO CONTATO VALUES (NULL, 'COM', "2134554673");
INSERT INTO CONTATO VALUES (NULL, 'COM', "2125645634");


INSERT INTO CONTATO_PROD VALUES(1, 1);
INSERT INTO CONTATO_PROD VALUES(4, 2);
INSERT INTO CONTATO_PROD VALUES(5, 3);
INSERT INTO CONTATO_PROD VALUES(8, 4);
INSERT INTO CONTATO_PROD VALUES(20, 1);

INSERT INTO CONTATO_POSTO VALUES(9, 1);
INSERT INTO CONTATO_POSTO VALUES(12, 2);
INSERT INTO CONTATO_POSTO VALUES(13, 3);
INSERT INTO CONTATO_POSTO VALUES(14, 4);
INSERT INTO CONTATO_POSTO VALUES(16, 4);
INSERT INTO CONTATO_POSTO VALUES(17, 5);

INSERT INTO CONTATO_CIDADAO VALUES(1, 2);
INSERT INTO CONTATO_CIDADAO VALUES(2, 3);
INSERT INTO CONTATO_CIDADAO VALUES(2, 6);
INSERT INTO CONTATO_CIDADAO VALUES(3, 6);
INSERT INTO CONTATO_CIDADAO VALUES(4, 7);
INSERT INTO CONTATO_CIDADAO VALUES(5, 10);
INSERT INTO CONTATO_CIDADAO VALUES(5, 11);
INSERT INTO CONTATO_CIDADAO VALUES(6, 15);
INSERT INTO CONTATO_CIDADAO VALUES(7, 18);
INSERT INTO CONTATO_CIDADAO VALUES(8, 19);

DELIMITER $

CREATE PROCEDURE RECUPERAR_CODIGO(INOUT codigo INT)
BEGIN
  DECLARE identificador VARCHAR(2);
  DECLARE var1 INT;
  SET var1 = (SELECT COUNT(codigo) FROM FRASCO) + 1;
  SET identificador = CONVERT(var1, CHAR(2));
  SET	codigo = CAST(identificador as unsigned integer);
END
$

DELIMITER ;

DELIMITER $

CREATE TRIGGER CODIGO_FRASCO
BEFORE INSERT ON FRASCO
FOR EACH ROW
BEGIN
  SET @codigoFrasco = NEW.Cod_lote;
  CALL RECUPERAR_CODIGO(@codigoFrasco);
  SET NEW.Cod_frasco = CONCAT(CONVERT(NEW.Cod_lote, CHAR(8)), CONVERT(@codigoFrasco, CHAR(2)));
END
$

DELIMITER ;

DELIMITER $

CREATE TRIGGER ATUALIZA_DOSES
AFTER INSERT ON VACINACAO
FOR EACH ROW
BEGIN
  SET @doses = (SELECT Doses_disponiveis FROM FRASCO WHERE Cod_frasco = NEW.Cod_frasco);
  IF (@doses < 1) THEN
    SET @MSG='Error:Não há mais doses nesse frasco.';
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @MSG;
  ELSE
    UPDATE FRASCO SET Doses_disponiveis=(Doses_disponiveis-1) WHERE Cod_frasco = NEW.Cod_frasco;
  END IF;
END
$

DELIMITER ;

INSERT INTO LOTE VALUES ("AXTR6576", "2021-03-15", 1, 1);
INSERT INTO LOTE VALUES ("AXTR6577", "2021-03-16", 2, 3);
INSERT INTO LOTE VALUES ("AXTR6589", "2021-06-15", 4, 1);
INSERT INTO LOTE VALUES ("AXTR6568", "2021-02-15", NULL, 4);
INSERT INTO LOTE VALUES ("AXTR6508", "2021-01-15", 3, 2);

INSERT INTO VACINA VALUES (01011391, "BCG", "APLICAÇÃO DA VACINA BCG DOSE ÚNICA", true);
INSERT INTO VACINA VALUES (01011588 , "Tríplice Viral", "APLICAÇÃO DA VACINA TRÍPLICE VIRAL (CAXUMBA, RUBÉOLA E SARAMPO) DOSE ÚNICA", false);
INSERT INTO VACINA VALUES (01011987, "CoronaVac", "APLICAÇÃO DA VACINA CONTRA COVID-19", true);
INSERT INTO VACINA VALUES (01011988, "BioNTech", "APLICAÇÃO DA VACINA CONTRA COVID-19", true);
INSERT INTO VACINA VALUES (90124, "H1N1", "APLICAÇÃO DA VACINA CONTRA INFLUENZA A", false);

INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6576", 01011987);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6576", 01011987);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6576", 01011987);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6576", 01011987);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6577", 01011988);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6577", 01011988);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6577", 01011988);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6577", 01011988);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6589", 90124);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6568", 01011988);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6568", 01011988);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6568", 01011988);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6568", 01011988);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6508", 01011588);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6508", 01011588);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6508", 01011588);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6508", 01011588);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6508", 01011588);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6508", 01011588);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6508", 01011588);
INSERT INTO FRASCO VALUES ("1", 6, "2021-05-03", "AXTR6508", 01011588);

INSERT INTO VACINACAO VALUES(NULL, "2020-03-31", 89765764, 2, 2, 3);
INSERT INTO VACINACAO VALUES(NULL, "2020-05-31", 89765764, 2, 2, 3);
INSERT INTO VACINACAO VALUES(NULL, "2020-06-25", 897658910, 2, 1, 3);
INSERT INTO VACINACAO VALUES(NULL, "2020-08-30", 897656823, 2, 2, 3);



#Query para pegar as vacinas obrigatorias que o cidadao de CPF "27852441092" ainda não tomou
SET @cidadao = (SELECT Cod_cid FROM CIDADAO WHERE CPF = "27852441092");
SELECT Nome FROM VACINA WHERE Obrigatoria = true AND Cod_vac NOT IN (SELECT Cod_vac FROM FRASCO WHERE Cod_frasco IN (SELECT Cod_frasco FROM VACINACAO WHERE Cod_cid = @cidadao));