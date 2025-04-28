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

## Create new IIS website if not exists using the WebAdministration module (DONE DONE DONE) (HAY HAY HAY)
```
Import-Module WebAdministration

Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force

Clear-Host

$CurrentDir = (Get-Location).Path
Write-Host "Get-Location into CurrentDir variable: DONE" -ForegroundColor DarkGreen -BackgroundColor Black

Try {    
    # Code that may throw an exception
    
    # --- Configuration ---
    $siteName = "MyWebsite"
    $sitePort = 8080
    $physicalPath = "C:\inetpub\MyWebsite"
    $appPoolName = "MyWebsiteAppPool"
    
    # --- Create the physical folder if it doesn't exist ---
    if (-not (Test-Path $physicalPath)) {
        New-Item -Path $physicalPath -ItemType Directory -Force
        Write-Output "Created folder: $physicalPath"
    }
    
    # --- Check if site already exists ---
    $siteExists = Test-Path "IIS:\Sites\$siteName"
    
    # --- Check if port is already used ---
    $portInUse = Get-WebBinding | Where-Object { $_.bindingInformation -like "*:${sitePort}:*" }
    
    if ($siteExists) {
        Write-Output "Website '$siteName' already exists. Skipping creation."
    }
    elseif ($portInUse) {
        Write-Output "Port $sitePort is already in use by another site. Cannot create website."
    }
    else {
        # --- Create Application Pool ---
        if (-not (Test-Path "IIS:\AppPools\$appPoolName")) {
            New-WebAppPool -Name $appPoolName
            Write-Output "Created App Pool: $appPoolName"
        }
    
        # --- Create Website ---
        New-Website -Name $siteName `
                -Port $sitePort `
                -PhysicalPath $physicalPath `
                -ApplicationPool $appPoolName
        Write-Output "Created Website: $siteName on port $sitePort"
    
        # --- Optional: Set app pool settings ---
        Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "managedRuntimeVersion" -Value "v4.0"
        Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "processModel.identityType" -Value "ApplicationPoolIdentity"
    
        # --- Start the Website ---
        Start-Website -Name $siteName
        Write-Output "Started Website: $siteName"
    }

    # --- Open the website in default browser ---
    Start-Process "http://localhost:$sitePort"
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


## PowerShell script that automatically creates an IIS website using the WebAdministration module
```
Import-Module WebAdministration

# --- Configuration ---
$siteName = "MyWebsite"
$sitePort = 8080
$physicalPath = "C:\inetpub\MyWebsite"
$appPoolName = "MyWebsiteAppPool"

# --- Create the physical folder if it doesn't exist ---
if (-not (Test-Path $physicalPath)) {
    New-Item -Path $physicalPath -ItemType Directory -Force
    Write-Output "Created folder: $physicalPath"
}

# --- Create Application Pool ---
if (-not (Test-Path "IIS:\AppPools\$appPoolName")) {
    New-WebAppPool -Name $appPoolName
    Write-Output "Created App Pool: $appPoolName"
}

# --- Create Website ---
if (-not (Test-Path "IIS:\Sites\$siteName")) {
    New-Website -Name $siteName `
                -Port $sitePort `
                -PhysicalPath $physicalPath `
                -ApplicationPool $appPoolName
    Write-Output "Created Website: $siteName on port $sitePort"
} else {
    Write-Output "Website $siteName already exists."
}

# --- Optional: Set app pool settings ---
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "managedRuntimeVersion" -Value "v4.0"
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "processModel.identityType" -Value "ApplicationPoolIdentity"

# --- Start the Website (if not already started) ---
Start-Website -Name $siteName
Write-Output "Started Website: $siteName"
```

## Create new website
* [Create Website in IIS 10 using PowerShell](https://docs.google.com/document/d/192Likt0k1UveRgdK-DGo4_nO8R3r91e4691JsKiEbak)

```
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force

Clear-Host

$CurrentDir = (Get-Location).Path
Write-Host "Get-Location into CurrentDir variable: DONE" -ForegroundColor DarkGreen -BackgroundColor Black

Try {    
    # Code that may throw an exception
    New-Website -Name "MyWebsite" -PhysicalPath "C:\inetpub\wwwroot\website" -BindingInfo "*:88:"
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

## Basic throw Statement:
```
function Do-Something {
    param(
        [Parameter(Mandatory=$true)]
        $InputObject
    )

    if (-not $InputObject) {
        throw "Input object cannot be null or empty."
    }

    # Your script logic here
    Write-Host "Processing: $($InputObject)"
}

try {
    Do-Something -InputObject $null
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
}
```

## Throwing Specific Exception Types:
```
function Check-Age {
    param(
        [Parameter(Mandatory=$true)]
        [int]$Age
    )

    if ($Age -lt 0) {
        throw [System.ArgumentOutOfRangeException]::new("Age cannot be negative.", "Age")
    }
    elseif ($Age -lt 18) {
        throw [System.InvalidOperationException]::new("User must be at least 18 years old.")
    }

    Write-Host "Age is valid: $Age"
}

try {
    Check-Age -Age -5
}
catch [System.ArgumentOutOfRangeException] {
    Write-Error "Invalid age provided: $($_.Exception.Message) Parameter: $($_.Exception.ParamName)"
}
catch [System.InvalidOperationException] {
    Write-Error "Operation not allowed: $($_.Exception.Message)"
}
catch {
    Write-Error "An unexpected error occurred: $($_.Exception.Message)"
}
```

## With finally block
```
$fileStream = $null
try {
    $filePath = "nonexistent.txt"
    $fileStream = [System.IO.StreamReader]::new($filePath)
    # ... process the file ...
}
catch {
    Write-Error "Error reading file: $($_.Exception.Message)"
}
finally {
    if ($fileStream) {
        $fileStream.Close()
        Write-Host "File stream closed."
    }
}
```

## Execute SQL Files Using ADO.NET directly in PowerShell (More Advanced)
```
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force

Clear-Host

$CurrentDir = (Get-Location).Path
Write-Host "Get-Location into CurrentDir variable: DONE" -ForegroundColor DarkGreen -BackgroundColor Black

Try {    
    # Code that may throw an exception
    Add-Type -AssemblyName System.Data.SqlClient

    $SqlServer = "YourSqlServerName"
    $Database = "YourDatabaseName"
    $SqlFile = "C:\Path\To\YourScript.sql"
    $ConnectionString = "Server=$SqlServer;Database=$Database;Integrated Security=True;" # Adjust as needed
    
    try {
        $SqlConnection = New-Object System.Data.SqlClient.SqlConnection($ConnectionString)
        $SqlConnection.Open()
    
        $SqlCommands = Get-Content $SqlFile -Raw -Encoding UTF8 # Read the entire file as one string
    
        $SqlCommand = New-Object System.Data.SqlClient.SqlCommand($SqlCommands, $SqlConnection)
        $Result = $SqlCommand.ExecuteNonQuery() # For non-query statements (INSERT, UPDATE, DELETE, CREATE, etc.)
        Write-Host "SQL script executed successfully. Rows affected: $Result"
    
        # If your script has SELECT statements, you'd use ExecuteReader and process the results.
    }
    catch {
        Write-Error "Error executing SQL script: $($_.Exception.Message)"
    }
    finally {
        if ($SqlConnection -ne $null -and $SqlConnection.State -eq [System.Data.ConnectionState]::Open) {
            $SqlConnection.Close()
        }
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

## Execute SQL Files (Invoke-Sqlcmd) (SQL Server)
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

## Execute SQL Files (Invoke-Expression) (MySQL)
```
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force

Clear-Host

$CurrentDir = (Get-Location).Path
Write-Host "Get-Location into CurrentDir variable: DONE" -ForegroundColor DarkGreen -BackgroundColor Black

Try {    
    # Code that may throw an exception
    
    $MySqlServer = "localhost"
    $MySqlUser = "your_user"
    $MySqlPassword = "your_password"
    $MySqlDatabase = "your_database"
    $MySqlFile = "C:\Path\To\YourMySqlScript.sql"
    
    $MySqlCommand = "mysql -h $MySqlServer -u $MySqlUser -p'$MySqlPassword' $MySqlDatabase < '$MySqlFile'"
    
    try {
        $Output = Invoke-Expression $MySqlCommand
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

## Execute SQL Files (Invoke-Expression) (PostgreSQL)
```
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force

Clear-Host

$CurrentDir = (Get-Location).Path
Write-Host "Get-Location into CurrentDir variable: DONE" -ForegroundColor DarkGreen -BackgroundColor Black

Try {    
    # Code that may throw an exception
    
    $PostgresServer = "localhost"
    $PostgresUser = "your_user"
    $PostgresDatabase = "your_database"
    $PostgresFile = "C:\Path\To\YourPostgresScript.sql"
    
    $PostgresCommand = "psql -h $PostgresServer -U $PostgresUser -d $PostgresDatabase -f '$PostgresFile'"

    try {
        $Output = Invoke-Expression $PostgresCommand
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
