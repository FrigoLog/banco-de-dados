USE frigolog;

INSERT INTO tipo_usuario (tipo) VALUES
	('admin_frigolog'),
    ('suporte_n3_frigolog'),
    ('suporte_n2_frigolog'),
    ('suporte_n1_frigolog'),
    ('admin_empresa'),
    ('operador');

INSERT INTO empresa (razao_social, cnpj, codigo_cadastro) VALUES
	('Frigolog Desenvolvimento', '11111111000111', 'FRGADM01'),
    ('Empresa X', '22222222000122', 'FRGJHL76');

INSERT INTO usuario (nome, senha, email, fk_tipo_usuario, fk_empresa) VALUES
	('Bruno Rafael', SHA2('bruno@123', 224), 'bruno.rafael@frigolog.com', 1, 1),
    ('Thays Ramos', SHA2('thays123', 224), 'thays.ramos@frigolog.com', 1, 1),
    ('Matheus Delfiol', SHA2('matheus123', 224), 'matheus.delfiol@frigolog.com', 1, 1),
    ('Matheus Martins', SHA2('matheus123', 224), 'metheus.martins@frigolog.com', 1, 1),
    ('Felipe Gonçalves', SHA2('felipe123', 224), 'felipe.goncalves@frigolog.com', 1, 1),
    ('Luiz Phelipe', SHA2('luiz123', 224), 'luiz.phelipe@frigolog.com', 1, 1),
    ('Julio Brandao', SHA2('julio123', 224), 'julio.brandao@empresax.com', 5, 2);

INSERT INTO endereco (cep, numero) VALUES
	('01001000', '100'),
	('02002000', '250'),
	('0303000', '500');

INSERT INTO tipo_ambiente (tipo) VALUES
	('Supermercado'),
	('Centro de Distribuição'),
	('Transportadora');

INSERT INTO ambiente_externo (nome, fk_empresa, fk_tipo_ambiente, fk_endereco) VALUES
	('CD SPTech', 2, 2, 1),
	('Mercado XPTO', 2, 1, 2),
	('Transportadora Bob', 2, 3, 3);

INSERT INTO configuracao_ponto_operacional (temp_min, temp_max) VALUES
	(0, 4);

INSERT INTO tipo_ponto_operacional (tipo) VALUES
	('Geladeira'),
	('Freezer'),
	('Câmara Fria'),
	('Caminhão Refrigerado');

INSERT INTO ponto_operacional (nome, fk_tipo_po, fk_ambiente, fk_configuracao_po) VALUES
	('Geladeira Principal', 1, 1, 1),
	('Freezer Estoque', 4, 1, 1),
	('Caminhão EIB6086', 3, 2, 1),
	('Geladeira Secundaria', 1, 1, 1),
	('Câmara Fria Carnes', 3, 1, 1),
	('Freezer Principal', 2, 2, 1),
	('Geladeira Açougue', 1, 2, 1),
	('Caminhão ABC1234', 4, 3, 1),
	('Caminhão XYZ5678', 4, 3, 1);

INSERT INTO sensor (identificador, fk_po) VALUES
	('TEMP-0001', 1),
	('TEMP-0002', 2),
	('TEMP-0003', 3),
	('TEMP-0004', 4),
	('TEMP-0005', 5),
	('TEMP-0006', 6),
	('TEMP-0007', 7),
	('TEMP-0008', 8),
	('TEMP-0009', 9);
    
INSERT INTO contato (nome_empresa, email, telefone, data_mensagem) VALUES
('Seara', 'seara@carne.com', '11999999999', '2026-05-30 20:10:00'),
('Friboi', 'friboi@carne.com', '11666666666', '2026-05-31 13:20:00'),
('Swift', 'swift@carne.com', '11555555555', '2026-05-21 09:10:00');
