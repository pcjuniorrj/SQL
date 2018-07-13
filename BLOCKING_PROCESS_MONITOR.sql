SELECT
	DB_NAME( a.database_id ) [database],
	a.session_id,
	a.blocking_session_id,
	b.host_name,
	b.program_name,
	b.login_name,
	a.command,
	a.wait_type,
	a.wait_time,
	a.wait_resource,
	a.status,
	c.text,
	d.query_plan
FROM sys.dm_exec_requests a
	INNER JOIN sys.dm_exec_sessions b
		ON a.session_id = b.session_id
	CROSS APPLY sys.dm_exec_sql_text( a.sql_handle ) c
	CROSS APPLY sys.dm_exec_query_plan( a.plan_handle ) d
WHERE a.session_id <> @@spid
ORDER BY a.blocking_session_id DESC