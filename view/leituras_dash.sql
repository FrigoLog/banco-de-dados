CREATE VIEW vw_status_ponto_operacional AS
SELECT 
    po.id_ponto_operacional,
    po.nome AS ponto_operacional,
    e.id_empresa,
    e.razao_social,
    ae.id_ambiente,
    ae.nome as nome_ambiente,
    cpo.temp_min,
    cpo.temp_max,
    l.id_leitura,
    l.temperatura,
    l.data_hora,
    CASE
        WHEN l.temperatura BETWEEN cpo.temp_min AND cpo.temp_max
            THEN 'NORMAL'
        WHEN (
            ABS(l.temperatura - cpo.temp_min) <= 5
            AND l.temperatura < cpo.temp_min
        )
        OR (
            ABS(l.temperatura - cpo.temp_max) <= 5
            AND l.temperatura > cpo.temp_max
        )
            THEN 'ALERTA'
        ELSE 'CRITICO'
    END AS status_operacional
FROM ponto_operacional po
JOIN ambiente_externo ae
    ON ae.id_ambiente = po.fk_ambiente
JOIN empresa e
    ON e.id_empresa = ae.fk_empresa
JOIN configuracao_ponto_operacional cpo
    ON cpo.id_configuracao = po.fk_configuracao_po
JOIN sensor s
    ON s.fk_po = po.id_ponto_operacional
JOIN leitura l
    ON l.fk_sensor = s.id_sensor
WHERE l.id_leitura = (
    SELECT MAX(l2.id_leitura)
    FROM leitura l2
    JOIN sensor s2
        ON s2.id_sensor = l2.fk_sensor
    WHERE s2.fk_po = po.id_ponto_operacional
);

CREATE VIEW vw_conformidade_do_sistema AS
SELECT 
    id_empresa,
    ROUND(
        ( SUM(
			CASE
				WHEN status_operacional = 'NORMAL'
				THEN 1
				ELSE 0
			END ) * 100.0 ) / COUNT(*), 0) AS porcentagem
FROM vw_status_ponto_operacional
GROUP BY id_empresa;

CREATE VIEW vw_nao_conformidade AS
SELECT
	id_empresa,
    nome_ambiente,
    ROUND(
		( SUM(
				CASE
					WHEN status_operacional <> 'NORMAL'
                    THEN 1
                    ELSE 0
				END ) * 100.0 ) / count(*), 0 ) AS porcentagem
FROM vw_status_ponto_operacional
GROUP BY id_ambiente
LIMIT 5;