DECLARE @db nvarchar(255)
DECLARE dbCursor CURSOR FOR
SELECT		DBase
FROM		Monitoramento.dbo.LOG_AUDIT
WHERE		LOG_Used > 90
ORDER BY	DBase

	OPEN dbCursor

		FETCH NEXT FROM dbCursor
		INTO @db
		WHILE @@FETCH_STATUS = 0
			BEGIN

				DECLARE @dir nvarchar(255), @name nvarchar(255), @sql nvarchar(255)
				
				PRINT '
				Iniciando backup da base '+@db+'
				'

				SET @dir = 'D:\Mssql7\BACKUP\Backup Log\'+@db+'\'+@db+'_tlog_'+LEFT(REPLACE(REPLACE(REPLACE(CONVERT(varchar(40),getdate(),121),'-',''),' ',''),':',''),12)+'.bak'
				SET @name = @db+'_Transaction_Log_Backup'
				SET @sql = '
				 BACKUP LOG ['+@db+']
				 TO  DISK = '''+@dir+'''
				 WITH NOFORMAT, NOINIT, 
				 NAME = '''+@db+''', SKIP, NOREWIND, NOUNLOAD,  STATS = 10;'
				
				EXEC sp_executesql @sql
				
				PRINT '
				Backup da base '+@db+' finalizado
				'
				
							

			FETCH NEXT FROM dbCursor
			INTO @db
			END
	CLOSE dbCursor;
DEALLOCATE dbCursor;




