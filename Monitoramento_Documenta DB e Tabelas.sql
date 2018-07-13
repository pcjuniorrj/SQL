-------------------------------------------------------------------------------------------------------------------------
--                                                                                                                     --
--  CREATE DAS TABELAS DE DOCUMENTAÇÃO E MONITORAMENTO DAS INSTANCIAS SQL SERVER                                       --
--  AUTHOR: PAULO CESAR BENJAMIN JUNIOR                                                                                --
--  CREATION: 06/03/2018                                                                                               --
--                                                                                                                     --
-------------------------------------------------------------------------------------------------------------------------


/*----------------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------CREATE DATABASE AND TABLES----------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------------------*/

IF NOT EXISTS(select * from sys.databases where name='Monitoramento')
CREATE DATABASE Monitoramento;

USE Monitoramento;

IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'dbmonitor')
DROP USER [dbmonitor]
GO
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'dbmonitor')
DROP LOGIN [dbmonitor]
GO
CREATE LOGIN [dbmonitor] WITH PASSWORD=N'dbmonitor', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [monitoramento]
GO
CREATE USER [dbmonitor] FOR LOGIN [dbmonitor] WITH DEFAULT_SCHEMA=[dbo]
GO


USE Monitoramento;
GO

IF  OBJECT_ID(N'[dbo].[LOGIN_AUDIT]')IS NOT NULL
DROP TABLE [dbo].[LOGIN_AUDIT]
GO
CREATE TABLE [dbo].[LOGIN_AUDIT](
	[Server] [nvarchar](128) NULL,
	[name] [sysname] NULL,
	[createdate] [datetime] NULL,
	[updatedate] [datetime] NULL,
	[denylogin] [int] NULL,
	[hasaccess] [int] NULL,
	[NT_Name] [int] NULL,
	[NT_Group] [int] NULL,
	[NT_User] [int] NULL,
	[sysadmin] [int] NULL,
	[securityadmin] [int] NULL,
	[serveradmin] [int] NULL,
	[setupadmin] [int] NULL,
	[processadmin] [int] NULL,
	[diskadmin] [int] NULL,
	[dbcreator] [int] NULL,
	[bulkadmin] [int] NULL,
	[DtInfo] [datetime] NULL
) ON [PRIMARY]
GO

IF  OBJECT_ID(N'[dbo].[DBASES_AUDIT]')IS NOT NULL
DROP TABLE [dbo].[DBASES_AUDIT]
GO
CREATE TABLE [dbo].[DBASES_AUDIT](
	[Server] [nvarchar](255) NULL,
	[Dbase] [nvarchar](255) NULL,
	[Compatibility_Level] [tinyint] NULL,
	[Recovery_Mode] [nvarchar](128),
	[State] [nvarchar](255) NULL,
	[UserAccess] [nvarchar](255) NULL,
	[Mode] [nvarchar](255) NULL,
	[Name] [sysname] NULL,
	[physical_name] [nvarchar](300) NULL,
	[type_desc] [nvarchar](255) NULL,
	[Max_Size] [float] NULL,
	[Size] [float] NULL,
	[SpaceUsed] [float] NULL,
	[FreeSpace] [float] NULL,
	[growth] [float] NULL,
	[DtInfo] [datetime] NULL
) ON [PRIMARY]
GO

IF OBJECT_ID(N'[dbo].[LOCKS_AUDIT]') IS NOT NULL
DROP TABLE [dbo].[LOCKS_AUDIT]
GO
CREATE TABLE [dbo].[LOCKS_AUDIT](
	[Duration] [varchar](15) NULL,
	[session_id] [smallint] NULL,
	[command] [nvarchar](16) NULL,
	[sql_text] [nvarchar](max) NULL,
	[sql_command] [nvarchar](max) NULL,
	[login_name] [nvarchar](128) NULL,
	[wait_info] [nvarchar](4000) NULL,
	[CPU] [int] NULL,
	[tempdb_allocations] [bigint] NULL,
	[tempdb_current] [bigint] NULL,
	[reads] [bigint] NULL,
	[writes] [bigint] NULL,
	[physical_reads] [bigint] NULL,
	[used_memory] [int] NULL,
	[blocking_session_id] [smallint] NULL,
	[blocked_session_count] [int] NULL,
	[deadlock_priority] [varchar](12) NULL,
	[row_count] [bigint] NULL,
	[open_transaction_count] [int] NULL,
	[transaction_isolation_level] [varchar](15) NULL,
	[status] [nvarchar](30) NULL,
	[percent_complete] [real] NULL,
	[host_name] [nvarchar](128) NULL,
	[DBase] [nvarchar](128) NULL,
	[program_name] [nvarchar](128) NULL,
	[resource_governor_group] [nvarchar](256) NULL,
	[start_time] [datetime] NULL,
	[login_time] [datetime] NULL,
	[request_id] [int] NULL,
	[DtInfo] [datetime]
) 
GO

IF  OBJECT_ID(N'[dbo].[GRANTS_AUDIT]')IS NOT NULL
DROP TABLE [dbo].[GRANTS_AUDIT]
GO
CREATE TABLE [dbo].[GRANTS_AUDIT](
	[Server] [nvarchar](255) NULL,
	[DBase] [nvarchar](255) NULL,
	[UserName] [sysname] NULL,
	[PerType] [nvarchar](255) NULL,
	[Permission] [nvarchar](255) NULL,
	[SchemaName] [nvarchar](255) NULL,
	[ObjectName] [sysname] NULL,
	[DtInfo] [datetime] NULL
) ON [PRIMARY]
GO

IF OBJECT_ID('dbo.PRE_GRANTS') IS NOT NULL
DROP TABLE [dbo].[PRE_GRANTS]
GO
CREATE TABLE [dbo].[PRE_GRANTS](
	[Server] sysname NULL,
	[DBase] sysname NULL,
	[UserName] sysname NULL,
	[PerType] nvarchar(255) NULL,
	[Permission] nvarchar(255) NULL,
	[Schema] nvarchar(255) NULL,
	[ObjectName] nvarchar(255) NULL,
	[DtInfo] datetime NULL
) ON [PRIMARY]
GO

IF  OBJECT_ID(N'[dbo].[ROLE_MEMBERS_AUDIT]')IS NOT NULL
DROP TABLE [dbo].[ROLE_MEMBERS_AUDIT]
GO
CREATE TABLE [dbo].[ROLE_MEMBERS_AUDIT](
	[Server] [nvarchar](255) NULL,
	[Database] [nvarchar](255) NULL,
	[DatabaseRoleName] [sysname] NULL,
	[DatabaseUserName] [sysname] NULL,
	[DtInfo] [datetime] NULL
) ON [PRIMARY]
GO

IF  OBJECT_ID(N'[dbo].[SERVER_AUDIT]')IS NOT NULL
DROP TABLE [dbo].[SERVER_AUDIT]
GO
CREATE TABLE [dbo].[SERVER_AUDIT](
	[Server] [nvarchar](255) NULL,
	[Version] [nvarchar](255) NULL,
	[Edition] [nvarchar](255) NULL,
	[Config] [nvarchar](255) NULL,
	[MinValue] [int] NULL,
	[MaxValue] [int] NULL,
	[Config_Value] [int] NULL,
	[Run_Value] [int] NULL,
	[DtInfo] [datetime] NULL
) ON [PRIMARY]
GO

IF  OBJECT_ID(N'[dbo].[LINKSRV_AUDIT]')IS NOT NULL
DROP TABLE [dbo].[LINKSRV_AUDIT]
GO
CREATE TABLE [dbo].[LINKSRV_AUDIT](
	[Server] [nvarchar](255) NULL,
	[LSName] [sysname] NULL,
	[LSProvider] [sysname] NULL,
	[LSSource] [nvarchar](4000) NULL,
	[LSSourceLogin] [sysname] NULL,
	[DtInfo] [datetime] NULL
) ON [PRIMARY]
GO

IF  OBJECT_ID(N'[dbo].[JOBS_STEPS_AUDIT]')IS NOT NULL
DROP TABLE [dbo].[JOBS_STEPS_AUDIT]
GO
CREATE TABLE [dbo].[JOBS_STEPS_AUDIT](
	[Server] [nvarchar](4000) NULL,
	[JobName] [sysname] NULL,
	[IsEnabled] [varchar](4000) NULL,
	[JobCreatedOn] [datetime] NULL,
	[JobLastModifiedOn] [datetime] NULL,
	[StepNo] [int] NULL,
	[StepName] [sysname] NULL,
	[JobOwner] [varchar](4000) NULL,
	[JobCategory] [sysname] NULL,
	[JobDescription] [nvarchar](4000) NULL,
	[StepType] [nvarchar](4000) NULL,
	[RunAs] [varchar](4000) NULL,
	[Database] [sysname] NULL,
	[ExecutableCommand] [nvarchar](4000) NULL,
	[OnSuccessAction] [nvarchar](4000) NULL,
	[RetryAttempts] [int] NULL,
	[RetryInterval (Minutes)] [int] NULL,
	[OnFailureAction] [nvarchar](4000) NULL,
	[IsScheduled] [varchar](4000) NULL,
	[JobScheduleName] [sysname] NULL,
	[ScheduleType] [varchar](4000) NULL,
	[Occurrence] [varchar](4000) NULL,
	[Recurrence] [varchar](4000) NULL,
	[Frequency] [varchar](4000) NULL,
	[ScheduleUsageStartDate] [varchar](4000) NULL,
	[ScheduleUsageEndDate] [varchar](4000) NULL,
	[ScheduleCreatedOn] [datetime] NULL,
	[ScheduleLastModifiedOn] [varchar](4000) NULL,
	[JobDeletionCriterion] [varchar](4000) NULL,
	[DtInfo] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

IF  OBJECT_ID(N'[dbo].[DISKS_AUDIT]')IS NOT NULL
DROP TABLE [dbo].[DISKS_AUDIT]
GO
CREATE TABLE [dbo].[DISKS_AUDIT](
	[Server] [nvarchar](255) NULL,
	[Drive] [varchar](2) NULL,
	[FreeSpace] [float] NULL,
	[Size] [float] NULL,
	[FreePercent] [float] NULL,
	[DtInfo] [datetime] NULL
) ON [PRIMARY]
GO

IF  OBJECT_ID(N'[dbo].[INDEX_AUDIT]')IS NOT NULL
DROP TABLE [dbo].[INDEX_AUDIT]
GO
CREATE TABLE [INDEX_AUDIT](
	[Server] [varchar](255) NULL,
	[DBase] [varchar](255) NULL,
	[Schema] [varchar](255) NULL,
	[Object] [nvarchar](255) NULL,
	[Index] [sysname] NULL,
	[PercentFrag] [float] NULL,
	[Pages] [bigint] NULL,
	[DtInfo] [datetime] NULL
) ON [PRIMARY]
GO

IF  OBJECT_ID(N'[dbo].[JOB_EXEC_AUDIT]') IS NOT NULL
DROP TABLE [dbo].[JOB_EXEC_AUDIT]
GO
CREATE TABLE [dbo].[JOB_EXEC_AUDIT](
	[Server] [nvarchar](255) NULL,
	[Job] [sysname] NULL,
	[JobStatus] [tinyint] NULL,
	[Run_Status] [nvarchar](10),
	[IsScheduled] [int] NULL,
	[ScheduleStatus] [int] NULL,
	[run_date] [datetime] NULL,
	[run_time] [varchar](255) NULL,
	[Duration] [varchar](255) NULL,
	[DtInfo] [datetime] NULL
) ON [PRIMARY]
GO

IF OBJECT_ID(N'[dbo].[LOG_AUDIT]') IS NOT NULL
DROP TABLE [dbo].[LOG_AUDIT]
GO
CREATE TABLE	[dbo].[LOG_AUDIT](
				[DBase] [varchar](100) NULL,
				[LOG_Size] [float] NULL,
				[LOG_Used] [float] NULL,
				[LOG_Status] [float] NULL,
				[DtInfo] [datetime]
) 
GO



/*----------------------------------------------------------------------------------------------------------------------*/
/*--------------------------POPPULANDO DADOS NAS TABELAS DE AUDITORIA E DE MONITORAMENTO DO DB--------------------------*/
/*----------------------------------------------------------------------------------------------------------------------*/

/*---------------------
LOGIN AUDIT
---------------------*/
USE master;

IF SUBSTRING(@@VERSION,CHARINDEX('20',@@VERSION),4) = '2000'
	BEGIN
		
		DELETE		[monitoramento].[dbo].[LOGIN_AUDIT]
		WHERE		DATEDIFF(DAY,DtInfo,GETDATE()) <= 7
		
		INSERT INTO	[monitoramento].[dbo].[LOGIN_AUDIT]
		SELECT		@@SERVERNAME [Server],
					name,
					createdate, 
					updatedate,
					denylogin, 
					hasaccess, 
					isntname NT_Name, 
					isntgroup NT_Group, 
					isntuser NT_User, 
					sysadmin, 
					securityadmin, 
					serveradmin, 
					setupadmin, 
					processadmin, 
					diskadmin, 
					dbcreator, 
					bulkadmin,
					GETDATE() DtInfo
		FROM		dbo.syslogins			
		WHERE		(name not like 'NT A%'
		AND			 name not like 'NT S%'
		AND			 name not like '##%')
		
	END
ELSE
	BEGIN

		DELETE		[monitoramento].[dbo].[LOGIN_AUDIT]
		WHERE		DATEDIFF(DAY,DtInfo,GETDATE()) <= 7
		
		INSERT INTO	[monitoramento].[dbo].[LOGIN_AUDIT]
		SELECT		@@SERVERNAME [Server],
					name,
					createdate, 
					updatedate,
					denylogin, 
					hasaccess, 
					isntname NT_Name, 
					isntgroup NT_Group, 
					isntuser NT_User, 
					sysadmin, 
					securityadmin, 
					serveradmin, 
					setupadmin, 
					processadmin, 
					diskadmin, 
					dbcreator, 
					bulkadmin,
					GETDATE() DtInfo
		FROM		sys.syslogins			
		WHERE		(name not like 'NT A%'
		AND			 name not like 'NT S%'
		AND			 name not like '##%')
		
	END

/*---------------------	
DATAFILES AUDIT
---------------------*/
DELETE		[monitoramento].[dbo].[DBASES_AUDIT]
WHERE		DATEDIFF(DAY,DtInfo,GETDATE()) = 0;
EXEC sp_MSforeachdb @command1 =
'USE [?];
INSERT INTO	[monitoramento].[dbo].[DBASES_AUDIT]
Select		@@SERVERNAME [Server],
			DB_NAME() AS [DatabaseName], 
			df.Name,
			db.compatibility_level,
			db.state_desc State,
			db.user_access_desc UserAccess,
			CASE db.is_read_only
				WHEN 1 THEN ''READ ONLY''
				WHEN 0 THEN ''READ WRITE''
			END Mode,
			df.physical_name, 
			df.type_desc,
			Cast(Round(cast(df.size as decimal) * 8.0/1024.0,2) as decimal(18,2)) Size,
			Cast(Round(cast(df.max_size as decimal) * 8.0/1024.0,2) as decimal(18,2)) Max_Size,
			df.growth,
			Cast(Round(cast(df.size as decimal) * 8.0/1024.0,2) as decimal(18,2)) -
			Cast(FILEPROPERTY(df.name, ''SpaceUsed'') * 8.0/1024.0 as decimal(18,2)) As FreeSpace,
			CONVERT(DATE,GETDATE()) DtInfo
From		sys.database_files	df
INNER JOIN	sys.databases		db
ON			db.name = DB_NAME()';
GO

/*---------------------	
LOCKS AUDIT
---------------------*/
USE master;
DELETE		[Monitoramento].[dbo].[LOCKS_AUDIT]
WHERE		DATEDIFF(MINUTE,[DtInfo],GETDATE()) = 0;

INSERT INTO [Monitoramento].[dbo].[LOCKS_AUDIT](
			[Server],
			[Duration],
			[session_id],
			[command],
			[sql_text],
			[sql_command],
			[login_name],
			[wait_info],
			[CPU],
			[tempdb_allocations],
			[tempdb_current],
			[reads],
			[writes],
			[physical_reads],
			[used_memory],
			[blocking_session_id],
			[blocked_session_count],
			[deadlock_priority],
			[row_count],
			[open_transaction_count],
			[transaction_isolation_level],
			[status],
			[percent_complete],
			[host_name],
			[DBase],
			[program_name],
			[resource_governor_group],
			[start_time],
			[login_time],
			[request_id],
			[DtInfo])
SELECT		@@SERVERNAME [Server],
			RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 3600) AS VARCHAR), 2) + ':' + 
			RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 60) % 60 AS VARCHAR), 2) + ':' + 
			RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) % 60 AS VARCHAR), 2) AS Duration,
			A.session_id AS session_id,
			B.command,
			(SELECT TOP 1	SUBSTRING(X.[text], B.statement_start_offset / 2 + 1, ((
					CASE WHEN B.statement_end_offset = -1 
						THEN (LEN(CONVERT(NVARCHAR(MAX), X.[text])) * 2)
						ELSE B.statement_end_offset
					END) - B.statement_start_offset) / 2 + 1)) AS sql_text,
			X.[text] AS sql_command,
			A.login_name,
			'(' + CAST(COALESCE(E.wait_duration_ms, B.wait_time) AS VARCHAR(20)) + 'ms)' + COALESCE(E.wait_type, B.wait_type) + COALESCE((
			CASE 
						WHEN COALESCE(E.wait_type, B.wait_type) LIKE 'PAGEIOLATCH%' THEN ':' + DB_NAME(LEFT(E.resource_description, CHARINDEX(':', E.resource_description) - 1)) + ':' + SUBSTRING(E.resource_description, CHARINDEX(':', E.resource_description) + 1, 999)
						WHEN COALESCE(E.wait_type, B.wait_type) = 'OLEDB' THEN '[' + REPLACE(REPLACE(E.resource_description, ' (SPID=', ':'), ')', '') + ']'
						ELSE ''
			END), '') AS wait_info,
			COALESCE(B.cpu_time, 0) AS CPU,
			COALESCE(F.tempdb_allocations, 0) AS tempdb_allocations,
			COALESCE((CASE WHEN F.tempdb_allocations > F.tempdb_current THEN F.tempdb_allocations - F.tempdb_current ELSE 0 END), 0) AS tempdb_current,
			COALESCE(B.logical_reads, 0) AS reads,
			COALESCE(B.writes, 0) AS writes,
			COALESCE(B.reads, 0) AS physical_reads,
			COALESCE(B.granted_query_memory, 0) AS used_memory,
			NULLIF(B.blocking_session_id, 0) AS blocking_session_id,
			COALESCE(G.blocked_session_count, 0) AS blocked_session_count,
			(CASE 
						WHEN B.[deadlock_priority] <= -5 THEN 'Low'
						WHEN B.[deadlock_priority] > -5 AND B.[deadlock_priority] < 5 AND B.[deadlock_priority] < 5 THEN 'Normal'
						WHEN B.[deadlock_priority] >= 5 THEN 'High'
			 END) + ' (' + CAST(B.[deadlock_priority] AS VARCHAR(3)) + ')' AS [deadlock_priority],
			B.row_count,
			B.open_transaction_count,
			(CASE B.transaction_isolation_level
						WHEN 0 THEN 'Unspecified' 
						WHEN 1 THEN 'ReadUncommitted' 
						WHEN 2 THEN 'ReadCommitted' 
						WHEN 3 THEN 'Repeatable' 
						WHEN 4 THEN 'Serializable' 
						WHEN 5 THEN 'Snapshot'
			 END) AS transaction_isolation_level,
			A.[status],
			NULLIF(B.percent_complete, 0) AS percent_complete,
			A.[host_name],
			COALESCE(DB_NAME(CAST(B.database_id AS VARCHAR)), 'master') AS [database_name],
			A.[program_name],
			H.[name] AS resource_governor_group,
			COALESCE(B.start_time, A.last_request_end_time) AS start_time,
			A.login_time,
			COALESCE(B.request_id, 0) AS request_id,
			GETDATE() DtInfo
FROM		sys.dm_exec_sessions AS A WITH (NOLOCK)
LEFT JOIN	sys.dm_exec_requests AS B WITH (NOLOCK) ON A.session_id = B.session_id
JOIN		sys.dm_exec_connections AS C WITH (NOLOCK) ON A.session_id = C.session_id AND A.endpoint_id = C.endpoint_id
LEFT JOIN (	SELECT			session_id, 
							wait_type,
							wait_duration_ms,
							resource_description,
							ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY (CASE WHEN wait_type LIKE 'PAGEIO%' THEN 0 ELSE 1 END), wait_duration_ms) AS Ranking
			FROM			sys.dm_os_waiting_tasks) E 
ON			A.session_id = E.session_id 
AND			E.Ranking = 1
LEFT JOIN (	SELECT			session_id,
							request_id,
							SUM(internal_objects_alloc_page_count + user_objects_alloc_page_count) AS tempdb_allocations,
							SUM(internal_objects_dealloc_page_count + user_objects_dealloc_page_count) AS tempdb_current
			FROM			sys.dm_db_task_space_usage
			GROUP BY		session_id,
							request_id) F 
ON			B.session_id = F.session_id 
AND			B.request_id = F.request_id
LEFT JOIN (	SELECT			blocking_session_id,
							COUNT(*) AS blocked_session_count
			FROM			sys.dm_exec_requests
			WHERE			blocking_session_id != 0
			GROUP BY		blocking_session_id) G 
ON			A.session_id = G.blocking_session_id
OUTER APPLY sys.dm_exec_sql_text(ISNULL(B.[sql_handle], C.most_recent_sql_handle)) AS X
LEFT JOIN	sys.dm_resource_governor_workload_groups H 
ON			A.group_id = H.group_id
WHERE		A.session_id > 50
AND			A.session_id <> @@SPID
AND			(A.[status] != 'sleeping' 
OR			(A.[status] = 'sleeping' 
AND			B.open_transaction_count > 0))
AND			A.login_name NOT IN ('sa','dba','INMETRO\sql7adm','sql7adm')
AND			A.login_name NOT LIKE '%sql7adm%'
GROUP BY	RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 3600) AS VARCHAR), 2) + ':' + 
			RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 60) % 60 AS VARCHAR), 2) + ':' + 
			RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) % 60 AS VARCHAR), 2),
			A.session_id,
			B.command,
			X.[text],
			A.login_name,
			'(' + CAST(COALESCE(E.wait_duration_ms, B.wait_time) AS VARCHAR(20)) + 'ms)' + COALESCE(E.wait_type, B.wait_type) + COALESCE((
			CASE 
						WHEN COALESCE(E.wait_type, B.wait_type) LIKE 'PAGEIOLATCH%' THEN ':' + DB_NAME(LEFT(E.resource_description, CHARINDEX(':', E.resource_description) - 1)) + ':' + SUBSTRING(E.resource_description, CHARINDEX(':', E.resource_description) + 1, 999)
						WHEN COALESCE(E.wait_type, B.wait_type) = 'OLEDB' THEN '[' + REPLACE(REPLACE(E.resource_description, ' (SPID=', ':'), ')', '') + ']'
						ELSE ''
			END), ''),
			COALESCE(B.cpu_time, 0),
			COALESCE(F.tempdb_allocations, 0),
			COALESCE((CASE WHEN F.tempdb_allocations > F.tempdb_current THEN F.tempdb_allocations - F.tempdb_current ELSE 0 END), 0),
			COALESCE(B.logical_reads, 0),
			COALESCE(B.writes, 0),
			COALESCE(B.reads, 0),
			COALESCE(B.granted_query_memory, 0),
			NULLIF(B.blocking_session_id, 0),
			COALESCE(G.blocked_session_count, 0),
			(CASE 
						WHEN B.[deadlock_priority] <= -5 THEN 'Low'
						WHEN B.[deadlock_priority] > -5 AND B.[deadlock_priority] < 5 AND B.[deadlock_priority] < 5 THEN 'Normal'
						WHEN B.[deadlock_priority] >= 5 THEN 'High'
			 END) + ' (' + CAST(B.[deadlock_priority] AS VARCHAR(3)) + ')',
			B.row_count,
			B.open_transaction_count,
			(CASE B.transaction_isolation_level
						WHEN 0 THEN 'Unspecified' 
						WHEN 1 THEN 'ReadUncommitted' 
						WHEN 2 THEN 'ReadCommitted' 
						WHEN 3 THEN 'Repeatable' 
						WHEN 4 THEN 'Serializable' 
						WHEN 5 THEN 'Snapshot'
			 END),
			A.[status],
			NULLIF(B.percent_complete, 0),
			A.[host_name],
			COALESCE(DB_NAME(CAST(B.database_id AS VARCHAR)), 'master'),
			A.[program_name],
			H.[name],
			COALESCE(B.start_time, A.last_request_end_time),
			A.login_time,
			COALESCE(B.request_id, 0),
			B.statement_start_offset,
			B.statement_end_offset;
			

/*---------------------	
GRANTS AUDIT
---------------------*/
USE Monitoramento;

DELETE		Monitoramento.dbo.GRANTS_AUDIT
WHERE		DATEDIFF(DAY,[DtInfo],GETDATE()) < 7

IF SUBSTRING(@@VERSION,CHARINDEX('20',@@VERSION),4) = '2000'
	BEGIN
		declare @sql nvarchar(4000), @dbname nvarchar(100)
		truncate table Monitoramento.dbo.PRE_GRANTS
	
		DECLARE dBases CURSOR FOR
		SELECT		name
		FROM		master.dbo.sysdatabases
		ORDER BY	name
		
		OPEN dBases
		
			FETCH NEXT FROM dBases
			INTO @dbname
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @sql = 'USE ['+@dbname+']
					insert			Monitoramento.dbo.PRE_GRANTS
					select			@@servername [Server],
									table_catalog [DBase],
									u.name [UserName],
									case when p.actadd is null
										then ''DENY''
										else ''GRANT''
									end [PerType],
									case p.actmod
										when 1 then ''SELECT'' 
										when 2 then ''UPDATE'' 
										when 3 then ''SELECT,UPDATE'' 
										when 4 then ''REFERENCES'' 
										when 5 then ''SELECT, REFERENCES'' 
										when 6 then ''UPDATE,REFERENCES'' 
										when 7 then ''SELECT,UPDATE,REFERENCES'' 
										when 8 then ''INSERT'' 
										when 9 then ''SELECT,INSERT'' 
										when 10 then ''UPDATE,INSERT'' 
										when 11 then ''SELECT,UPDATE,INSERT'' 
										when 12 then ''REFERENCES,INSERT'' 
										when 13 then ''SELECT,REFERENCES,INSERT'' 
										when 14 then ''UPDATE,REFERENCES,INSERT'' 
										when 15 then ''SELECT,UPDATE,REFERENCES,INSERT'' 
										when 16 then ''DELETE'' 
										when 17 then ''SELECT,DELETE'' 
										when 18 then ''UPDATE,DELETE'' 
										when 19 then ''SELECT,UPDATE,DELETE'' 
										when 20 then ''REFERENCES,DELETE'' 
										when 21 then ''SELECT,REFERENCES,DELETE'' 
										when 22 then ''UPDATE,REFERENCES,DELETE'' 
										when 23 then ''SELECT,UPDATE,REFERENCES,DELETE'' 
										when 24 then ''INSERT,DELETE'' 
										when 25 then ''SELECT,INSERT,DELETE'' 
										when 26 then ''UPDATE,INSERT,DELETE'' 
										when 27 then ''SELECT,UPDATE,INSERT,DELETE'' 
										when 28 then ''REFERENCES,INSERT,DELETE'' 
										when 29 then ''SELECT,REFERENCES,INSERT,DELETE'' 
										when 30 then ''REFERENCES,INSERT,DELETE'' 
										when 31 then ''SELECT,UPDATE,REFERENCES,INSERT,DELETE'' 
										when 32 then ''EXECUTE''
										else	case p.actadd
													when 1 then ''SELECT'' 
													when 2 then ''UPDATE'' 
													when 3 then ''SELECT,UPDATE'' 
													when 4 then ''REFERENCES'' 
													when 5 then ''SELECT, REFERENCES'' 
													when 6 then ''UPDATE,REFERENCES'' 
													when 7 then ''SELECT,UPDATE,REFERENCES'' 
													when 8 then ''INSERT'' 
													when 9 then ''SELECT,INSERT'' 
													when 10 then ''UPDATE,INSERT'' 
													when 11 then ''SELECT,UPDATE,INSERT'' 
													when 12 then ''REFERENCES,INSERT'' 
													when 13 then ''SELECT,REFERENCES,INSERT'' 
													when 14 then ''UPDATE,REFERENCES,INSERT'' 
													when 15 then ''SELECT,UPDATE,REFERENCES,INSERT'' 
													when 16 then ''DELETE'' 
													when 17 then ''SELECT,DELETE'' 
													when 18 then ''UPDATE,DELETE'' 
													when 19 then ''SELECT,UPDATE,DELETE'' 
													when 20 then ''REFERENCES,DELETE'' 
													when 21 then ''SELECT,REFERENCES,DELETE'' 
													when 22 then ''UPDATE,REFERENCES,DELETE'' 
													when 23 then ''SELECT,UPDATE,REFERENCES,DELETE'' 
													when 24 then ''INSERT,DELETE'' 
													when 25 then ''SELECT,INSERT,DELETE'' 
													when 26 then ''UPDATE,INSERT,DELETE'' 
													when 27 then ''SELECT,UPDATE,INSERT,DELETE'' 
													when 28 then ''REFERENCES,INSERT,DELETE'' 
													when 29 then ''SELECT,REFERENCES,INSERT,DELETE'' 
													when 30 then ''REFERENCES,INSERT,DELETE'' 
													when 31 then ''SELECT,UPDATE,REFERENCES,INSERT,DELETE'' 
													when 32 then ''EXECUTE''
													else NULL
												end
									end [Permission], 					
									table_schema [Schema], 
									table_name [ObjectName],
									getdate() [DtInfo]
					from			information_schema.tables t
					inner join		dbo.sysobjects o
					on				t.table_name = o.name
					inner join		syspermissions p
					on				o.id = p.id
					inner join		dbo.sysusers u
					on				u.uid = p.grantee'
					--PRINT @sql1
					
					EXEC sp_executesql @sql
					
					FETCH NEXT FROM dBases
					INTO @dbname
					
				END
			CLOSE dBases;
		DEALLOCATE dBases;
		
		declare		@grantsf table(
					[Server] sysname,
					[DBase] sysname,
					[UserName] sysname,
					[PerType] nvarchar(255),
					[Permission] nvarchar(255),
					[Schema] nvarchar(255),
					[ObjectName] nvarchar(255),
					[DtInfo] datetime
		)
		
		insert into	@grantsf
		select		gs.[Server],
					gs.[DBase],
					gs.[UserName],
					gs.[PerType],
					'EXECUTE' [Permission],
					gs.[Schema],
					gs.[ObjectName],
					gs.[DtInfo]
		from		Monitoramento.dbo.PRE_GRANTS gs
		where		gs.[Permission] like '%EXECUTE%'

		insert into	@grantsf
		select		gs.[Server],
					gs.[DBase],
					gs.[UserName],
					gs.[PerType],
					'SELECT' [Permission],
					gs.[Schema],
					gs.[ObjectName],
					gs.[DtInfo]
		from		Monitoramento.dbo.PRE_GRANTS gs
		where		gs.[Permission] like '%SELECT%'

		insert into	@grantsf
		select		gs.[Server],
					gs.[DBase],
					gs.[UserName],
					gs.[PerType],
					'UPDATE' [Permission],
					gs.[Schema],
					gs.[ObjectName],
					gs.[DtInfo]
		from		Monitoramento.dbo.PRE_GRANTS gs
		where		gs.[Permission] like '%UPDATE%'

		insert into	@grantsf
		select		gs.[Server],
					gs.[DBase],
					gs.[UserName],
					gs.[PerType],
					'REFERENCES' [Permission],
					gs.[Schema],
					gs.[ObjectName],
					gs.[DtInfo]
		from		Monitoramento.dbo.PRE_GRANTS gs
		where		gs.[Permission] like '%REFERENCES%'

		insert into	@grantsf
		select		gs.[Server],
					gs.[DBase],
					gs.[UserName],
					gs.[PerType],
					'INSERT' [Permission],
					gs.[Schema],
					gs.[ObjectName],
					gs.[DtInfo]
		from		Monitoramento.dbo.PRE_GRANTS gs
		where		gs.[Permission] like '%INSERT%'

		insert into	@grantsf
		select		gs.[Server],
					gs.[DBase],
					gs.[UserName],
					gs.[PerType],
					'DELETE' [Permission],
					gs.[Schema],
					gs.[ObjectName],
					gs.[DtInfo]
		from		Monitoramento.dbo.PRE_GRANTS gs
		where		gs.[Permission] like '%DELETE%'


		insert into	Monitoramento.dbo.GRANTS_AUDIT([Server],[DBase],[UserName],[PerType],[Permission],[SchemaName],[ObjectName],[DtInfo])
		select		gf.[Server],gf.[DBase],gf.[UserName],gf.[PerType],gf.[Permission],gf.[Schema],gf.[ObjectName],gf.[DtInfo]
		from		@grantsf gf;
		
		truncate table Monitoramento.dbo.PRE_GRANTS
		
	END
ELSE
	BEGIN
	
		EXEC		sp_MSforeachdb @command1=
		'USE [?];
		INSERT INTO	[monitoramento].[dbo].[GRANTS_AUDIT]
		SELECT		@@SERVERNAME [Server],
					DB_NAME() [DBASE],
					usr.name AS UserName,
					CASE WHEN perm.state <> ''W'' THEN perm.state_desc ELSE ''GRANT'' END AS PerType,
					perm.permission_name [Permission],
					USER_NAME(obj.schema_id) AS SchemaName, obj.name AS ObjectName,
					GETDATE() [DtInfo]
		FROM		sys.database_permissions AS perm
		INNER JOIN	sys.objects AS obj
		ON			perm.major_id = obj.[object_id]
		INNER JOIN	sys.database_principals AS usr
		ON			perm.grantee_principal_id = usr.principal_id
		LEFT JOIN	sys.columns AS cl
		ON			cl.column_id = perm.minor_id 
		AND			cl.[object_id] = perm.major_id
		WHERE		obj.Type <> ''S''
		ORDER BY	usr.name, perm.state_desc ASC, perm.permission_name ASC;'
		
	END

--ROLES MEMBERS AUDIT
EXEC		sp_MSforeachdb @command1='
USE [?];
INSERT INTO	[monitoramento].[dbo].[ROLE_MEMBERS_AUDIT]
SELECT		@@SERVERNAME Server,
			DB_NAME() [DBASE],
			DP1.name AS DatabaseRoleName,   
			isnull (DP2.name, ''No members'') AS DatabaseUserName,
			GETDATE() [DtInfo]
FROM		sys.database_role_members AS DRM  
RIGHT JOIN	sys.database_principals AS DP1  
ON			DRM.role_principal_id = DP1.principal_id  
LEFT JOIN	sys.database_principals AS DP2  
ON			DRM.member_principal_id = DP2.principal_id  
WHERE		DP1.type = ''R''
ORDER BY	DP1.name;';
GO

/*---------------------	
SERVER AUDIT
---------------------*/
USE master;

DELETE		[monitoramento].[dbo].[SERVER_AUDIT]
WHERE		DATEDIFF(MONTH,DtInfo,GETDATE()) = 0

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

--LINKED SERVERS AUDIT
USE master;
INSERT INTO [monitoramento].[dbo].[LINKSRV_AUDIT]
SELECT		@@SERVERNAME [Server],
			name [LSName],
			provider [LSProvider],
			data_source [LSSource],
			L.remote_name [LSSourceLogin],
			GETDATE() [DtInfo]
FROM		sys.servers S
INNER JOIN	sys.linked_logins L
ON			S.server_id = L.server_id
WHERE		S.name <> @@SERVERNAME;
GO

--JOBS STEPS AUDIT
USE msdb;
INSERT INTO [monitoramento].[dbo].[JOBS_STEPS_AUDIT]
SELECT		@@SERVERNAME Server,
			[sJOB].[name] AS [JobName] ,
			CASE [sJOB].[enabled]
				WHEN 1 THEN 'Yes'
				WHEN 0 THEN 'No'
			END AS [IsEnabled] ,
			[sJOB].[date_created] AS [JobCreatedOn] ,
			[sJOB].[date_modified] AS [JobLastModifiedOn] ,
			[sJSTP].[step_id] AS [StepNo] ,
			[sJSTP].[step_name] AS [StepName] ,
			[sDBP].[name] AS [JobOwner] ,
			[sCAT].[name] AS [JobCategory] ,
			[sJOB].[description] AS [JobDescription] ,
			CASE [sJSTP].[subsystem]
				WHEN 'ActiveScripting' THEN 'ActiveX Script'
				WHEN 'CmdExec' THEN 'Operating system (CmdExec)'
				WHEN 'PowerShell' THEN 'PowerShell'
				WHEN 'Distribution' THEN 'Replication Distributor'
				WHEN 'Merge' THEN 'Replication Merge'
				WHEN 'QueueReader' THEN 'Replication Queue Reader'
				WHEN 'Snapshot' THEN 'Replication Snapshot'
				WHEN 'LogReader' THEN 'Replication Transaction-Log Reader'
				WHEN 'ANALYSISCOMMAND' THEN 'SQL Server Analysis Services Command'
				WHEN 'ANALYSISQUERY' THEN 'SQL Server Analysis Services Query'
				WHEN 'SSIS' THEN 'SQL Server Integration Services Package'
				WHEN 'TSQL' THEN 'Transact-SQL script (T-SQL)'
				ELSE sJSTP.subsystem
			END AS [StepType] ,
			[sPROX].[name] AS [RunAs] ,
			[sJSTP].[database_name] AS [Database] ,
			REPLACE(REPLACE(REPLACE([sJSTP].[command], CHAR(10) + CHAR(13), ' '), CHAR(13), ' '), CHAR(10), ' ') AS [ExecutableCommand] ,
			CASE [sJSTP].[on_success_action]
				WHEN 1 THEN 'Quit the job reporting success'
				WHEN 2 THEN 'Quit the job reporting failure'
				WHEN 3 THEN 'Go to the next step'
				WHEN 4 THEN 'Go to Step: ' + QUOTENAME(CAST([sJSTP].[on_success_step_id] AS VARCHAR(3))) + ' ' + [sOSSTP].[step_name]
			END AS [OnSuccessAction] ,
			[sJSTP].[retry_attempts] AS [RetryAttempts] ,
			[sJSTP].[retry_interval] AS [RetryInterval (Minutes)] ,
			CASE [sJSTP].[on_fail_action]
				WHEN 1 THEN 'Quit the job reporting success'
				WHEN 2 THEN 'Quit the job reporting failure'
				WHEN 3 THEN 'Go to the next step'
				WHEN 4 THEN 'Go to Step: ' + QUOTENAME(CAST([sJSTP].[on_fail_step_id] AS VARCHAR(3))) + ' ' + [sOFSTP].[step_name]
			END AS [OnFailureAction],
			CASE
				WHEN [sJOBSCH].[schedule_id] IS NULL THEN 'No'
				ELSE 'Yes'
			END AS [IsScheduled],
			[sSCH].[name] AS [JobScheduleName],
			CASE 
				WHEN [sSCH].[freq_type] = 64 THEN 'Start automatically when SQL Server Agent starts'
				WHEN [sSCH].[freq_type] = 128 THEN 'Start whenever the CPUs become idle'
				WHEN [sSCH].[freq_type] IN (4,8,16,32) THEN 'Recurring'
				WHEN [sSCH].[freq_type] = 1 THEN 'One Time'
			END [ScheduleType], 
			CASE [sSCH].[freq_type]
				WHEN 1 THEN 'One Time'
				WHEN 4 THEN 'Daily'
				WHEN 8 THEN 'Weekly'
				WHEN 16 THEN 'Monthly'
				WHEN 32 THEN 'Monthly - Relative to Frequency Interval'
				WHEN 64 THEN 'Start automatically when SQL Server Agent starts'
				WHEN 128 THEN 'Start whenever the CPUs become idle'
			END [Occurrence], 
			CASE [sSCH].[freq_type]
				WHEN 4 THEN 'Occurs every ' + CAST([freq_interval] AS VARCHAR(3)) + ' day(s)'
				WHEN 8 THEN 'Occurs every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) + ' week(s) on ' +
					CASE WHEN [sSCH].[freq_interval] & 1 = 1 THEN 'Sunday' ELSE '' END+
					CASE WHEN [sSCH].[freq_interval] & 2 = 2 THEN ', Monday' ELSE '' END+
					CASE WHEN [sSCH].[freq_interval] & 4 = 4 THEN ', Tuesday' ELSE '' END+
					CASE WHEN [sSCH].[freq_interval] & 8 = 8 THEN ', Wednesday' ELSE '' END+
					CASE WHEN [sSCH].[freq_interval] & 16 = 16 THEN ', Thursday' ELSE '' END+
					CASE WHEN [sSCH].[freq_interval] & 32 = 32 THEN ', Friday' ELSE '' END+
					CASE WHEN [sSCH].[freq_interval] & 64 = 64 THEN ', Saturday' ELSE '' END
				WHEN 16 THEN 'Occurs on Day ' + CAST([freq_interval] AS VARCHAR(3)) + ' of every ' + CAST([sSCH].[freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
				WHEN 32 THEN 'Occurs on '+
					CASE [sSCH].[freq_relative_interval]
						WHEN 1 THEN 'First'
						WHEN 2 THEN 'Second'
						WHEN 4 THEN 'Third'
						WHEN 8 THEN 'Fourth'
						WHEN 16 THEN 'Last'
					END+' '+
					CASE [sSCH].[freq_interval]
						WHEN 1 THEN 'Sunday'
						WHEN 2 THEN 'Monday'
						WHEN 3 THEN 'Tuesday'
						WHEN 4 THEN 'Wednesday'
						WHEN 5 THEN 'Thursday'
						WHEN 6 THEN 'Friday'
						WHEN 7 THEN 'Saturday'
						WHEN 8 THEN 'Day'
						WHEN 9 THEN 'Weekday'
						WHEN 10 THEN 'Weekend day'
					END +
				' of every ' + CAST([sSCH].[freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
			END AS [Recurrence], 
			CASE [sSCH].[freq_subday_type]
				WHEN 1 THEN 'Occurs once at ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
				WHEN 2 THEN 'Occurs every ' + CAST([sSCH].[freq_subday_interval] AS VARCHAR(3)) + ' Second(s) between ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')+ ' & ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_end_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
				WHEN 4 THEN 'Occurs every ' + CAST([sSCH].[freq_subday_interval] AS VARCHAR(3)) + ' Minute(s) between ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')+ ' & ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_end_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
				WHEN 8 THEN 'Occurs every ' + CAST([sSCH].[freq_subday_interval] AS VARCHAR(3)) + ' Hour(s) between ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')+ ' & ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_end_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
			END [Frequency], 
			STUFF(STUFF(CAST([sSCH].[active_start_date] AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS [ScheduleUsageStartDate], 
			STUFF(STUFF(CAST([sSCH].[active_end_date] AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS [ScheduleUsageEndDate], 
			[sSCH].[date_created] AS [ScheduleCreatedOn], 
			[sJOB].[date_modified] AS [ScheduleLastModifiedOn],
			CASE [sJOB].[delete_level]
				WHEN 0 THEN 'Never'
				WHEN 1 THEN 'On Success'
				WHEN 2 THEN 'On Failure'
				WHEN 3 THEN 'On Completion'
			END AS [JobDeletionCriterion],
			GETDATE() [DtInfo]
FROM		[msdb].[dbo].[sysjobsteps] AS [sJSTP]
			INNER JOIN [msdb].[dbo].[sysjobs] AS [sJOB] ON [sJSTP].[job_id] = [sJOB].[job_id]
			LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOSSTP] ON [sJSTP].[job_id] = [sOSSTP].[job_id] AND [sJSTP].[on_success_step_id] = [sOSSTP].[step_id]
			LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOFSTP] ON [sJSTP].[job_id] = [sOFSTP].[job_id] AND [sJSTP].[on_fail_step_id] = [sOFSTP].[step_id]
			LEFT JOIN [msdb].[dbo].[sysproxies] AS [sPROX] ON [sJSTP].[proxy_id] = [sPROX].[proxy_id]
			LEFT JOIN [msdb].[dbo].[syscategories] AS [sCAT] ON [sJOB].[category_id] = [sCAT].[category_id]
			LEFT JOIN [msdb].[sys].[database_principals] AS [sDBP] ON [sJOB].[owner_sid] = [sDBP].[sid]
			LEFT JOIN [msdb].[dbo].[sysjobschedules] AS [sJOBSCH] ON [sJOB].[job_id] = [sJOBSCH].[job_id]
			LEFT JOIN [msdb].[dbo].[sysschedules] AS [sSCH] ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id];
GO

/*---------------------	
DISKS_AUDIT
---------------------*/
USE master;
IF OBJECT_ID('tempdb..#DISKS_AUDIT') IS NOT NULL
DROP TABLE #DISKS_AUDIT
CREATE TABLE #DISKS_AUDIT(
	info varchar(255)
)

INSERT INTO #DISKS_AUDIT
EXEC master.dbo.xp_cmdshell 'wmic logicaldisk get size,freespace,caption'

DELETE [monitoramento].[dbo].[DISKS_AUDIT]
WHERE DATEDIFF(DAY,DtInfo,GETDATE())=0;

INSERT INTO [monitoramento].[dbo].[DISKS_AUDIT]
SELECT		@@SERVERNAME Server,
			LEFT(info,2) Drive,
			convert(float,SUBSTRING(info,10,13))/1024/1024 FreeSpace,
			convert(float,SUBSTRING(info,23,13))/1024/1024 Size,
			convert(decimal(5,2),(convert(float,SUBSTRING(info,10,13))/1024/1024)/(convert(float,SUBSTRING(info,23,13))/1024/1024)*100) FreePercent,
			GETDATE() [DtInfo]
FROM		#DISKS_AUDIT
WHERE		info is NOT NULL
AND			info NOT LIKE 'Caption%'
AND			info NOT LIKE ' %'
AND			convert(float,SUBSTRING(info,23,13))/1024/1024/1024 > 0;
GO

/*---------------------	
INDEX_AUDIT
---------------------*/
DELETE		[Monitoramento].[dbo].[INDEX_AUDIT]
WHERE		DATEDIFF(DAY,[DtInfo],GETDATE()) = 0

IF SUBSTRING(@@VERSION,CHARINDEX('20',@@VERSION),4) = '2000'
	BEGIN
		DECLARE @sql nvarchar(4000), @dbname sysname

		DECLARE dbCursor CURSOR FOR
		SELECT		name
		FROM		master..sysdatabases
		WHERE		dbid > 4
		AND			name NOT LIKE 'ReportSer%'

		OPEN dbCursor
			
			FETCH NEXT FROM dbCursor
			INTO @dbname
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @sql = 
					'USE ['+@dbname+'];

					IF OBJECT_ID(''tempdb..#fraglist'') IS NOT NULL
					DROP TABLE #fraglist

					CREATE TABLE	#fraglist (
									ObjectName char(255),
									ObjectId int,
									IndexName char(255),
									IndexId int,
									Lvl int,
									CountPages int,
									CountRows int,
									MinRecSize int,
									MaxRecSize int,
									AvgRecSize int,
									ForRecCount int,
									Extents int,
									ExtentSwitches int,
									AvgFreeBytes int,
									AvgPageDensity int,
									ScanDensity decimal,
									BestCount int,
									ActualCount int,
									LogicalFrag decimal,
									ExtentFrag decimal,
									[Schema] nvarchar(255) NULL,
									[Server] sysname NULL,
									[DBase] sysname NULL,
									[DtInfo] datetime NULL)

					DECLARE @tablename nvarchar(255), @schema nvarchar(255), @dbcc nvarchar(500)

					DECLARE tables CURSOR FOR
					SELECT TABLE_SCHEMA + ''.'' + TABLE_NAME, TABLE_SCHEMA
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_TYPE = ''BASE TABLE''

						OPEN tables

						FETCH NEXT FROM tables
						INTO @tablename, @schema

						WHILE @@FETCH_STATUS = 0
							BEGIN
								SET @dbcc = ''DBCC SHOWCONTIG (''+QUOTENAME(@tablename,'''''''')+'') WITH FAST, TABLERESULTS, ALL_INDEXES, NO_INFOMSGS''
								INSERT INTO #fraglist  (ObjectName,
														ObjectId,
														IndexName,
														IndexId,
														Lvl,
														CountPages,
														CountRows,
														MinRecSize,
														MaxRecSize,
														AvgRecSize,
														ForRecCount,
														Extents,
														ExtentSwitches,
														AvgFreeBytes,
														AvgPageDensity,
														ScanDensity,
														BestCount,
														ActualCount,
														LogicalFrag,
														ExtentFrag)
								EXEC (@dbcc)
								
								UPDATE		#fraglist
								SET			[Server] = @@SERVERNAME,
											[DBase] = '''+@dbname+''',
											[DtInfo] = GETDATE(),
											[Schema] = @schema
								WHERE		[Server] IS NULL
								

											
								FETCH NEXT
								FROM tables
								INTO @tablename, @schema
							END
							
						CLOSE tables;
					DEALLOCATE tables;
					
					INSERT INTO	[Monitoramento].[dbo].[INDEX_AUDIT](
								[Server],
								[DBase],
								[Schema],
								[Object],
								[Index],
								[PercentFrag],
								[Pages],
								[DtInfo])
					SELECT		[Server],
								[DBase],
								[Schema],
								[ObjectName],
								[IndexName],
								[LogicalFrag],
								[CountPages],
								[DtInfo]
					FROM		#fraglist;'
					--PRINT @sql
					EXEC sp_executesql @sql
					
					--PRINT @sql
					FETCH NEXT FROM dbCursor
					INTO @dbname
				
				END
			CLOSE dbCursor
		DEALLOCATE dbCursor
	END
ELSE
	BEGIN
	
		EXEC sp_MSforeachdb @command1 =
		'USE [?]; 

		INSERT INTO [Monitoramento].[dbo].[INDEX_AUDIT](
					[Server],
					[DBase],
					[Schema],
					[Object],
					[Index],
					[PercentFrag],
					[Pages],
					[DtInfo]
					)
		SELECT		@@SERVERNAME [Server],
					''?'' [DBase], 
					S.schema_id [Schema],
					O.name [Object],
					N.name [Index],
					I.avg_fragmentation_in_percent [PercentFrag], 
					I.page_count [Pages],
					GETDATE() [DtInfo]
		FROM		sys.dm_db_index_physical_stats(0,0,NULL,NULL, NULL) I
		INNER JOIN	sys.indexes N
		ON			I.object_id = N.object_id
		AND			I.index_id = N.index_id
		INNER JOIN	sys.objects O
		ON			I.object_id = O.object_id
		INNER JOIN	sys.schemas S
		ON			O.schema_id = S.schema_id
		WHERE		DB_NAME(I.database_id) = ''?''
		AND			I.database_id > 4
		AND			DB_NAME(I.database_id) NOT LIKE ''Report%''
		'
		
	END

DELETE		Monitoramento.dbo.INDEX_AUDIT
WHERE		[Index] IS NULL;
			
/*---------------------	
JOBS EXEC AUDIT
---------------------*/
USE msdb;


DELETE		[Monitoramento].[dbo].[JOB_EXEC_AUDIT]
--DELETE PARA CARGA INICIAL DEVE TER O WHERE COMENTADO
--WHERE		DATEDIFF(DAY,DtInfo,GETDATE()) = 0

INSERT INTO	[Monitoramento].[dbo].[JOB_EXEC_AUDIT]
SELECT		@@SERVERNAME [Server],
			J.name Job,
			J.enabled JobStatus,
			CASE WHEN JS.schedule_id IS NULL
				THEN 0
				ELSE 1
			END IsScheduled,
			SS.enabled ScheduleStatus,
			CONVERT(DATETIME,STUFF(STUFF(H.run_date,5,0,'-'),8,0,'-')) Run_Date,
			STUFF(STUFF(RIGHT('000000'+CONVERT(VARCHAR(6),H.run_time),6),3,0,':'),6,0,':') Run_Time,
			STUFF(STUFF(RIGHT(REPLICATE('0',6)+CONVERT(VARCHAR(6),H.run_duration),6),3,0,':'),6,0,':') Duration,
			--LINHA PARA CARGA INICIAL DO SERVIDOR
			CONVERT(DATETIME,STUFF(STUFF(STUFF(STUFF(STUFF(CONVERT(VARCHAR(8),H.run_date)+RIGHT('000000'+CONVERT(VARCHAR(8),H.run_time),6),5,0,'-'),8,0,'-'),11,0,' '),14,0,':'),17,0,':')) [DtInfo]
			--LINHA PARA CARGA DIARIA
			--GETDATE() [DtInfo]
FROM		msdb.dbo.sysjobs J
LEFT JOIN	msdb.dbo.sysjobschedules JS
ON			J.job_id = JS.job_id
LEFT JOIN	msdb.dbo.sysschedules SS
ON			JS.schedule_id = SS.schedule_id
INNER JOIN	msdb.dbo.sysjobhistory H
ON			J.job_id = J.job_id
--WHERE DEVE SER COMENTADO PARA CARGA INICIAL
WHERE		H.step_id = 0
--COMENTAR AS PROXIMAS LINHAS DO WHERE PARA CARGA INICIAL. WHERE LIMITA AOS JOBS EXECUTADOS DAS 07:00:00 DO DIA ANTERIOR ATÉ ANTES DAS 07:00:00 DO DIA ATUAL
AND			CONVERT(DATETIME,STUFF(STUFF(STUFF(STUFF(STUFF(CONVERT(VARCHAR(8),H.run_date)+RIGHT('000000'+CONVERT(VARCHAR(8),H.run_time),6),5,0,'-'),8,0,'-'),11,0,' '),14,0,':'),17,0,':'))
			>= CONVERT(DATETIME,REPLACE(CONVERT(VARCHAR(10),DATEADD(DAY,-1,GETDATE()),102),'.','-')+' 07:00:00')
AND			CONVERT(DATETIME,STUFF(STUFF(STUFF(STUFF(STUFF(CONVERT(VARCHAR(8),H.run_date)+RIGHT('000000'+CONVERT(VARCHAR(8),H.run_time),6),5,0,'-'),8,0,'-'),11,0,' '),14,0,':'),17,0,':'))
			< CONVERT(DATETIME,REPLACE(CONVERT(VARCHAR(10),GETDATE(),102),'.','-')+' 07:00:00');
GO


/*


USE Monitoramento


SELECT * FROM LOGIN_AUDIT
SELECT * FROM DBASES_AUDIT
SELECT * FROM LOCK_AUDIT
SELECT * FROM GRANTS_AUDIT
SELECT * FROM ROLE_MEMBERS_AUDIT
SELECT * FROM SERVER_AUDIT
SELECT * FROM LINKSRV_AUDIT
SELECT * FROM JOBS_STEPS_AUDIT
SELECT * FROM DISKS_AUDIT
SELECT * FROM INDEX_AUDIT
SELECT * FROM JOB_EXEC_AUDIT

USE monitoramento;

DELETE		DISKS_AUDIT
WHERE		DATEDIFF(DAY,DtInfo,GETDATE())= 0

SELECT		*
FROM		DISKS_AUDIT
WHERE		DATEDIFF(DAY,DtInfo,GETDATE())= 0

IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'JobExec')
DROP LOGIN [JobExec]
GO
CREATE LOGIN [JobExec] WITH PASSWORD=N'!#sql19420115bang#', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
EXEC sp_addsrvrolemember 'JobExec', 'sysadmin'


--TABLE SPACEUSED
USE Monitoramento;

DECLARE @tbname nvarchar(255), @exec nvarchar(255)
DECLARE tbSpaces CURSOR FOR
SELECT		so.name
FROM		sys.sysobjects so
WHERE		so.xtype = 'U'
AND			so.name LIKE '%_AUDIT'
ORDER BY	so.name

	OPEN tbSpaces
		FETCH NEXT FROM tbSpaces
		INTO @tbname
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @exec = 'sp_spaceused '+QUOTENAME(@tbname,'''')
				PRINT @exec
				EXEC sp_executesql @exec
			
				FETCH NEXT FROM tbSpaces
				INTO @tbname
			END
	CLOSE tbSpaces;
DEALLOCATE tbSpaces;



*/