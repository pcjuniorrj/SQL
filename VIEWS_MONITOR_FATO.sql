ALTER VIEW vw_FServer AS
/*FATO - SERVIDOR*/
SELECT		CASE WHEN CHARINDEX('\',fsr.Server,1) = 0
				THEN UPPER(fsr.Server)
				ELSE UPPER(SUBSTRING(fsr.Server,1,CHARINDEX('\',fsr.Server,1)-1))
			END SRVKey,
			YEAR(fsr.DtInfo) Ano,
			MONTH(fsr.DtInfo) Mes,
			DAY(fsr.DtInfo) Dia
FROM		DBASES_AUDIT fsr;

ALTER VIEW vw_FInstancia AS
/*FATO - INSTANCIAS*/
SELECT		DISTINCT
			CASE WHEN CHARINDEX('\',finst.Server,1) = 0
				THEN UPPER(finst.Server)
				ELSE UPPER(SUBSTRING(finst.Server,1,CHARINDEX('\',finst.Server,1)-1))
			END SRVKey,
			UPPER(finst.Server) INSTKey,
			YEAR(finst.DtInfo) Ano,
			MONTH(finst.DtInfo) Mes,
			DAY(finst.DtInfo) Dia
FROM		DBASES_AUDIT finst;

ALTER VIEW vw_FBases AS
/*FATO - BASES*/
SELECT		DISTINCT 
			UPPER(fdb.Server) INSTKey,
			UPPER(fdb.Server+' - '+fdb.Dbase) DBKey,
			fdb.Dbase,
			fdb.Compatibility_Level,
			fdb.Recovery_Mode,
			fdb.Mode,
			fdb.State,
			fdb.UserAccess,
			YEAR(fdb.DtInfo) Ano,
			MONTH(fdb.DtInfo) Mes,
			DAY(fdb.DtInfo) Dia
FROM		DBASES_AUDIT fdb;

ALTER VIEW vw_FDiscos AS
/*FATO - DISCOS*/
SELECT		DISTINCT
			UPPER(fds.Server) INSTKey,
			CASE WHEN CHARINDEX('\',fds.Server,1) = 0
				THEN UPPER(fds.Server+' - '+fds.Drive)
				ELSE UPPER(SUBSTRING(fds.Server,1,CHARINDEX('\',fds.Server,1)-1)+' - '+fds.Drive)
			END DSKey,
			fds.Drive,
			fds.Size,
			fds.Size-fds.FreeSpace SpaceUsed,
			fds.FreeSpace,
			fds.FreePercent,
			YEAR(fds.DtInfo) Ano,
			MONTH(fds.DtInfo) Mes,
			DAY(fds.DtInfo) Dia
FROM		DISKS_AUDIT fds;

ALTER VIEW vw_FDFiles AS
/*FATO - DATAFILES*/
SELECT		DISTINCT
			UPPER(fdf.Server) INSTKey,
			CASE WHEN CHARINDEX('\',fdf.Server,1) = 0
				THEN UPPER(fdf.Server+' - '+LEFT(fdf.physical_name,2))
				ELSE UPPER(SUBSTRING(fdf.Server,1,CHARINDEX('\',fdf.Server,1)-1)+' - '+LEFT(fdf.physical_name,2))
			END DSKey,
			UPPER(fdf.Server+' - '+fdf.Dbase) DBKey,
			UPPER(fdf.Server+' - '+fdf.Dbase+' - '+fdf.Name) DFKey,
			fdf.Dbase,
			fdf.Name,
			fdf.physical_name,
			CASE WHEN fdf.Max_Size < 0
				THEN fdf.Size
				ELSE fdf.Max_Size
			END Max_Size,
			CASE WHEN fdf.Max_Size < 0
				THEN fdf.Size
				ELSE fdf.Max_Size-(fdf.Max_Size-fdf.Size)
			END Max_Size_Used,
			CASE WHEN fdf.Max_Size < 0
				THEN fdf.Size-fdf.Size
				ELSE fdf.Max_Size-fdf.Size
			END Max_Size_Free,
			fdf.Size,
			fdf.SpaceUsed,
			fdf.FreeSpace,
			CASE WHEN fdf.Max_Size < 0
				THEN fdf.SpaceUsed/fdf.Size*100
				ELSE fdf.SpaceUsed/fdf.Max_Size*100 
			END Percent_Max_Size_Used,
			CASE WHEN fdf.Max_Size < 0
				THEN 1
				ELSE 0
			END Ilimitado,
			YEAR(fdf.DtInfo) Ano,
			MONTH(fdf.DtInfo) Mes,
			DAY(fdf.DtInfo) Dia
FROM		DBASES_AUDIT fdf
WHERE		fdf.type_desc = 'ROWS';

ALTER VIEW vw_FLFiles AS
/*FATO - LOGFILES*/
SELECT		DISTINCT
			UPPER(flf.Server) INSTKey,
			CASE WHEN CHARINDEX('\',flf.Server,1) = 0
				THEN UPPER(flf.Server+' - '+LEFT(flf.physical_name,2))
				ELSE UPPER(SUBSTRING(flf.Server,1,CHARINDEX('\',flf.Server,1)-1)+' - '+LEFT(flf.physical_name,2))
			END DSKey,
			UPPER(flf.Server+' - '+flf.Dbase) DBKey,
			UPPER(flf.Server+' - '+flf.Dbase+' - '+flf.Name) LFKey,
			flf.Dbase,
			flf.Name,
			flf.physical_name,
			CASE WHEN flf.Max_Size < 0
				THEN flf.Size
				ELSE flf.Max_Size
			END Max_Size,
			CASE WHEN flf.Max_Size < 0
				THEN flf.Size
				ELSE flf.Max_Size-(flf.Max_Size-flf.Size)
			END Max_Size_Used,
			CASE WHEN flf.Max_Size < 0
				THEN flf.Size-flf.Size
				ELSE flf.Max_Size-flf.Size
			END Max_Size_Free,
			flf.Size,
			flf.SpaceUsed,
			flf.FreeSpace,
			CASE WHEN flf.Max_Size < 0
				THEN flf.SpaceUsed/flf.Size*100
				ELSE flf.SpaceUsed/flf.Max_Size*100 
			END Percent_Max_Size_Used,
			CASE WHEN flf.Max_Size < 0
				THEN 1
				ELSE 0
			END Ilimitado,
			YEAR(flf.DtInfo) Ano,
			MONTH(flf.DtInfo) Mes,
			DAY(flf.DtInfo) Dia
FROM		DBASES_AUDIT flf
WHERE		flf.type_desc = 'LOG';

ALTER VIEW vw_FJob AS
/*FATO - JOB_EXEC*/
SELECT		DISTINCT
			UPPER(fjb.Server) INSTKey,
			UPPER(fjb.Server + ' - ' + fjb.Job) JOBKey,
			fjb.Job,
			fjb.JobStatus,
			fjb.ScheduleStatus,
			fjb.Run_Status,
			CAST(fjb.Duration AS TIME) Duration,
			DAvg.Duration_AVG,
			DAvg.Executions,
			YEAR(fjb.DtInfo) Ano,
			MONTH(fjb.DtInfo) Mes,
			DAY(fjb.DtInfo) Dia,
			DATEPART(HOUR,fjb.DtInfo) Hora,
			fjb.DtInfo
FROM		JOB_EXEC_AUDIT fjb
INNER JOIN	(
SELECT		UPPER(Server + ' - ' + Job) JOBKey, 
			CAST(DATEADD(SECOND,AVG(CAST(SUBSTRING(Duration,1,2) AS REAL)*3600+
			CAST(SUBSTRING(Duration,4,2) AS REAL)*60+
			CAST(SUBSTRING(Duration,7,2) AS REAL)),'2000-01-01 00:00:00.000') AS TIME) Duration_AVG,
			COUNT(*) Executions
FROM		JOB_EXEC_AUDIT 
GROUP BY	UPPER(Server + ' - ' + Job)
			) AS DAvg
ON			UPPER(fjb.Server + ' - ' + fjb.Job) = DAvg.JOBKey