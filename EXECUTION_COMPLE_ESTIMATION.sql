SELECT		b.text, a.command,
			a.percent_complete, 
			CONVERT(VARCHAR(20),DATEADD(ms,a.estimated_completion_time,GetDate()),20) AS estimated_completion_time
FROM		sys.dm_exec_requests a
CROSS APPLY sys.dm_exec_sql_text(a.sql_handle) b
WHERE		(a.command LIKE '%DBCC%'
OR			 a.command LIKE '%ALTER%'
OR			 a.command LIKE '%BACKUP%'
OR			 a.command LIKE '%RESTORE HEADERON%')