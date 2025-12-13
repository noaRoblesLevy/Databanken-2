# ----- import_json.ps1 -----
# Importeert treasures.json in de sharded MongoDB cluster via mongos (poort 27017)
# Gebruik:  .\import_json.ps1

# 1. Pad naar mongosh (PAS AAN indien nodig!)
$mongoShell = "C:\Program Files\MongoDB\mongosh-2.5.10-win32-x64\bin\mongosh.exe"

# 2. JSON-bestand en connectie
$jsonFile  = "C:\Users\noaro\KDG\databanken2\Data_Warehousing\5\treasures.json"
$uri       = "mongodb://localhost:27017/catchem?directConnection=false"
$batchSize = 200   # aantal documenten per batch (mag lager als het nog zwaar is)

Write-Host "Using mongosh:      $mongoShell"
Write-Host "Importing file:     $jsonFile"
Write-Host "Target URI:         $uri"
Write-Host "Target collection:  catchem.treasures"
Write-Host "Batch size:         $batchSize"
Write-Host ""

if (-not (Test-Path $mongoShell)) {
    Write-Host "ERROR: mongosh.exe niet gevonden op $mongoShell" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $jsonFile)) {
    Write-Host "ERROR: JSON-bestand niet gevonden op $jsonFile" -ForegroundColor Red
    exit 1
}

$batchNumber = 0

# Lees het bestand in batches
$linesEnum = Get-Content -Path $jsonFile -Encoding UTF8 -ReadCount $batchSize

foreach ($batch in $linesEnum) {
    $batchNumber++

    if ($batch.Count -eq 0) { continue }

    Write-Host "Preparing batch $batchNumber (`$($batch.Count) docs)..."

    # Maak van de batch lijnen één JSON-array: [ {...}, {...}, ... ]
    $jsonArray = "[" + ($batch -join ",") + "]"

    # Tijdelijk JS-bestand voor deze batch
    $tempJs = Join-Path $env:TEMP ("treasures_batch_{0}.js" -f $batchNumber)

    # JS-code: docs-array + insertMany
    $jsContent = @"
const docs = $jsonArray;
use('catchem');
db.treasures.insertMany(docs);
"@

    # Schrijf JS naar tempbestand
    Set-Content -Path $tempJs -Value $jsContent -Encoding UTF8

    Write-Host "Importing batch $batchNumber from $tempJs ..."

    # Voer de JS uit via mongosh
    & "$mongoShell" $uri --quiet --file $tempJs

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Batch $batchNumber FAILED, exit code $LASTEXITCODE" -ForegroundColor Red
        Write-Host "Temp JS left at: $tempJs"
        exit $LASTEXITCODE
    }

    # Tempbestand opruimen
    Remove-Item $tempJs -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Import completed successfully." -ForegroundColor Green
# ----- einde script -----
