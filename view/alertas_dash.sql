USE frigolog;

CREATE OR REPLACE VIEW vw_alertas AS
SELECT
	e.id_empresa,
    e.razao_social,
    ae.nome as ambiente,
    po.id_ponto_operacional,
    po.nome as ponto_operacional,
    s.identificador,
    l.id_leitura,
    l.temperatura,
    l.data_hora,
    CASE
		WHEN l.temperatura < c.temp_min
			AND (c.temp_min - l.temperatura) <= 3
		THEN 'Alerta Padrão'
        WHEN l.temperatura > c.temp_max
			AND (l.temperatura - c.temp_max) <= 3
		THEN 'Alerta Padrão'
        ELSE 'Alerta Crítico'
	END AS nivel_alerta
    FROM leitura l
    JOIN sensor s
		ON l.fk_sensor = s.id_sensor
	JOIN ponto_operacional po
		ON s.fk_po = po.id_ponto_operacional
	JOIN ambiente_externo ae
		ON po.fk_ambiente = ae.id_ambiente
	JOIN empresa e
		ON ae.fk_empresa = e.id_empresa
	JOIN configuracao_ponto_operacional c
		ON po.fk_configuracao_po = c.id_configuracao
	WHERE l.temperatura < c.temp_min OR l.temperatura > c.temp_max;
