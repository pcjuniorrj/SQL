--TRUNCATE TABLE Monitoramento.dbo.DBROLES
USE [Monitoramento]

CREATE TABLE [dbo].[DBROLES](
	[servername] [nvarchar](128) NULL,
	[dbname] [nvarchar](128) NULL,
	[rolename] [sysname] NULL,
	[username] [sysname] NULL,
	[usertype] [nvarchar](60) NULL
) ON [PRIMARY]
GO


DECLARE @cmd NVARCHAR(4000);

SET @cmd = 
'USE [?];

INSERT INTO	Monitoramento.dbo.DBROLES(servername, dbname, rolename, username, usertype)
SELECT		@@SERVERNAME servername,
			''?'' dbname,
			r.name rolename, 
			m.name username, 
			'''' usertype
FROM		sysmembers rm
LEFT JOIN	sysusers r
ON			r.uid = rm.groupuid
LEFT JOIN	sysusers m
ON			m.uid = rm.memberuid;';




EXEC sp_MSforeachdb @command1 = @cmd



SELECT		*
FROM		Monitoramento.dbo.DBROLES