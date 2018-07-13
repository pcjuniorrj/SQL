DECLARE @message NVARCHAR(MAX), @msg NVARCHAR(MAX), @assunto varchar(255)

SET @message = '<html><header><title>Relatorio de Falhas em Execucao de Jobs</title></header><body><table border=1><tr><th>servidor</th><th>job</th><th>status</th><th>descricao</th><th>data_exec</th><th>duracao</th></tr>'
SET @assunto = 'Daily Jobs Rpt: '+@@SERVERNAME

DECLARE messCursor CURSOR FOR  
SELECT		'<tr><td>'+@@SERVERNAME+'</td>'+
			'<td>'+J.name+'</td>'+
			'<td>'+CASE H.run_status
						WHEN 0 THEN 'falha'
						WHEN 1 THEN 'sucesso'
						WHEN 2 THEN 'repetir'
						WHEN 3 THEN 'cancelada'
					END+'</td>'+
			'<td>'+J.description+'</td>'+
			'<td>'+STUFF(STUFF(convert(varchar(8),H.run_date),5,0,'-'),8,0,'-')+' '+STUFF(STUFF(CONVERT(varchar(6),run_time),3,0,':'),6,0,':')+'</td>'+
			'<td>'+STUFF(STUFF(STUFF(RIGHT(REPLICATE('0', 8) + CAST(h.run_duration as varchar(8)), 8), 3, 0, ':'), 6, 0, ':'), 9, 0, ':')+'</td></tr>'
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

SET @message = @message + '</table></body></html>'


EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'sql7adm',  
    @recipients = 'pcbenjamin@colaborador.inmetro.gov.br', 
    @subject = @assunto,   
    @body = @message,  
    @body_format = 'HTML' ; 