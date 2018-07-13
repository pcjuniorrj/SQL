------------------------------------------------------------------------------------------------
/* Script para realizar Backup de todas as bases de um servidor SQL Server a partir do 2008
** Objetivo: Gerar o backup de todas as bases de um servidor SQL Server a partir do 2008
** Autor: Paulo Cesar Benjamin Junior
** Data de criação: 02/05/2018.
*/
------------------------------------------------------------------------------------------------

DECLARE @date AS NVARCHAR(15),
		@dbname AS NVARCHAR(100),
		@filename AS NVARCHAR(100),
		@bak AS NVARCHAR(100),
		@path AS NVARCHAR(200),
		@backup AS NVARCHAR(500),
		@result AS INT,
		@msg AS	NVARCHAR(100);
		

DECLARE dbName CURSOR FOR
SELECT		name
FROM		sys.sysdatabases
WHERE		name NOT IN ('tempdb')
--AND			name IN ('Tz0Cycle')
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
												
				/*DATA PARA MARCADOR DO NOME DO ARQUIVO DE BACKUP*/
				SET		@date = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(30), GETDATE(), 120),'-',''),':',''),' ','_');
				
				/*CAMINHO DE ARMAZENAMENTO DO BACKUP*/
				SET		@path = @path+@dbname;

				/*DEFINIÇÃO DO NOME DOS ARQUIVOS DE BACKUP*/
				SET		@filename = 'bkp_'+@dbname+'_'+@date;
				SET		@bak = @filename+'.bak'

				/*LINHA DE COMANDO DE EXECUÇÃO DO BACKUP*/
				SET		@backup = 'BACKUP DATABASE '+@dbname+' TO DISK='''+@path+'\'+@bak+'''
				WITH NOFORMAT, NOINIT,  NAME = N'''+@filename+''', SKIP, REWIND, NOUNLOAD, COMPRESSION,  STATS = 10'

				/*DEFINIÇÃO DA MENSAGEM DE ERRO DE BACKUP DE UMA BASE ESPECÍFICA*/
				SET		@msg = 'BKPError: Erro ao realizar o backup da base '+@dbname

				/*-----------------------------------INICIO DA EXECUÇÃO DOS COMANDOS-----------------------------------*/

				

				/*EXECUTA O BACKUP*/
				BEGIN TRY
					EXEC @result = dbo.sp_executesql @backup;
				END TRY
				BEGIN CATCH
					RAISERROR(@msg,11,1) WITH LOG;
				END CATCH
				FETCH NEXT FROM dbName
					INTO @dbname;

			END
	CLOSE dbName;
DEALLOCATE dbName;