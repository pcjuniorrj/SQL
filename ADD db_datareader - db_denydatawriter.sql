DECLARE		@cmd		AS NVARCHAR(MAX),
			@db			AS SYSNAME,
			@name		AS SYSNAME;

DECLARE dbC	CURSOR FOR
SELECT		name--, *
FROM		sys.sysdatabases
WHERE		dbid > 6
AND			status < 68616
AND			status <> 3096--IN (8,24)-- 68616
ORDER BY	1;--name;

	OPEN dbC
		
		FETCH NEXT FROM dbC
		INTO @db

		WHILE @@FETCH_STATUS = 0
			
			BEGIN

				DECLARE usrC CURSOR FOR
				SELECT		name
				FROM		sys.syslogins
				WHERE		name IN		('INMETRO\frbrum'
										,'INMETRO\lpcorrea'
										,'INMETRO\oneto'
										,'INMETRO\wslima'              
										,'INMETRO\jcfigueira'
										,'INMETRO\mrramalho'
										,'INMETRO\preis'
										,'INMETRO\epcorreia')
				ORDER BY	name;

					OPEN usrC

						FETCH NEXT FROM usrC
						INTO @name;

						WHILE @@FETCH_STATUS = 0
							
							BEGIN

								SET		@cmd =	'USE ['+@db+']'+CHAR(10)+
												'EXEC sp_addrolemember ''db_datareader'', '''+@name+'''';

								PRINT	@db;
								EXEC(@cmd);

								SET		@cmd =	'USE ['+@db+']'+CHAR(10)+
												'EXEC sp_addrolemember ''db_denydatawriter'', '''+@name+'''';

								--PRINT	@cmd;
								EXEC(@cmd);

								FETCH NEXT FROM usrC
								INTO @name;
							
							END
					
					CLOSE usrC;

				DEALLOCATE usrC;

				FETCH NEXT FROM dbC
				INTO @db;

			END

	CLOSE dbC;

DEALLOCATE dbC;