select		p.spid, 
			p.blocked, 
			p.cmd, 
			p.cpu, 
			p.memusage, 
			p.physical_io,
			p.hostname,
			p.loginame,
			q.text query
from		sys.sysprocesses p
cross apply	sys.dm_exec_sql_text(p.sql_handle) q
where		DB_NAME(p.dbid) = 'orquestra'
order by	p.cpu desc, memusage desc, physical_io desc



SELECT		*
FROM		SYS.sysprocesses


SELECT		*
FROM		Monitoramento..CONTROLE_LOG

DBCC SQLPERF(LOGSPACE);
GO

SELECT		*
FROM		sys.sysfiles




  select DB_NAME() AS DbName, 
    CONVERT(varchar(20),DatabasePropertyEx('orquestra','Status')) ,  
    CONVERT(varchar(20),DatabasePropertyEx('orquestra','Recovery')),  
sum(size)/128.0 AS File_Size_MB, 
sum(CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT))/128.0 as Space_Used_MB, 
SUM( size)/128.0 - sum(CAST(FILEPROPERTY(name,'SpaceUsed') AS INT))/128.0 AS Free_Space_MB  
from sys.database_files  where type=0 group by type



select DB_NAME() AS DbName, 
sum(size)/128.0 AS Log_File_Size_MB, 
sum(CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT))/128.0 as log_Space_Used_MB, 
SUM( size)/128.0 - sum(CAST(FILEPROPERTY(name,'SpaceUsed') AS INT))/128.0 AS log_Free_Space_MB  
from sys.database_files  where type=1 group by type