ALTER VIEW vw_DServer AS
/*DIMENSAO - SERVIDORES*/
SELECT		DISTINCT 
			CASE WHEN CHARINDEX('\',sr.Server,1) = 0
				THEN UPPER(sr.Server)
				ELSE UPPER(SUBSTRING(sr.Server,1,CHARINDEX('\',sr.Server,1)-1))
			END SRVKey
FROM		DBASES_AUDIT sr;

ALTER VIEW vw_DInstancia AS
/*DIMENSAO - INSTANCIA*/
SELECT		DISTINCT 
			CASE WHEN CHARINDEX('\',inst.Server,1) = 0
				THEN UPPER(inst.Server)
				ELSE UPPER(SUBSTRING(inst.Server,1,CHARINDEX('\',inst.Server,1)-1))
			END SRVKey,
			UPPER(inst.Server) INSTKey
FROM		DBASES_AUDIT inst;

ALTER VIEW vw_DBases AS
/*DIMENSAO - BASES*/
SELECT		DISTINCT 
			UPPER(db.Server) INSTKey,
			UPPER(db.Server+' - '+db.Dbase) DBKey,
			db.Dbase
FROM		DBASES_AUDIT db;

ALTER VIEW vw_DDiscos AS
/*DIMENSAO - DISCOS*/
SELECT		DISTINCT
			UPPER(ds.Server) INSTKey,
			CASE WHEN CHARINDEX('\',ds.Server,1) = 0
				THEN UPPER(ds.Server+' - '+ds.Drive)
				ELSE UPPER(SUBSTRING(ds.Server,1,CHARINDEX('\',ds.Server,1)-1)+' - '+ds.Drive)
			END DSKey,
			ds.Drive
FROM		DISKS_AUDIT ds;

ALTER VIEW vw_DDFiles AS
/*DIMENSAO - DATAFILES*/
SELECT		DISTINCT
			UPPER(df.Server) INSTKey,
			CASE WHEN CHARINDEX('\',df.Server,1) = 0
				THEN UPPER(df.Server+' - '+LEFT(df.physical_name,2))
				ELSE UPPER(SUBSTRING(df.Server,1,CHARINDEX('\',df.Server,1)-1)+' - '+LEFT(df.physical_name,2))
			END DSKey,
			UPPER(df.Server+' - '+df.Dbase) DBKey,
			UPPER(df.Server+' - '+df.Dbase+' - '+df.Name) DFKey,
			df.Dbase,
			df.Name--,
			--df.physical_name
FROM		DBASES_AUDIT df
WHERE		df.type_desc = 'ROWS';

ALTER VIEW vw_DLFiles AS
/*DIMENSAO - LOGFILES*/
SELECT		DISTINCT
			UPPER(lf.Server) INSTKey,
			CASE WHEN CHARINDEX('\',lf.Server,1) = 0
				THEN UPPER(lf.Server+' - '+LEFT(lf.physical_name,2))
				ELSE UPPER(SUBSTRING(lf.Server,1,CHARINDEX('\',lf.Server,1)-1)+' - '+LEFT(lf.physical_name,2))
			END DSKey,
			UPPER(lf.Server+' - '+lf.Dbase) DBKey,
			UPPER(lf.Server+' - '+lf.Dbase+' - '+lf.Name) LFKey,
			lf.Dbase,
			lf.Name--,
			--lf.physical_name
FROM		DBASES_AUDIT lf
WHERE		lf.type_desc = 'LOG';

ALTER VIEW vw_DJob AS
/*DIMENSAO - JOB*/
SELECT		DISTINCT
			UPPER(jb.Server) INSTKey,
			UPPER(jb.Server + ' - ' + jb.Job) JOBKey,
			jb.Job
FROM		JOB_EXEC_AUDIT jb;




SELECT * FROM vw_DServer
SELECT * FROM vw_DInstancia
SELECT * FROM vw_DBases
SELECT * FROM vw_DDiscos
SELECT DFKey, INSTKey, DSKey, DBKey, DBase, Name, physical_name FROM vw_DDFiles WHERE physical_name NOT like '%DATA%' --DFKey = 'RDES01S - PLANEST - PLANESTDATA'
SELECT * FROM vw_DLFiles
SELECT * FROM vw_DJob

SELECT * FROM vw_FServer
SELECT * FROM vw_FInstancia
SELECT * FROM vw_FBases
SELECT * FROM vw_FDiscos
SELECT * FROM vw_FDFiles
SELECT * FROM vw_FLFiles
SELECT * FROM vw_FJob