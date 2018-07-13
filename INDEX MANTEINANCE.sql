SELECT		DatabaseName,
			COUNT(*) cnt
FROM		Monitoramento.dbo.dbuse_statistics
GROUP BY	DatabaseName
ORDER BY	cnt DESC, DatabaseName



USE	MIDB17P;
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


SELECT		
			'USE '+db+';'+CHAR(13)+'ALTER INDEX ['+idx+'] ON ['+SCHM+'].['+OBJNAME+'] '+
			CASE WHEN avg_fragmentation_in_percent BETWEEN 5 AND 30
				THEN 'REORGANIZE;'
				ELSE 'REBUILD WITH (ONLINE=ON);'
			END 
			cmd,
			db,
			SCHM,
			OBJNAME,
			idx,
			page_count,
			avg_fragmentation_in_percent,
			fragment_count,
			avg_fragment_size_in_pages
FROM		#ixstats
WHERE		avg_fragmentation_in_percent > 5
AND			page_count > 1000
ORDER BY	avg_fragmentation_in_percent DESC;