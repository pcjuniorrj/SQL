DECLARE		@p_count		AS BIGINT,
			@frag			AS FLOAT,
			@op				AS NVARCHAR(100),
			@ix				AS NVARCHAR(100),
			@tb				AS SYSNAME,
			@cmd			AS NVARCHAR(4000);


USE orquestra;

IF OBJECT_ID('tempdb..#ixstats') IS NOT NULL
	DROP TABLE #ixstats

SELECT		DB_NAME(iu.database_id) db,
			iu.object_id OBJ_ID,
			OBJECT_SCHEMA_NAME(iu.object_id) SCHM,
			OBJECT_NAME(iu.object_id) OBJNAME,
			i.name idx,
			iu.avg_fragmentation_in_percent,
			iu.fragment_count,
			iu.avg_fragment_size_in_pages,
			iu.page_count
INTO		#ixstats
FROM		sys.dm_db_index_physical_stats(0, 0, -1, 0, NULL) iu
INNER JOIN	sys.objects o
ON			o.object_id = iu.object_id
INNER JOIN	sys.indexes i
ON			i.object_id = iu.object_id
AND			i.index_id = iu.index_id
AND			i.type >= 1
AND			i.is_primary_key = 0
WHERE		OBJECTPROPERTY(iu.object_id, 'IsTable') = 1;


DECLARE	ixManut CURSOR FOR
SELECT		page_count, 
			avg_fragmentation_in_percent,
			CASE WHEN avg_fragmentation_in_percent BETWEEN 5 AND 30
				THEN 'REORGANIZING'
				ELSE 'REBUILDING'
			END OP,
			idx, 
			'['+SCHM+'].['+OBJNAME+']' OBJ,
			'USE '+db+';'+CHAR(13)+'ALTER INDEX ['+idx+'] ON ['+SCHM+'].['+OBJNAME+'] '+
			CASE WHEN avg_fragmentation_in_percent BETWEEN 5 AND 30
				THEN 'REORGANIZE;'
				ELSE 'REBUILD WITH (ONLINE=ON);'
			END cmd
FROM		#ixstats
WHERE		avg_fragmentation_in_percent > 5
AND			page_count > 1000
ORDER BY	page_count,
			avg_fragmentation_in_percent;


	OPEN ixManut;

		FETCH NEXT FROM ixManut
		INTO @p_count, @frag, @op,
			 @ix, @tb, @cmd;

		WHILE @@FETCH_STATUS = 0

			BEGIN
				
				PRINT @op + ' THE INDEX ' + @ix + ' ON TABLE ' + @tb + ' WITH ' + CAST(@p_count AS NVARCHAR(20)) + ' PAGES AND ' + CAST(@frag AS NVARCHAR(20)) + ' FRAGMENTATION PERCENT';
				
				PRINT CHAR(10);

				EXEC(@cmd);

				PRINT 'END OF OPERATION';
				
				PRINT CHAR(10) + CHAR(10) + CHAR(10) + 'NEXT:' + CHAR(10)

				FETCH NEXT FROM ixManut
				INTO @p_count, @frag, @op,
					 @ix, @tb, @cmd;

			END

	CLOSE ixManut;

DEALLOCATE ixManut;
