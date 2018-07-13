
SELECT		Server,
			DBase,
			State,
			Compatibility_Level,
			'ALTER DATABASE '+DBase+' SET COMPATIBILITY_LEVEL = 100;' cmd
FROM		DBASES_AUDIT
WHERE		Compatibility_Level IS NOT NULL
AND			Compatibility_Level = 80
AND			Server = 'RDES01S'
GROUP BY	Server,
			DBase,
			State,
			Compatibility_Level