SELECT		@@SERVERNAME Servidor,
			J.name Job,
			CASE H.run_status
				WHEN 0 THEN 'falha'
				WHEN 1 THEN 'sucesso'
				WHEN 2 THEN 'repetir'
				WHEN 3 THEN 'cancelada'
			END Status,
			J.description Descricao,
			STUFF(STUFF(convert(varchar(8),H.run_date),5,0,'-'),8,0,'-')+' '+STUFF(STUFF(RIGHT(REPLICATE('0',8)+CONVERT(varchar(6),run_time),6),3,0,':'),6,0,':') Execucao,
			STUFF(STUFF(STUFF(RIGHT(REPLICATE('0', 8) + CAST(h.run_duration as varchar(8)), 8), 3, 0, ':'), 6, 0, ':'), 9, 0, ':') Duracao
FROM		msdb..sysjobs J
INNER JOIN	msdb..sysjobhistory H
ON			J.job_id = H.job_id
WHERE		datediff(day,convert(datetime,convert(varchar(8),H.run_date)),getdate())=1
AND			H.step_id = 0
AND			H.run_status = 0