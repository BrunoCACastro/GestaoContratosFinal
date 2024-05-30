CREATE DATABASE Projeto_Gestao_Contratos_Etapa_5;

USE Projeto_Gestao_Contratos_Etapa_5; 

SHOW TABLES;

CREATE TABLE Contratos (
  id_contrato INT NOT NULL AUTO_INCREMENT,
  nome_contrato VARCHAR(100) NOT NULL,
  descricao_contrato TEXT,
  data_inicio DATE NOT NULL,
  data_termino DATE NOT NULL,
  PRIMARY KEY (id_contrato)
);

CREATE TABLE Termos_Aditivos (
  id_termo_aditivo INT NOT NULL AUTO_INCREMENT,
  id_contrato INT NOT NULL,
  descricao_termo_aditivo TEXT,
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  PRIMARY KEY (id_termo_aditivo),
  FOREIGN KEY (id_contrato) REFERENCES Contratos(id_contrato)
);

CREATE TABLE Empenhos_Contrato (
  id_empenho INT NOT NULL AUTO_INCREMENT,
  numero_empenho VARCHAR(50) NOT NULL,
  numero_contrato VARCHAR(50) NOT NULL,
  conta_contabil VARCHAR(50) NOT NULL,
  valor_empenho DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_empenho)
);

CREATE TABLE Faturas_Contrato (
  id INT NOT NULL AUTO_INCREMENT,
  numero_fatura VARCHAR(50) NOT NULL,
  data_emissao DATE NOT NULL,
  data_vencimento DATE NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  contrato_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (contrato_id) REFERENCES Contratos(id_contrato)
);