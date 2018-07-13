SELECT		h.server servidor,
			j.name job,
			j.description descricao,
			h.step_name step,
			CONVERT(DATE,(CONVERT(VARCHAR(8),h.run_date))) data_exec,
			STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(h.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') hora_exec,
			h.message mensagem
FROM		msdb..sysjobhistory h
INNER JOIN	msdb..sysjobs j
ON			h.job_id = j.job_id
WHERE		DATEDIFF(DAY,CONVERT(DATE,(CONVERT(VARCHAR(8),h.run_date))),GETDATE()) = 1
AND			h.run_status <> 1
AND			h.step_id <> 0