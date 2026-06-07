USE frigolog;

-- Status de todas as leituras (histórico)
CREATE OR REPLACE VIEW vw_status_ponto_operacional AS
SELECT 
    po.id_ponto_operacional,
    po.nome AS ponto_operacional,
    e.id_empresa,
    e.razao_social,
    ae.id_ambiente,
    ae.nome AS nome_ambiente,
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
    ON l.fk_sensor = s.id_sensor;
    
-- KPI: conformidade atual do sistema
CREATE OR REPLACE VIEW vw_conformidade_do_sistema AS
SELECT
    id_empresa,
    ROUND(
        SUM(
            CASE
                WHEN status_operacional = 'NORMAL'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        0
    ) AS porcentagem
FROM vw_status_ponto_operacional
WHERE id_leitura IN (
    SELECT MAX(l.id_leitura)
    FROM leitura l
    JOIN sensor s
        ON s.id_sensor = l.fk_sensor
    GROUP BY s.fk_po
)
GROUP BY id_empresa;

-- Não conformidade atual por ambiente
CREATE OR REPLACE VIEW vw_nao_conformidade AS
SELECT
    id_empresa,
    nome_ambiente,
    ROUND(
        SUM(
            CASE
                WHEN status_operacional <> 'NORMAL'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        0
    ) AS porcentagem
FROM vw_status_ponto_operacional
WHERE id_leitura IN (
    SELECT MAX(l.id_leitura)
    FROM leitura l
    JOIN sensor s
        ON s.id_sensor = l.fk_sensor
    GROUP BY s.fk_po
)
GROUP BY
    id_empresa,
    id_ambiente,
    nome_ambiente;
    
-- Histórico para gráfico
CREATE OR REPLACE VIEW vw_dash_conformidade_do_sistema AS
SELECT
    dados.id_empresa,
    dados.hora,

    ROUND(
        SUM(
            CASE
                WHEN dados.status_operacional = 'NORMAL'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        0
    ) AS conformidade

FROM (
    SELECT
        v.id_empresa,
        v.id_ponto_operacional,
        DATE_FORMAT(v.data_hora, '%Y-%m-%d %H:00') AS hora,
        v.status_operacional,
        v.id_leitura
    FROM vw_status_ponto_operacional v
    INNER JOIN (
        SELECT
            id_ponto_operacional,
            DATE_FORMAT(data_hora, '%Y-%m-%d %H:00') AS hora,
            MAX(id_leitura) AS ultima_leitura
        FROM vw_status_ponto_operacional
        GROUP BY
            id_ponto_operacional,
            DATE_FORMAT(data_hora, '%Y-%m-%d %H:00')
    ) ultimas
        ON ultimas.ultima_leitura = v.id_leitura
) dados
GROUP BY
    dados.id_empresa,
    dados.hora
ORDER BY
    dados.hora;
    
-- Pontos operacionais criticos
CREATE OR REPLACE VIEW vw_pontos_operacionais_criticos AS
SELECT
    e.id_empresa,
    COALESCE(
        SUM(
            CASE
                WHEN v.status_operacional = 'CRITICO'
                THEN 1
                ELSE 0
            END
        ),
        0
    ) AS quantidade
FROM empresa e
LEFT JOIN vw_status_ponto_operacional v
    ON v.id_empresa = e.id_empresa
    AND v.id_leitura IN (
        SELECT MAX(l.id_leitura)
        FROM leitura l
        JOIN sensor s
            ON s.id_sensor = l.fk_sensor
        GROUP BY s.fk_po
    )
GROUP BY e.id_empresa;

-- Status dos pontos operacionais
CREATE OR REPLACE VIEW vw_status_pontos_operacionais AS
SELECT
    id_empresa,
    status_operacional,
    COUNT(*) AS quantidade
FROM vw_status_ponto_operacional
WHERE id_leitura IN (
    SELECT MAX(l.id_leitura)
    FROM leitura l
    JOIN sensor s
        ON s.id_sensor = l.fk_sensor
    GROUP BY s.fk_po
)
GROUP BY
    id_empresa,
    status_operacional;
    
CREATE OR REPLACE VIEW vw_alertas_24h AS
SELECT
    e.id_empresa,
    po.id_ponto_operacional,
    po.nome AS ponto_operacional,
    ae.nome AS ambiente,
    COUNT(*) AS qtd_alertas
FROM alerta a
JOIN ponto_operacional po
    ON po.id_ponto_operacional = a.fk_po
JOIN ambiente_externo ae
    ON ae.id_ambiente = po.fk_ambiente
JOIN empresa e
    ON e.id_empresa = ae.fk_empresa
JOIN leitura l
    ON l.id_leitura = a.fk_leitura
WHERE l.data_hora >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
GROUP BY
    e.id_empresa,
    po.id_ponto_operacional,
    po.nome,
    ae.nome;
    
CREATE OR REPLACE VIEW vw_ponto_operacional_mais_critico AS
SELECT
    id_empresa,
    ponto_operacional,
    nome_ambiente,
    CASE
        WHEN temperatura > temp_max
            THEN ROUND(temperatura - temp_max, 1)
        WHEN temperatura < temp_min
            THEN ROUND(temp_min - temperatura, 1)
        ELSE 0
    END AS diferenca,
    temperatura,
    temp_min,
    temp_max,
    status_operacional
FROM vw_status_ponto_operacional
WHERE id_leitura IN (
    SELECT MAX(l.id_leitura)
    FROM leitura l
    JOIN sensor s
        ON s.id_sensor = l.fk_sensor
    GROUP BY s.fk_po
);

CREATE OR REPLACE VIEW vw_ponto_operacional_mais_critico AS
SELECT
    id_empresa,
    id_ponto_operacional,
    ponto_operacional,
    nome_ambiente,
    temperatura,
    temp_min,
    temp_max,
    status_operacional,
    CASE
        WHEN temperatura > temp_max THEN ROUND(temperatura - temp_max, 1)
        WHEN temperatura < temp_min THEN ROUND(temp_min - temperatura, 1)
        ELSE 0
    END AS diferenca
FROM vw_status_ponto_operacional
WHERE id_leitura IN (
    SELECT MAX(l.id_leitura)
    FROM leitura l
    JOIN sensor s ON s.id_sensor = l.fk_sensor
    GROUP BY s.fk_po
)
ORDER BY diferenca DESC;
