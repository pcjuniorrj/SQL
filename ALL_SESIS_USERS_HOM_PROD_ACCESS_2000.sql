DECLARE		@cmd NVARCHAR(4000),
			@db sysname,
			@usr sysname

DECLARE dbC CURSOR FOR
SELECT		name
FROM		master.dbo.sysdatabases d
WHERE		dbid > 5
ORDER BY	name;

	OPEN dbC;

		FETCH NEXT FROM dbC
		INTO @db

			WHILE @@FETCH_STATUS = 0
				
				BEGIN

					PRINT	'USE ['+@db+'];'+CHAR(10);

					DECLARE usrC CURSOR FOR
					SELECT		name
					FROM		syslogins
					WHERE		isntuser = 1
					AND			sysadmin = 0
					AND			name LIKE 'INMETRO\%'
					AND			name IN	(
											'INMETRO\calvesaraujo',
											--'INMETRO\jcfigueira',
											'INMETRO\lpcorrea',
											'INMETRO\malmeida',
											'INMETRO\oneto',
											'INMETRO\pbarroso'--,
											--'INMETRO\preis',
											--'INMETRO\wslima'
										)
					ORDER BY	name

						OPEN usrC

							FETCH NEXT FROM usrC
							INTO @usr

							WHILE @@FETCH_STATUS = 0

								BEGIN 
									
									SET @cmd =	'EXEC sp_dropuser '''+@usr+''';'+CHAR(10)+
												'EXEC sp_grantdbaccess '''+@usr+''', '''+@usr+''';'+CHAR(10)+
												'EXEC sp_addrolemember ''db_datareader'','''+@usr+''';'+CHAR(10)+
												'EXEC sp_addrolemember ''db_denydatawriter'','''+@usr+''';'+CHAR(10)+CHAR(10)+CHAR(10)

									PRINT @cmd;
							
									FETCH NEXT FROM usrC
									INTO @usr

								END

						CLOSE usrC;

					DEALLOCATE usrC;


					FETCH NEXT FROM dbC
					INTO @db;

				END

		CLOSE dbC;

DEALLOCATE dbC;





DECLARE usrC CURSOR FOR
SELECT		name
FROM		syslogins
WHERE		isntuser = 1
AND			sysadmin = 0
AND			name LIKE 'INMETRO\%'
AND			name IN	(
						'INMETRO\calvesaraujo',
						--'INMETRO\jcfigueira',
						'INMETRO\lpcorrea',
						'INMETRO\malmeida',
						'INMETRO\oneto',
						'INMETRO\pbarroso'--,
						--'INMETRO\preis',
						--'INMETRO\wslima'
					)
ORDER BY	name

	OPEN usrC

		FETCH NEXT FROM usrC
		INTO @usr

		PRINT 'USE [tempdb]'

		WHILE @@FETCH_STATUS = 0

			BEGIN
									
				SET @cmd =	'EXEC sp_dropuser '''+@usr+''';'+CHAR(10)+
							'EXEC sp_grantdbaccess '''+@usr+''', '''+@usr+''';'+CHAR(10)+
							'EXEC sp_addrolemember ''db_owner'','''+@usr+''';'+CHAR(10);

				PRINT @cmd;
							
				FETCH NEXT FROM usrC
				INTO @usr

			END

	CLOSE usrC;

DEALLOCATE usrC;