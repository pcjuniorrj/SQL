/***********************************************************************************************************************************
(C) 2016, Fabricio Lima Solu��es em Banco de Dados

Site: http://www.fabriciolima.net/

Feedback: fabricioflima@gmail.com
***********************************************************************************************************************************/


/*******************************************************************************************************************************
--	Sequ�ncia de execu��o de Scripts para criar os Alertas do Banco de Dados.
*******************************************************************************************************************************/

--------------------------------------------------------------------------------------------------------------------------------
-- 1)	Criar o Operator para colocar na Notifica��o de Falha dos JOBS que ser�o criados e tamb�m nos Alertas de Severidade
--		Cria a Base Traces
--------------------------------------------------------------------------------------------------------------------------------
USE [msdb]

GO

EXEC [msdb].[dbo].[sp_add_operator]
		@name = N'Alerta_BD',
		@enabled = 1,
		@pager_days = 0,
		@email_address = N'pcbenjamin@colaborador.inmetro.gov.br'	-- Para colocar mais destinatarios, basta separar o email com ponto e v�rgula ";"
GO

/* 
-- Caso n�o tenha a base "Traces", execute o codigo abaixo (lembre de alterar o caminho tamb�m).
USE master

GO

--------------------------------------------------------------------------------------------------------------------------------
--	1.1) Alterar o caminho para um local existente no seu servidor.
--------------------------------------------------------------------------------------------------------------------------------
CREATE DATABASE [Monitoramento] 
	ON  PRIMARY ( 
		NAME = N'Traces', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Traces.mdf' , 
		SIZE = 102400KB , FILEGROWTH = 102400KB 
	)
	LOG ON ( 
		NAME = N'Traces_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Traces_log.ldf' , 
		SIZE = 30720KB , FILEGROWTH = 30720KB 
	)
GO

--------------------------------------------------------------------------------------------------------------------------------
-- 1.2) Utilizar o Recovery Model SIMPLE, pois n�o tem muito impacto perder 1 dia de informa��o nessa base de log.
--------------------------------------------------------------------------------------------------------------------------------
ALTER DATABASE [Monitoramento] SET RECOVERY SIMPLE

GO
*/

--------------------------------------------------------------------------------------------------------------------------------
-- 2)	Abrir o script "..\Caminho\ALERTAS - 2 - Cria��o da Tabela de Controle dos Alertas.txt", ler as instru��es e execut�-lo.
--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
-- 3)	Abrir o script "..\Caminho\ALERTAS - 3 - PreRequisito - QueriesDemoradas.txt", ler as instru��es e execut�-lo.
--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
-- 4)	Abrir o script "..\Caminho\ALERTAS - 4 - Cria��o das Procedures dos Alertas.txt", ler as instru��es e execut�-lo.
--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
-- 5)	Abrir o script "..\Caminho\ALERTAS - 5 - Cria��o dos JOBS dos Alertas.txt", ler as instru��es e execut�-lo.
--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
-- 6)	Abrir o script "..\Caminho\ALERTAS - 6 - Cria��o dos Alertas de Severidade.txt", ler as instru��es e execut�-lo.
--------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
-- 7)	Abrir o script "..\Caminho\ALERTAS - 7 - Teste Alertas.txt", ler as instru��es e execut�-lo.
--------------------------------------------------------------------------------------------------------------------------------