DECLARE		@dbname sysname,
			@path nvarchar(500),
			@name nvarchar(500),
			@cmd nvarchar(2000),
			@msg nvarchar(500),
			@result int


DECLARE dbCursor CURSOR FOR
SELECT		name
FROM		sys.databases
WHERE		name NOT IN ('tempdb')
AND			recovery_model = 1
ORDER BY	name;

	OPEN dbCursor

		FETCH NEXT FROM dbCursor
			INTO @dbname

		WHILE @@FETCH_STATUS = 0
			BEGIN
				
				/*DEFINE CAMINHO DE DESTINO DO ARMAZENAMENTO DOS BACKUPS*/
				IF @@SERVERNAME = 'RINM02S'
					SET @path = N'D:\MSSQL7\Backup Log\RINM02S\'+@dbname
				IF @@SERVERNAME = 'RINM02S\SSIS'
					SET @path = N'D:\MSSQL7\Backup Log\SSIS\'+@dbname
				IF @@SERVERNAME = 'RORQSQL01S'
					SET @path = N'D:\MSSQL\Backup\LogTran\'+@dbname
				IF @@SERVERNAME = 'RDES01S'
					SET @path = 'F:\MSSQL7\BackupLog\'+@dbname
				
				/*DEFINE NOME DO BACKUP*/
				SET			@name = @dbname+'_backup_'+REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19), GETDATE(),120),'-','_'),' ','_'),':','');
				
				/*SETA O COMANDO DE BACKUP LOG*/
				SET			@cmd =	'BACKUP LOG '+@dbname+
									' TO  DISK = N'''+@path+'\'+@name+'.trn'''+
									' WITH NOFORMAT, NOINIT,  NAME = N'''+@name+''', SKIP, REWIND, NOUNLOAD, COMPRESSION,  STATS = 10'
				
				EXEC @result = master.dbo.xp_create_subdir @path
				IF @result = 0
					BEGIN	
				
						BEGIN TRY
							EXEC sp_executesql @cmd
						END TRY
						BEGIN CATCH
							/*DEFINIÇÃO DA MENSAGEM DE ERRO DE BACKUP DE UMA BASE ESPECÍFICA*/
							SET		@msg = 'BKPError: Erro ao realizar o backuplog da base '+@dbname
							RAISERROR(@msg,11,1) WITH LOG;
						END CATCH

					END
				ELSE
					BEGIN
					
						/*DEFINIÇÃO DA MENSAGEM DE ERRO DE BACKUP DE UMA BASE ESPECÍFICA*/
						SET		@msg = 'BKPError: Erro ao criar subdiretorio para o backuplog da base '+@dbname
						RAISERROR(@msg,11,2) WITH LOG;
				
					END
				
				FETCH NEXT FROM dbCursor
					INTO @dbname;

			END

	CLOSE dbCursor;
DEALLOCATE dbCursor;