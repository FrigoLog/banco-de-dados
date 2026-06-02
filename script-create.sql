CREATE DATABASE frigolog;
use frigolog;

CREATE TABLE tipo_usuario (
	id_tipo_usuario INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(25)
);

CREATE TABLE empresa (
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
	razao_social VARCHAR(120),
	cnpj CHAR(14) UNIQUE,
    codigo_cadastro CHAR(8) UNIQUE
);

CREATE TABLE usuario (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    senha VARCHAR(255),
    email VARCHAR(80) UNIQUE,
    fk_tipo_usuario INT,
    fk_empresa INT,
    CONSTRAINT ctFkUsuarioEmpresa FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa),
    CONSTRAINT ctFkTipoUsuario FOREIGN KEY (fk_tipo_usuario) REFERENCES tipo_usuario(id_tipo_usuario)
);

CREATE TABLE endereco (
	id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    cep CHAR(8),
    numero VARCHAR(10)
);

CREATE TABLE tipo_ambiente (
	id_tipo_ambiente INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45)
);

CREATE TABLE ambiente_externo (
	id_ambiente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    fk_empresa INT,
    fk_tipo_ambiente INT,
	fk_endereco INT,
    CONSTRAINT ctFkEnderecoAmbiente FOREIGN KEY (fk_endereco) REFERENCES endereco (id_endereco),
    CONSTRAINT ctFkAmbienteEmpresa FOREIGN KEY (fk_empresa) REFERENCES empresa (id_empresa),
    CONSTRAINT ctFkAmbienteTipo FOREIGN KEY (fk_tipo_ambiente) REFERENCES tipo_ambiente (id_tipo_ambiente)
);

CREATE TABLE configuracao_ponto_operacional (
	id_configuracao INT PRIMARY KEY AUTO_INCREMENT,
    temp_min FLOAT,
    temp_max FLOAT
);

CREATE TABLE tipo_ponto_operacional (
	id_tipo_po INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45)
);

CREATE TABLE ponto_operacional (
	id_ponto_operacional INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    fk_tipo_po INT,
    fk_ambiente INT,
	fk_configuracao_po INT,
    CONSTRAINT ctFkConfigPO FOREIGN KEY (fk_configuracao_po) REFERENCES configuracao_ponto_operacional (id_configuracao),
    CONSTRAINT ctFkTipoPO FOREIGN KEY (fk_tipo_po) REFERENCES tipo_ponto_operacional (id_tipo_po),
    CONSTRAINT ctFkAmbienteExterno FOREIGN KEY (fk_ambiente) REFERENCES ambiente_externo (id_ambiente)
);

CREATE TABLE sensor (
	id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    identificador VARCHAR(30),
    fk_po INT,
    CONSTRAINT ctFkSensorPO FOREIGN KEY (fk_po) REFERENCES ponto_operacional (id_ponto_operacional)
);

CREATE TABLE leitura (
	id_leitura INT PRIMARY KEY AUTO_INCREMENT,
    temperatura FLOAT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    fk_sensor INT,
    CONSTRAINT fkLeituraSensor FOREIGN KEY (fk_sensor) REFERENCES sensor (id_sensor)
);

CREATE TABLE contato (
    id_contato INT PRIMARY KEY AUTO_INCREMENT,
    nome_empresa VARCHAR(100),
    email VARCHAR(100),
    telefone CHAR(11),
    data_mensagem  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
