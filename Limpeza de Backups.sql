
forfiles /p "F:\MSSQL7\Backup Dados" /s /m *.bak /D -5 /C "cmd /c del @path"