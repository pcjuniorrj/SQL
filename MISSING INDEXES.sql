USE orquestra;



SELECT		DB_NAME(mid.database_id) database_id,
			mid.statement,
			mid.equality_columns,
			mid.included_columns,
			migs.unique_compiles,
			migs.user_seeks,
			migs.user_scans,
			migs.avg_user_impact,
			migs.avg_total_user_cost,
			'CREATE NONCLUSTERED INDEX [IX_DBA_NON_'+OBJECT_NAME(mid.object_id)+'_'+
			CAST(YEAR(GETDATE()) AS VARCHAR(4))+
			RIGHT('00'+CAST(MONTH(GETDATE()) AS VARCHAR(4)),2)+
			RIGHT('00'+CAST(DAY(GETDATE()) AS VARCHAR(4)),2)+
			RIGHT('00'+CAST(DATEPART(HOUR,GETDATE()) AS VARCHAR(4)),2)+
			'] ON '+mid.statement+' ('+mid.equality_columns+');' IX_CREATE
FROM		sys.dm_db_missing_index_details mid
INNER JOIN	sys.dm_db_missing_index_groups mig
ON			mid.index_handle			= mig.index_handle
INNER JOIN	sys.dm_db_missing_index_group_stats migs
ON			mig.index_group_handle		= migs.group_handle
WHERE		migs.avg_user_impact		>= 80
AND			migs.unique_compiles		> 3000


/*

SELECT		MAX(ic.index_column_id)
FROM		sys.indexes si
INNER JOIN	sys.index_columns ic
ON			si.object_id = ic.object_id
AND			ic.index_id = si.index_id






SELECT		DB_NAME(i.database_id) DB,
			OBJECT_SCHEMA_NAME(i.object_id) SCHM,
			OBJECT_NAME(i.object_id) OBJ,
			si.name IDX,
			si.type_desc IDX_TYPE,
			ic.index_column_id,
			ic.column_id,
			sc.name
FROM		sys.dm_db_index_usage_stats i
INNER JOIN	sys.indexes si
ON			si.object_id = i.object_id
AND			si.index_id = i.index_id
INNER JOIN	sys.index_columns ic
ON			si.object_id = ic.object_id
AND			ic.index_id = si.index_id
INNER JOIN	sys.columns sc
ON			sc.object_id = ic.object_id
AND			sc.column_id = ic.column_id
WHERE		si.type > 1
AND			si.name = 'IX_wDATA_CodSystem2'
ORDER BY	DB,
			SCHM,
			OBJ,
			IDX,
			ic.index_column_id
*/