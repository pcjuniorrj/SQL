USE [msdb]
GO

/****** Object:  Job [DBA - Jobs Monitor]    Script Date: 02/27/2018 14:06:59 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 02/27/2018 14:06:59 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Jobs Monitor', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Job para envio diário de e-mail com status dos Jobs executados no dia anterior.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'INMETRO\sql7adm', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [List&Send Exec Jobs]    Script Date: 02/27/2018 14:06:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'List&Send Exec Jobs', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @message NVARCHAR(MAX), @msg NVARCHAR(MAX), @assunto varchar(255)

SET @message = ''<html><header><title>Relatorio de Falhas em Execucao de Jobs</title></header><body><table border=1><tr><th>servidor</th><th>job</th><th>status</th><th>descricao</th><th>data_exec</th><th>duracao</th></tr>''
SET @assunto = ''Daily Jobs Rpt: ''+@@SERVERNAME

DECLARE messCursor CURSOR FOR  
SELECT		''<tr><td>''+@@SERVERNAME+''</td>''+
			''<td>''+J.name+''</td>''+
			''<td>''+CASE H.run_status
						WHEN 0 THEN ''falha''
						WHEN 1 THEN ''sucesso''
						WHEN 2 THEN ''repetir''
						WHEN 3 THEN ''cancelada''
					END+''</td>''+
			''<td>''+J.description+''</td>''+
			''<td>''+STUFF(STUFF(convert(varchar(8),H.run_date),5,0,''-''),8,0,''-'')+'' ''+STUFF(STUFF(CONVERT(varchar(6),run_time),3,0,'':''),6,0,'':'')+''</td>''+
			''<td>''+STUFF(STUFF(STUFF(RIGHT(REPLICATE(''0'', 8) + CAST(h.run_duration as varchar(8)), 8), 3, 0, '':''), 6, 0, '':''), 9, 0, '':'')+''</td></tr>''
FROM		msdb..sysjobs J
INNER JOIN	msdb..sysjobhistory H
ON			J.job_id = H.job_id
WHERE		datediff(day,convert(datetime,convert(varchar(8),H.run_date)),GETDATE()) = 1
AND			H.step_id = 0;


OPEN messCursor  

FETCH NEXT FROM messCursor   
INTO @msg
WHILE @@FETCH_STATUS = 0  
BEGIN
	SET @message = @message+@msg;

	
	FETCH NEXT FROM messCursor   
	INTO @msg
END
CLOSE messCursor;  
DEALLOCATE messCursor; 

SET @message = @message + ''</table></body></html>''

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = ''sql7adm'',  
    @recipients = ''pcbenjamin@colaborador.inmetro.gov.br'', 
    @subject = @assunto,   
    @body = @message,  
    @body_format = ''HTML'' ; ', 
		@database_name=N'msdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180227, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=235959, 
		@schedule_uid=N'922e8ce4-b3c2-45d9-bc46-ad0a470313fb'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

