DECLARE @copy_cmd nvarchar(250),
		@zip_cmd nvarchar(250),
		@db_name nvarchar(50),
		@ano nvarchar(4),
		@mes nvarchar(2),
		@dia nvarchar(2),
		@server_name nvarchar(50),
		@filename nvarchar(100),
		@cmd nvarchar(500),
		@search_path nvarchar(500),
		@restore nvarchar(50),
		@datafiles nvarchar(max),
		@logfiles nvarchar(max)



SET		@server_name = 'XINM01S'
SET		@ano = CAST(YEAR(DATEADD(DAY,-5,GETDATE())) AS nvarchar(4))
SET		@mes = CAST(MONTH(DATEADD(DAY,-5,GETDATE())) AS nvarchar(2))
SET		@dia = CAST(DAY(DATEADD(DAY,-5,GETDATE())) AS nvarchar(2))
SET		@db_name = 'agenda'
SET		@filename = 'bkp_'+@db_name+'_'+@ano+RIGHT('0'+@mes,2)+RIGHT('0'+@dia,2)
SET		@search_path = '\\10.21.251.13\Repositorio\Banco\BACKUP'
SET		@cmd = 'master.sys.xp_dirtree '''+@search_path+'\'+@server_name+'\'+@db_name+'\'+@ano+'\'+@mes+''',1,1'

SELECT		@restore = name
FROM		sys.sysdatabases
WHERE		name = @db_name

--IF	@restore IS NOT NULL
--	BEGIN

--		IF OBJECT_ID('tempdb..#filesfrom') IS NOT NULL
--			DROP TABLE #filesfrom
--		CREATE TABLE #filesfrom
--		(
--			f_name nvarchar(500),
--			depth int,
--			ffile int
--		)


--		PRINT @cmd
--		INSERT INTO #filesfrom
--		EXEC master.sys.sp_executesql @cmd

--		PRINT @filename

--		SELECT		TOP 1
--					@filename = f_name
--		FROM		#filesfrom
--		WHERE		f_name like @filename+'%'
--		ORDER BY	f_name DESC
--		IF		@server_name IN ('XINM01S','RWEB02S')
--			BEGIN
--				SET		@cmd = 'master.sys.xp_cmdshell ''del E:\bkp\'+LEFT(@filename, LEN(@filename)-20)+'*'''
--				PRINT	@cmd
--				EXEC	master.sys.sp_executesql @cmd

--				SET		@cmd = 'master.sys.xp_cmdshell ''robocopy '+@search_path+'\'+@server_name+'\'+@db_name+'\'+@ano+'\'+@mes+' E:\bkp '+@filename+' /e /eta /tee'''
--				PRINT	@cmd
--				EXEC	master.sys.sp_executesql @cmd

--				SET		@cmd = 'master.sys.xp_cmdshell ''"C:\Program Files (x86)\7-Zip\7z" e -oE:\bkp\ E:\bkp\'+@filename+' -r'''
--				PRINT	@cmd
--				EXEC	master.sys.sp_executesql @cmd

--				SET		@cmd = 'master.sys.xp_cmdshell ''del E:\bkp\'+LEFT(@filename, LEN(@filename)-20)+'*.zip'''
--				PRINT	@cmd
--				EXEC	master.sys.sp_executesql @cmd
--			END
--		ELSE
--			BEGIN

--				SET		@cmd = 'master.sys.xp_cmdshell ''del E:\bkp\'+LEFT(@filename, LEN(@filename)-20)+'*'''
--				PRINT	@cmd
--				EXEC	master.sys.sp_executesql @cmd

--				SET		@cmd = 'master.sys.xp_cmdshell ''robocopy '+@search_path+'\'+@server_name+'\'+@db_name+'\'+@ano+'\'+@mes+' E:\bkp '+@filename+' /e /eta /tee'''
--				PRINT	@cmd
--				EXEC	master.sys.sp_executesql @cmd

--			END
--	END
SET		@db_name = 'inmetro'
SET		@cmd = 'SELECT name, physical_name, type FROM '+@db_name+'.sys.database_files'

IF OBJECT_ID('tempdb..#dbfiles') IS NOT NULL
	DROP TABLE #dbfiles
CREATE TABLE #dbfiles
(
	nome nvarchar(60),
	caminho nvarchar(500),
	tipo int
)

INSERT INTO #dbfiles
EXEC sp_executesql @cmd

DECLARE @nomeC nvarchar(max),
		@caminhoC nvarchar(max),
		@tipoC int

DECLARE filesC CURSOR FOR
SELECT		nome,
			caminho,
			tipo
FROM		#dbfiles

	OPEN filesC
	FETCH NEXT FROM filesC
	INTO @nomeC, @caminhoC, @tipoC
		
		IF @tipoC = 1
			BEGIN
				SET @logfiles = @logfiles + 'MOVE N'''+RTRIM(@nomeC)+''' TO N'''+RTRIM(@caminhoC)+''','
			END


	CLOSE filesC;
DEALLOCATE filesC;
--EXEC master.sys.xp_dirtree '\\10.21.251.13\Repositorio\Banco\BACKUP\XINM01S\agenda\2018\5',1,1


--EXEC master.sys.xp_cmdshell 'robocopy \\10.21.251.13\Repositorio\Banco\BACKUP\XINM01S\agenda\2018\5 E:\bkp bkp_agenda_20180510_200005.zip /e /eta /tee'


