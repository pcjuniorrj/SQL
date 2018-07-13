DELETE		[Monitoramento].[dbo].[INDEX_AUDIT]
WHERE		DATEDIFF(DAY,[DtInfo],GETDATE()) = 0

IF SUBSTRING(@@VERSION,CHARINDEX('20',@@VERSION),4) = '2000'
	BEGIN
		DECLARE @sql nvarchar(2500), @dbname sysname

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

		INSERT INTO [Monitoramento].[dbo].[INDEX_AUDIT]
		SELECT		@@SERVERNAME [Server],
					''?'' [DBase], 
					S.schema_id [Schema],
					O.name [Object],
					N.name [Index],
					I.avg_fragmentation_in_percent [PercentFrag], 
					I.page_count [Pages],
					''USE [?];''+'' ALTER INDEX ''+N.name+'' ON ''+S.name+''.''+O.name+'' REBUILD;'',
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
WHERE		[Index] IS NULL



SELECT			[Server],
				[DBase],
				[Schema],
				[Object],
				[Index],
				[PercentFrag],
				[Pages],
				[DtInfo]
FROM			[Monitoramento].[dbo].[INDEX_AUDIT]
WHERE			DATEDIFF(DAY,[DtInfo],GETDATE()) = 0