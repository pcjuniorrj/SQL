SELECT		*
FROM		msdb..sysjobhistory h
INNER JOIN	msdb..sysjobs j
ON			h.job_id = j.job_id
WHERE		DATEDIFF(DAY,CONVERT(DATE,(CONVERT(VARCHAR(8),h.run_date))),GETDATE()) = 1
AND			h.run_status <> 1