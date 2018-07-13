USE MSDB
GO

SELECT		H.server,
			J.name job,
			CASE J.enabled
				WHEN 1 THEN 'ATIVO'
				ELSE 'INATIVO'
			END status,
			CASE H.run_status
				WHEN 0 THEN 'falha'
				WHEN 1 THEN 'sucesso'
				WHEN 2 THEN 'repetir'
				WHEN 3 THEN 'cancelado'
			END exec_status,
			convert(datetime,(convert(varchar(8),H.run_date))) run_date
FROM		sysjobs J
INNER JOIN	sysjobhistory H
on			J.job_id = H.job_id
GROUP BY	H.server, J.name, J.enabled, H.run_status, H.run_date
