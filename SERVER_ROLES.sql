select 'ServerRole' = spv.name, 'MemberName' = lgn.name, 'MemberSID' = lgn.sid
from master.dbo.spt_values spv, master.dbo.sysxlogins lgn
where spv.low = 0 and
      spv.type = 'SRV' and
      --lgn.srvid IS NULL and
      spv.number & lgn.xstatus = spv.number
      
      
      
Select 
  [name], *
From
  sysusers
Where
  issqlrole = 1
  
select * from sysperfinfo  
select * from syspermissions
select * from sysxlogins
  
  
--SERVER AUDIT
USE master;
INSERT INTO [monitoramento].[dbo].[SERVER_AUDIT](
	[Config],
	[MinValue],
	[MaxValue],
	[Config_Value],
	[Run_Value]
) EXEC sp_configure
GO
UPDATE		[monitoramento].[dbo].[SERVER_AUDIT]
SET			[Server] = @@SERVERNAME,
			[Version] = @@VERSION,
			[Edition] = CONVERT(VARCHAR(255),SERVERPROPERTY('EDITION')),
			[DtInfo] = GETDATE()
WHERE		[Server] IS NULL;
GO  


SELECT		[Server],
			[Version],
			[Edition],
			[Config],
			[MinValue],
			[MaxValue],
			[Config_Value],
			[Run_Value],
			[DtInfo]
FROM		[monitoramento].[dbo].[SERVER_AUDIT]
WHERE		DATEDIFF(MONTH,[DtInfo],GETDATE()) = 0