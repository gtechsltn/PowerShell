Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force

Clear-Host

$CurrentDir = (Get-Location).Path
Write-Host "Get-Location into CurrentDir variable: DONE" -ForegroundColor DarkGreen -BackgroundColor Black

Try {    
    # Code that may throw an exception

    $SqlServer = "MANH"       				# Replace with your SQL Server instance name
    $Database = "mssql"         			# Replace with your database name (optional, can be in the SQL file)
    $SqlFile = "tblUsers-Schema.sql" 			# Replace with the path to your .sql file

    Invoke-Sqlcmd -ServerInstance $SqlServer -Database $Database -InputFile $SqlFile

    $SqlFile = "tblUsers-InsertData.sql" 		# Replace with the path to your .sql file
    try {
        $Output = Invoke-Sqlcmd -ServerInstance $SqlServer -Database $Database -InputFile $SqlFile -ErrorAction Stop
        Write-Host "SQL script executed successfully."
        if ($Output) {
            Write-Output $Output
        }
    }
    catch {
        Write-Error "Error executing SQL script: $($_.Exception.Message)"
    }
}
Catch [System.Exception] {
    # Code to handle the error
    # Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Yellow
}
Finally {
    # Code that runs regardless of an error occurring or not

    Set-Location -Path $CurrentDir -PassThru
    Write-Host "Set-Location -Path '$CurrentDir' : DONE" -ForegroundColor DarkGreen -BackgroundColor Black
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGreen -BackgroundColor Black
}