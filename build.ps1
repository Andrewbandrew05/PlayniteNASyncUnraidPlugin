$PluginName = "PlayniteNASyncUnraidPlugin"

$Source = ".\src\usr\local\emhttp\plugins\$PluginName"
$ArchiveDir = ".\archive"
$BuildDir = "$env:TEMP\$PluginName-build"
$Output = "$ArchiveDir\$PluginName.txz"

# Ensure clean output folder
New-Item -ItemType Directory -Force -Path $ArchiveDir | Out-Null

Write-Host "[BUILD] Cleaning..."
Remove-Item -Recurse -Force $BuildDir -ErrorAction SilentlyContinue
Remove-Item -Force $Output -ErrorAction SilentlyContinue

if (!(Test-Path $Source)) {
    Write-Host "[ERROR] Missing source folder: $Source"
    exit 1
}

Write-Host "[BUILD] Creating structure..."
New-Item -ItemType Directory -Force `
    -Path "$BuildDir\usr\local\emhttp\plugins\$PluginName" | Out-Null

Write-Host "[BUILD] Copying files..."
Copy-Item -Recurse "$Source\*" `
    "$BuildDir\usr\local\emhttp\plugins\$PluginName\"

Write-Host "[BUILD] Fixing encoding (FORCE UTF-8 no BOM)..."

Get-ChildItem -Recurse $BuildDir -File | ForEach-Object {

    $path = $_.FullName

    # Read raw text
    $text = Get-Content $path -Raw

    # Remove BOM if it sneaks in
    $text = $text -replace "^\uFEFF", ""

    # Normalize line endings
    $text = $text -replace "`r`n", "`n"

    # Rewrite as UTF-8 WITHOUT BOM (this is the key fix)
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
}

Write-Host "[BUILD] Creating TXZ..."
tar -cJf $Output -C $BuildDir .

Write-Host "[DONE]"
Write-Host $Output