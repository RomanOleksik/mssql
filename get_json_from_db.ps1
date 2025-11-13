# --- Configuration ---
$SQLServerInstance = "YourSQLServer"
$Database = "YourDatabase"
$ViewName = "YourViewName"

# --- 1. Retrieve Data from SQL View ---
try {
    Write-Host "Fetching records from view: $ViewName..." -ForegroundColor Cyan
    $recordsToProcess = Invoke-Sqlcmd -ServerInstance $SQLServerInstance -Database $Database -Query "SELECT * FROM $ViewName" -TrustServerCertificate -ErrorAction Stop
    Write-Host "Found $($recordsToProcess.Count) records to process." -ForegroundColor Green
}
catch {
    Write-Error "Failed to retrieve data from SQL Server. Details: $_"
    return
}

# --- 2. Process and Display Each Record ---
foreach ($row in $recordsToProcess) {
    # --- CONVERT ROW DIRECTLY TO JSON ---
    # We exclude internal .NET DataRow properties to ensure a clean JSON payload
    $jsonPayload = $row | Select-Object * -ExcludeProperty ItemArray, Table, RowError, RowState, HasErrors | ConvertTo-Json -Depth 10

    # --- DISPLAY CONTENT (DRY RUN) ---
    Write-Host "--------------------------------------------------" -ForegroundColor Gray
    Write-Host "Would send the following payload for record:" -ForegroundColor Yellow
    Write-Output $jsonPayload
}

Write-Host "--------------------------------------------------" -ForegroundColor Gray
Write-Host "Dry run complete. No data was sent." -ForegroundColor Green
