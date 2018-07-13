--Receita

USE [receitadimci] -- podes ser receitadinqp ou receitadimel
go

EXEC dbo.sp_grantdbaccess @loginame = N'INMETRO\vvlima', @name_in_db = N'INMETRO\vvlima'
 
GO
EXEC sp_addrolemember N'receita_users',N'INMETRO\vvlima'
GO

EXEC sp_addrolemember N'custos_users',N'INMETRO\vvlima'

GO 
IF NOT EXISTS (
		SELECT 1
		FROM usuario
		WHERE COUSUA = 'vvlima'
		)
	INSERT INTO USUARIO (
		COUSUA
		,NOUSUA
		,COGRUPUSUA
		,DAATUAL
		)
	VALUES (
		'vvlima'
		,'Viviane V Lima'
		,5  --- pode ser  5	CONSULTA ,3	GERENCIA ,4	OPERACAO ,2	PUBLIC ,1	SUPER USUARIO
		,getdate()
		)
 

3	GERENCIA ,4	OPERACAO ,2	PUBLIC ,1	SUPER USUARIO
----SRH

USE [SRH]
GO
EXEC dbo.sp_grantdbaccess @loginame = N'INMETRO\lmbaiense', @name_in_db = N'INMETRO\lmbaiense'
GO
USE [SRH]
GO
EXEC sp_addrolemember N'aposentadoria_rh', N'INMETRO\lmbaiense'
GO
USE [SRH]
GO
EXEC sp_addrolemember N'atend_medico_rh', N'INMETRO\lmbaiense'
GO
USE [SRH]
GO
EXEC sp_addrolemember N'beneficios_rh', N'INMETRO\lmbaiense'
GO
USE [SRH]
GO
EXEC sp_addrolemember N'cadastro_rh', N'INMETRO\lmbaiense'
GO
USE [SRH]
GO
EXEC sp_addrolemember N'captacao_rh', N'INMETRO\lmbaiense'
GO
USE [SRH]
GO
EXEC sp_addrolemember N'diarias_rh', N'INMETRO\lmbaiense'
GO
USE [SRH]
GO
EXEC sp_addrolemember N'ferias_rh', N'INMETRO\lmbaiense'
GO
USE [SRH]
GO
EXEC sp_addrolemember N'frequencia_rh', N'INMETRO\lmbaiense'
GO
USE [SRH]
GO
EXEC sp_addrolemember N'treinamento_rh', N'INMETRO\lmbaiense'
GO

--Planejamento -- Siplan

use planejamento
 
GO
EXEC sp_addrolemember N'siplan_users', N'inmetro\rsigaud'
GO

if not exists(select * 
              from usuario
              where cousua = 'rsigaud')
begin 
   insert into usuario
	(cousua, nousua, cogrupusua, daatual)
	 values
	('rsigaud', 'RICARDO SIGAUD', '002', getdate())
end
else
begin
   update usuario
   set cogrupusua = '002'
   where cousua = 'rsigaud'
end 

--Certificado 
USE [certificado]
go

EXEC dbo.sp_grantdbaccess @loginame = N'INMETRO\vsoliveira', @name_in_db = N'INMETRO\vsoliveira'
go


EXEC sp_addrolemember N'certificado_users',N'INMETRO\vsoliveira'
GO


EXEC sp_addrolemember N'custos_users',N'INMETRO\vsoliveira'
GO

EXEC sp_addrolemember N'receita_users',N'INMETRO\vsoliveira'
 

 --CONFIN 
USE [Confin]
go

EXEC dbo.sp_grantdbaccess @loginame = N'INMETRO\vsoliveira', @name_in_db = N'INMETRO\vsoliveira'
go

---se for usuario do confin difi/nucar
EXEC sp_addrolemember N'Confin_users',N'INMETRO\vsoliveira'
--OU
---se for usuario do Receita DIMCI.CGCRE,DCONF e |DIMEL
EXEC sp_addrolemember N'Confin_users_receita',N'INMETRO\vsoliveira'

EXEC sp_addrolemember N'custos_users',N'INMETRO\vsoliveira'
GO

EXEC sp_addrolemember N'receita_users',N'INMETRO\vsoliveira'
 - se for usuario do confin 
 
 --repetir
 EXEC sp_addrolemember N'receita_users',N'INMETRO\vsoliveira'
 --noos bancos receitadinqp,receitadimel e receitadimci
