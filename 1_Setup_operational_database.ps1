# 1_Setup_operational_database.ps1
# Zet de "catchem" databank op op basis van catchem_backup.zip

# ---- 1. Variabelen ---------------------------------------------------------
# PAS DIT PAD AAN naar de map waar catchem_backup.zip zich bevindt
$SOURCE = "C:\Users\noaro\KDG\databanken2\Data_Warehousing"

# PostgreSQL connectiegegevens
$DBName = "catchem"
$DBUser = "postgres"
$DBHost = "localhost"
$DBPort = "5432"

# Paden naar PostgreSQL binaries
$PSQL = "C:\Program Files\PostgreSQL\18\bin\psql.exe"
$CREATEDB = "C:\Program Files\PostgreSQL\18\bin\createdb.exe"
$DROPDB = "C:\Program Files\PostgreSQL\18\bin\dropdb.exe"

# Bestanden
$BackupZip = Join-Path $SOURCE "catchem_backup.zip"
$SqlFile   = Join-Path $SOURCE "catchem_backup.sql"
$LogFile   = "1_Setup_operational_database_log.txt"

# ---- 2. Start logging ------------------------------------------------------
Start-Transcript -Path $LogFile -Force

Write-Host "=== Start setup operationele databank ==="
Write-Host "Timestamp: $(Get-Date)"
Write-Host "SOURCE: $SOURCE"
Write-Host "DB_NAME: $DBName"
Write-Host ""

# ---- 3. Controleer zipbestand ----------------------------------------------
if (-not (Test-Path $BackupZip)) {
    Write-Host "FOUT: Zipbestand niet gevonden: $BackupZip"
    Stop-Transcript
    exit 1
}

Write-Host "Zipbestand gevonden: $BackupZip"
Write-Host ""

# ---- 4. Unzip ---------------------------------------------------------------
Write-Host "Uitpakken van $BackupZip naar $SOURCE ..."
Expand-Archive -Path $BackupZip -DestinationPath $SOURCE -Force
Write-Host "Unzip klaar."
Write-Host ""

if (-not (Test-Path $SqlFile)) {
    Write-Host "FOUT: SQL-bestand niet gevonden na unzip: $SqlFile"
    Stop-Transcript
    exit 1
}

Write-Host "SQL-bestand gevonden: $SqlFile"
Write-Host ""

# ---- 5. Drop databank (indien bestaat) -------------------------------------
Write-Host "Drop databank '$DBName' indien die al bestaat..."

& $DROPDB -h $DBHost -p $DBPort -U $DBUser $DBName 2>$null
Write-Host "Dropdb uitgevoerd (OK als er een waarschuwing kwam)"
Write-Host ""

# ---- 6. Maak nieuwe databank aan -------------------------------------------
Write-Host "Maak nieuwe databank '$DBName' aan..."

& $CREATEDB -h $DBHost -p $DBPort -U $DBUser $DBName
if ($LASTEXITCODE -ne 0) {
    Write-Host "FOUT: aanmaken van databank '$DBName' is mislukt."
    Stop-Transcript
    exit 1
}

Write-Host "Databank '$DBName' aangemaakt."
Write-Host ""

# ---- 7. SQL import ----------------------------------------------------------
Write-Host "Voer SQL-script uit in databank '$DBName'..."

& $PSQL -h $DBHost -p $DBPort -U $DBUser -d $DBName -f $SqlFile
if ($LASTEXITCODE -ne 0) {
    Write-Host "FOUT: uitvoeren SQL-script mislukt."
    Stop-Transcript
    exit 1
}

Write-Host "SQL-script succesvol uitgevoerd."
Write-Host ""

Write-Host "=== Setup operationele databank voltooid ==="
Write-Host "Logbestand: $LogFile"

Stop-Transcript
