CREATE VIEW vw_conformidade_do_sistema AS
SELECT 
    id_empresa,
    ROUND(
        ( SUM(
			CASE
				WHEN status_operacional = 'NORMAL'
				THEN 1
				ELSE 0
			END ) * 100.0 ) / COUNT(*), 2) AS porcentagem
FROM vw_status_ponto_operacional
GROUP BY id_empresa;