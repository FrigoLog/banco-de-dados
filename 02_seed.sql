USE frigolog;

INSERT INTO tipo_usuario (tipo) VALUES
('Administrador'),
('Gestor'),
('Operador');

INSERT INTO empresa (razao_social, cnpj, codigo_cadastro) VALUES
('Frigolog Desenv LTDA', '12345678000101', 'ABCD1234');

INSERT INTO usuario (nome, senha, email, fk_tipo_usuario, fk_empresa) VALUES
('Bruno', 'bruno@frigolog123', 'bruno@frigolog.com', 1, 1);

INSERT INTO endereco (cep, numero) VALUES
('09750000', '120'),
('09090000', '450'),
('11035000', '800'),
('13050000', '155');

INSERT INTO tipo_ambiente (tipo) VALUES
('Supermercado'),
('Transportadora'),
('Centro de Distribuição');

INSERT INTO ambiente_externo (nome, fk_empresa, fk_tipo_ambiente, fk_endereco) VALUES
('Assaí Atacadista São Bernardo', 1, 1, 1),
('JSL Transportes Santo André', 1, 2, 2),
('Mercado Livre Hub Santos', 1, 3, 3),
('Atacadão Campinas', 1, 1, 4);

INSERT INTO configuracao_ponto_operacional (temp_min, temp_max) VALUES
(0, 4),
(-18, -10),
(0, 8),
(2, 6);

INSERT INTO tipo_ponto_operacional (tipo) VALUES
('Geladeira'),
('Câmara Fria'),
('Caminhão Refrigerado'),
('Freezer');

INSERT INTO ponto_operacional (nome, fk_tipo_po, fk_ambiente, fk_configuracao_po) VALUES
('Geladeira Açougue', 1, 1, 1),
('Freezer Açougue', 4, 1, 2),
('Baú Caminhão 7821', 3, 2, 3),
('Câmara Principal', 2, 3, 2),
('Geladeira Estoque', 1, 4, 4);

INSERT INTO sensor (identificador, fk_po) VALUES
('TEMP-A01', 1),
('TEMP-A02', 2),
('TEMP-T01', 3),
('TEMP-C01', 4),
('TEMP-G01', 5);
