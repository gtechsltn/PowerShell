# PowerShell

## Try Catch Finally
```
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force

Clear-Host

$CurrentDir = (Get-Location).Path
Write-Host "Get-Location into CurrentDir variable: DONE" -ForegroundColor DarkGreen -BackgroundColor Black

Try {    
    # Code that may throw an exception
    # TODO: 
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
```

## Run SQL Files
```
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force

Clear-Host

$CurrentDir = (Get-Location).Path
Write-Host "Get-Location into CurrentDir variable: DONE" -ForegroundColor DarkGreen -BackgroundColor Black

Try {    
    # Code that may throw an exception

    $SqlServer = "YourSqlServerName"       # Replace with your SQL Server instance name
    $Database = "YourDatabaseName"         # Replace with your database name (optional, can be in the SQL file)
    $SqlFile = "C:\Path\To\YourScript.sql" # Replace with the path to your .sql file
    
    Invoke-Sqlcmd -ServerInstance $SqlServer -Database $Database -InputFile $SqlFile

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
```

## Show Empty Folders and Empty Sub-Folders (Recurse)
```
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force

Clear-Host

$CurrentDir = (Get-Location).Path
Write-Host "Get-Location into CurrentDir variable: DONE" -ForegroundColor DarkGreen -BackgroundColor Black

Try {    
    # Code that may throw an exception

    Get-ChildItem -Path "D:\DM\BAGIT" -Directory -Recurse | Where-Object {$_.GetFileSystemInfos().Count -eq 0} | Where-Object {$_.GetFileSystemInfos().Count -eq 0} | Select-Object -ExpandProperty FullName
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
```
