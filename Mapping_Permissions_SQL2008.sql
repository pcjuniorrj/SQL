DECLARE @cmd NVARCHAR(MAX);

SET @cmd = 
'INSERT INTO	Monitoramento.dbo.DBROLES(servername, dbname, rolename, username, usertype)
SELECT		@@SERVERNAME servername,
			''?'' dbname,
			r.name rolename, 
			m.name username, 
			m.type_desc usertype

FROM		sys.database_role_members rm
LEFT JOIN	sys.database_principals r
ON			r.principal_id = rm.role_principal_id
LEFT JOIN	sys.database_principals m
ON			m.principal_id = rm.member_principal_id';

EXEC sp_MSforeachdb @command1 = @cmd




SELECT		*
FROM		Monitoramento.dbo.DBROLES