
# export-treasures.ps1
# Exporteert alle treasures + stages uit PostgreSQL (catchem)
# naar één JSON-bestand, klaar voor import in MongoDB.

# 1. Pad naar psql.exe (controleer versie en map!)
#   vb: C:/Program Files/PostgreSQL/17/bin/psql.exe
$psqlPath = "C:/Program Files/PostgreSQL/18/bin/psql.exe"

# 2. Databasegegevens
$dbName = "catchem"        # naam van jouw database
$dbUser = "postgres"       # jouw DB-gebruiker
$dbHost = "localhost"      # of servernaam/IP
$dbPort = 5432             # standaard PostgreSQL-poort
$dbPassword = ""

# 3. Outputbestand
$outputFile = "treasures.json"

# 4. Wachtwoord doorgeven aan psql
$env:PGPASSWORD = $dbPassword

# 5. SQL-query die per treasure één JSON-object maakt
#    Elke rij van het resultaat = 1 JSON-document
$sql = @"
WITH stages_per_treasure AS (
    SELECT
        ts.treasure_id,
        json_agg(
            json_build_object(
                'stage_id',       '\\x' || encode(s.id, 'hex'),
                'container_size', s.container_size,
                'description',    s.description,
                'latitude',       s.latitude,
                'longitude',      s.longitude,
                'sequence_number',s.sequence_number,
                'type',           s.type,
                'visibility',     s.visibility
            )
            ORDER BY s.sequence_number
        ) AS stages
    FROM treasure_stages ts
    JOIN stage s ON s.id = ts.stages_id
    GROUP BY ts.treasure_id
)
SELECT
    json_build_object(
        'treasure_id', '\\x' || encode(t.id, 'hex'),
        'difficulty',  t.difficulty,
        'terrain',     t.terrain,
        'stages',      spt.stages
    )::text
FROM treasure t
JOIN stages_per_treasure spt ON spt.treasure_id = t.id
ORDER BY t.id;
"@

# 6. psql aanroepen
#    -A  = unaligned output (geen kolomtabel)
#    -t  = alleen rijen (geen headers/footers)
#    >   = schrijf alles direct naar $outputFile
& $psqlPath `
    -h $dbHost `
    -p $dbPort `
    -U $dbUser `
    -d $dbName `
    -A -t `
    -c $sql `
    > $outputFile

Write-Host "Klaar! JSON geëxporteerd naar $outputFile"
