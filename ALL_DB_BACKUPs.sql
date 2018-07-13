------------------------------------------------------------------------------------------------
/* Script para realizar Backup de todas as bases de um servidor SQL Server 2000
** Objetivo: Gerar o backup de todas as bases de um servidor SQL Server 2000
**           e mover os arquivos antigos de backup para o repositório de backups
** Autor: Paulo Cesar Benjamin Junior
** Data de criação: 02/05/2018.
*/
------------------------------------------------------------------------------------------------

DECLARE @date AS NVARCHAR(15),
		@dbname AS NVARCHAR(100),
		@bakfilename AS NVARCHAR(100),
		@filename AS NVARCHAR(100),
		@inirep AS	NVARCHAR(500),
		@endrep AS	NVARCHAR(500),
		@bak AS NVARCHAR(100),
		@zip AS NVARCHAR(100),
		@inipath AS NVARCHAR(200),
		@path AS NVARCHAR(200),
		@rep AS NVARCHAR(200),
		@backup AS NVARCHAR(500),
		@zipado AS NVARCHAR(500),
		@del1 AS NVARCHAR(500),
		@del2 AS NVARCHAR(500),
		@mov AS	NVARCHAR(500),
		@result AS INT,
		@msg AS	NVARCHAR(100);

/*STRING PARA MAPEAMENTO DA UNIDADE DE REDE DE DESTINO*/
SET		@inirep = 'NET USE R: \\10.21.251.13\Repositorio\Banco\BACKUP\'+@@SERVERNAME+' /user:"inmetro\sql7adm" "!#sql19420115bang#" /p:yes';
/*STRING PARA DELETAR O MAPEAMENTO DA UNIDADE DE REDE DE DESTINO*/
SET		@endrep = 'NET USE R: /delete';
/*STRING COM O CAMINHO INICIAL DE BACKUP DO SERVIDOR - DEVE SER ALTERADO PARA CADA SERVIDOR*/



--PRINT	@inirep;
/*EXECUÇÃO DO MAPEAMENTO DA UNIDADE DE REDE DE DESTINO*/
EXEC	master.dbo.xp_cmdshell @inirep;

/*CURSOR PARA EXECUÇÃO DA SOLUÇÃO DE BACKUP DE TODOS OS BANCOS DA INSTANCIA*/
DECLARE dbName CURSOR FOR
SELECT		name
FROM		dbo.sysdatabases
WHERE		name <> 'model'
--AND			name IN ('pif','piftreina','planest')
ORDER BY	name

	OPEN dbName
	FETCH NEXT FROM dbName
		INTO @dbname

		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @@SERVERNAME = 'RWEB02S'
					SET		@path = 'D:\MSSQL7\backup\Backup Consolidado\'
				IF @@SERVERNAME = 'XINM01S'
					SET		@path = 'D:\Mssql7\BACKUP\Backup Consolidado\'

				/*STRING COM O DIRETÓRIO DE DESTINO*/
				SET		@rep = 'R:\'	
							
				/*DATA PARA MARCADOR DO NOME DO ARQUIVO DE BACKUP*/
				SET		@date = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(30), GETDATE(), 120),'-',''),':',''),' ','_');
				
				/*CAMINHO DE ARMAZENAMENTO INICIAL DO BACKUP*/
				SET		@path = @path+@dbname;

				/*CAMINHO DE DESTINO PARA ARMAZENAMENTO DO ARQUIVO DE BACKUP COMPACTADO*/
				SET		@rep = @rep+@dbname
				--PRINT	@rep

				/*DEFINIÇÃO DO NOME DOS ARQUIVOS DE BACKUP E DE BACKUP COMPACTADO*/
				SET		@filename = 'bkp_'+@dbname+'_'+@date;
				SET		@bak = @filename+'.bak'
				SET		@zip = @filename+'.zip'

				/*LINHA DE COMANDO DE EXECUÇÃO DO BACKUP*/
				SET		@backup = 'BACKUP DATABASE '+@dbname+' TO DISK='''+@path+'\'+@bak+''''
				
				/*LINHA DE COMANDO PARA COMPACTAR O BACKUP*/
				SET		@zipado = 'C:\Progra~1\7-Zip\7z.exe a "'+@path+'\'+@zip+'" "'+@path+'\'+@bak+'"'

				/*LINHA DE COMANDO PARA DELEÇÃO DO ARQUIVO .BAK APÓS A COMPACTAÇÃO DESTE*/
				SET		@del1 = 'DEL "'+@path+'\'+@bak+'"'

				/*LINHA DE COMANDO PARA COPIA DO ARQUIVO DE BACKUP COMPACTADO PARA O REPOSITÓRIO*/
				--SET		@mov = 'robocopy "'+@path+'\" "'+@rep+'" /MOV /MINAGE:1'--"'+@zip+'"'
				--SET		@mov = 'robocopy "D:\MSSQL7\backup\Backup Consolidado\pif\" "R:\pif\" *.zip /MOV /MINAGE:1'
				SET		@mov = 'robocopy "'+@path+'" '+@rep+' /MOV /MINAGE:1'

				/*LINHA DE COMANDO PARA DELEÇÃO DO ARQUIVO DE BACKUP COMPACTADO NO SERVIDOR DE ORIGEM*/
				--SET		@del2 = 'DEL "'+@path+@zip+'"'

				SET		@msg = 'Erro ao realizar o backup da base '+@dbname

				/*-----------------------------------INICIO DA EXECUÇÃO DOS COMANDOS-----------------------------------*/

				

				/*EXECUTA O BACKUP*/
				EXEC @result = dbo.sp_executesql @backup;
				IF @result <> 0
					BEGIN
						RAISERROR(@msg,11,1);
						FETCH NEXT FROM dbName
							INTO @dbname;
					END
				ELSE
					BEGIN
						
						/*COMPACTA O ARQUIVO*/
						EXEC @result = master.dbo.xp_cmdshell @zipado;
						IF @result = 1
							BEGIN
								RAISERROR('Erro ao compactar o arquivo de backup',11,1);
								FETCH NEXT FROM dbName
									INTO @dbname;
							END
						ELSE
							BEGIN
						
								/*DELETA O ARQUIVO ORIGINAL CASO A COMPACTAÇÃO OCORRA SEM ERROS*/
								EXEC @result = master.dbo.xp_cmdshell @del1
								IF @result = 1
									BEGIN
										RAISERROR('Erro ao deletar o arquivo original de backup',11,2);
										FETCH NEXT FROM dbName
											INTO @dbname;
									END
								ELSE
									BEGIN

										/*MOVE O ARQUIVO COMPACTADO PARA O REPOSITÓRIO*/
										EXEC @result = master.dbo.xp_cmdshell @mov
										IF @result = 1
											BEGIN
												RAISERROR('Erro ao mover arquivos antigos para o repositório de backup',11,3);
												FETCH NEXT FROM dbName
													INTO @dbname;
											END
											
									END
							END

					END
					FETCH NEXT FROM dbName
						INTO @dbname;
			END
	CLOSE dbName;
DEALLOCATE dbName;

--PRINT	@endrep;

/*EXECUÇÃO DO MAPEAMENTO DA UNIDADE DE REDE DE DESTINO*/
EXEC	master.dbo.xp_cmdshell @endrep;