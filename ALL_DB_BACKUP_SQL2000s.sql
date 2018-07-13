------------------------------------------------------------------------------------------------
/* Script para realizar Backup de todas as bases de um servidor SQL Server 2000
** Objetivo: Gerar o backup de todas as bases de um servidor SQL Server 2000
** Autor: Paulo Cesar Benjamin Junior
** Data de criação: 02/05/2018.
*/
------------------------------------------------------------------------------------------------

DECLARE @date AS NVARCHAR(15),
		@dbname AS NVARCHAR(100),
		@filename AS NVARCHAR(100),
		@bak AS NVARCHAR(100),
		@zip AS NVARCHAR(100),
		@path AS NVARCHAR(200),
		@backup AS NVARCHAR(500),
		@zipado AS NVARCHAR(500),
		@del1 AS NVARCHAR(500),
		@result AS INT,
		@msg AS	NVARCHAR(100);


/*CURSOR PARA EXECUÇÃO DA SOLUÇÃO DE BACKUP DE TODOS OS BANCOS DA INSTANCIA*/
DECLARE dbName CURSOR FOR
SELECT		name
FROM		dbo.sysdatabases
WHERE		name NOT IN ('model','tempdb')
--AND			name IN ('master')
--AND			name > 'produtos'
ORDER BY	name

	OPEN dbName
	FETCH NEXT FROM dbName
		INTO @dbname

		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @@SERVERNAME = 'RINM02S'
					SET		@path = 'D:\MSSQL7\Backup_Consolidado\RINM02S\'
				IF @@SERVERNAME = 'RINM02S\SSIS'
					SET		@path = 'D:\MSSQL7\Backup_Consolidado\SSIS\'
				IF @@SERVERNAME = 'RORQSQL01S'
					SET		@path = 'D:\MSSQL\Backup_Consolidado\'
				IF @@SERVERNAME = 'REPMSQL02S'
					SET		@path = 'E:\MSSQL7\Backup\'
				IF @@SERVERNAME = 'XINM01S'
					SET		@path = 'D:\Mssql7\BACKUP\Backup Consolidado\'
				IF @@SERVERNAME = 'RWEB02S'
					SET		@path = 'D:\MSSQL7\backup\Backup Consolidado'

				/*DATA PARA MARCADOR DO NOME DO ARQUIVO DE BACKUP*/
				SET		@date = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(30), GETDATE(), 120),'-',''),':',''),' ','_');
				
				/*CAMINHO DE ARMAZENAMENTO DO BACKUP*/
				SET		@path = @path+@dbname;

				/*DEFINIÇÃO DO NOME DOS ARQUIVOS DE BACKUP E DE BACKUP COMPACTADO*/
				SET		@filename = 'bkp_'+@dbname+'_'+@date;
				SET		@bak = @filename+'.bak'
				SET		@zip = @filename+'.zip'

				/*LINHA DE COMANDO DE EXECUÇÃO DO BACKUP*/
				SET		@backup = 'BACKUP DATABASE '+@dbname+' TO DISK='''+@path+'\'+@bak+'''
				WITH NOFORMAT, NOINIT,  NAME = N'''+@filename+''', SKIP, REWIND, NOUNLOAD,  STATS = 10'

				/*LINHA DE COMANDO PARA COMPACTAR O BACKUP*/
				SET		@zipado = 'C:\Progra~1\7-Zip\7z.exe a "'+@path+'\'+@zip+'" "'+@path+'\'+@bak+'"'

				/*LINHA DE COMANDO PARA DELEÇÃO DO ARQUIVO .BAK APÓS A COMPACTAÇÃO DESTE*/
				SET		@del1 = 'DEL "'+@path+'\'+@bak+'"'

				/*LINHA DE COMANDO PARA DELEÇÃO DO ARQUIVO DE BACKUP COMPACTADO NO SERVIDOR DE ORIGEM*/
				--SET		@del2 = 'DEL "'+@path+@zip+'"'

				SET		@msg = 'BKPError: Erro ao realizar o backup da base '+@dbname

				/*-----------------------------------INICIO DA EXECUÇÃO DOS COMANDOS-----------------------------------*/

				

				/*EXECUTA O BACKUP*/
				EXEC @result = dbo.sp_executesql @backup;
				IF @result <> 0
					BEGIN
						RAISERROR(@msg,11,1) WITH LOG;
						FETCH NEXT FROM dbName
							INTO @dbname;
					END
				ELSE
					BEGIN
						
						/*COMPACTA O ARQUIVO*/
						EXEC @result = master.dbo.xp_cmdshell @zipado;
						IF @result = 1
							BEGIN
								RAISERROR('BKPError: Erro ao compactar o arquivo de backup',11,1) WITH LOG;
								FETCH NEXT FROM dbName
									INTO @dbname;
							END
						ELSE
							BEGIN
						
								/*DELETA O ARQUIVO ORIGINAL CASO A COMPACTAÇÃO OCORRA SEM ERROS*/
								EXEC @result = master.dbo.xp_cmdshell @del1
								IF @result = 1
									BEGIN
										RAISERROR('BKPError: Erro ao deletar o arquivo original de backup',11,2) WITH LOG;
										FETCH NEXT FROM dbName
											INTO @dbname;
									END
							END

					END
					FETCH NEXT FROM dbName
						INTO @dbname;
			END
	CLOSE dbName;
DEALLOCATE dbName;