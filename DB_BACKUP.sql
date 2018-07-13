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
FROM		sys.databases
WHERE		
--NÃO FAZ BACKUP DAS BASES DE SISTEMA (master, model, msdb, tempdb)
			database_id > 4
--NÃO FAZ BACKUP DE BASES READ ONLY
AND			is_read_only = 0
ORDER BY	name

	OPEN dbName
	FETCH NEXT FROM dbName
		INTO @dbname

		WHILE @@FETCH_STATUS = 0
			BEGIN

				IF @@SERVERNAME = 'SERVER1'
					SET		@path = 'D:\MSSQL\Backup\'
				IF @@SERVERNAME = 'SERVER2'
					SET		@path = 'G:\MSSQL\Backup\'
				IF @@SERVERNAME = 'SERVER3'
					SET		@path = 'F:\MSSQL\Backup\'
				IF @@SERVERNAME = 'SERVER4'
					SET		@path = 'E:\MSSQL\Backup\'
												
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