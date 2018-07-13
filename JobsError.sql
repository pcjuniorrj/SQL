DECLARE @message nvarchar(max);
DECLARE @msg nvarchar(max);
DECLARE @cMsg nvarchar(max);
SET @message = null;
SET @msg = null;
SET @cMsg = null;
PRINT 'Variaveis criadas';

set @message = '<html><header><title>Relatório de Falhas em Execução de Jobs</title></header><body><table border=1><tr><th>servidor</th><th>job</th><th>descricao</th><th>step</th><th>data_exec</th><th>hora_exec</th></tr>';
PRINT '@message = '+@message;

DECLARE messCursor CURSOR FOR
SELECT		'<tr><td>'+h.server+'</td>'+
			'<td>'+j.name+'</td>'+
			'<td>'+j.description+'</td>'+
			'<td>'+h.step_name+'</td>'+
			'<td>'+RIGHT(CONVERT(VARCHAR(8),h.run_date),2)+'/'+LEFT(RIGHT(CONVERT(VARCHAR(8),h.run_date),4),2)+'/'+LEFT(CONVERT(VARCHAR(8),h.run_date),4)+'</td>'+
			'<td>'+STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(h.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':')+'</td></tr>'/*+
			'<tr><th colspan="6">Mensagem</th><tr><td colspan="6">'+h.message+'</td></tr>' */tabela
FROM		msdb..sysjobhistory h
INNER JOIN	msdb..sysjobs j
ON			h.job_id = j.job_id
WHERE		DATEDIFF(DAY,CONVERT(DATE,(CONVERT(VARCHAR(8),h.run_date))),GETDATE()) <= 7
AND			h.run_status <> 1
AND			h.step_id <> 0;

	OPEN messCursor  
		
		FETCH NEXT FROM messCursor   
		INTO @cMsg
		
			WHILE @@FETCH_STATUS = 0  
			BEGIN
				--SET @msg = @msg+@cMsg;
				PRINT 'Estrutura: '+@cMsg;
			END
			FETCH NEXT FROM messCursor   
			INTO @cMsg   
	CLOSE messCursor;  
DEALLOCATE messCursor; 

PRINT 'Estrutura final: ' + @msg;

SET @message = @message + @msg + '</table></body></html>'

PRINT @message;