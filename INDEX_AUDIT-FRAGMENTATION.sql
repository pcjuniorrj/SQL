SELECT		*--Server, Drive, AVG(FreePercent) FreePercent
FROM		Monitoramento.dbo.INDEX_AUDIT
WHERE		PercentFrag > 80
AND			Server NOT LIKE '%DES%'
--GROUP BY	Server, Drive
ORDER BY	1,2,6,4,5