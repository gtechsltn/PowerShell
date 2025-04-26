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