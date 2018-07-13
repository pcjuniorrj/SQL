SELECT		Server,
			Dbase,
			'' [Crítico]
FROM		dbo.DBASES_AUDIT
WHERE		Server NOT LIKE	'%DES%'
AND			Server NOT LIKE	'%HOMOLOG%'
AND			Server NOT LIKE '%HMLG%'
AND			Server NOT IN ('REPMSQL02S')
AND			Dbase NOT IN ('master','model','msdb','tempdb','ReportServer','ReportServerTempDB','ReportServer$SSIS','ReportServer$SSISTempDB','Monitoramento')
AND			State = 'ONLINE'
AND			UserAccess = 'MULTI_USER'
AND			Mode = 'READ WRITE'
GROUP BY	Server,
			Dbase
ORDER BY	1,2