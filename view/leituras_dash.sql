CREATE VIEW vw_leituras_ponto_operacional AS
SELECT 
    po.id_ponto_operacional,
    po.nome AS nome_ponto_operacional,
    tpo.tipo AS tipo_ponto_operacional,
    ae.nome AS ambiente,
    s.id_sensor,
    s.identificador AS identificador_sensor,
    l.id_leitura,
    l.temperatura,
    l.data_hora,
    cpo.temp_min,
    cpo.temp_max,
    CASE
        WHEN l.temperatura < cpo.temp_min THEN 0
        WHEN l.temperatura > cpo.temp_max THEN 0
        ELSE 1
    END AS status_temperatura
FROM ponto_operacional po

JOIN tipo_ponto_operacional tpo
    ON po.fk_tipo_po = tpo.id_tipo_po
JOIN ambiente_externo ae
    ON po.fk_ambiente = ae.id_ambiente
JOIN configuracao_ponto_operacional cpo
    ON po.fk_configuracao_po = cpo.id_configuracao
JOIN sensor s
    ON s.fk_po = po.id_ponto_operacional
JOIN leitura l
    ON l.fk_sensor = s.id_sensor) as tudo;
