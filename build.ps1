$PluginName = "PlayniteNASyncUnraidPlugin"

# Adjust this if your structure changes
$Source = ".\src\usr\local\emhttp\plugins\$PluginName"

$ArchiveDir = ".\archive"
New-Item -ItemType Directory -Force -Path $ArchiveDir | Out-Null

$BuildDir = "$env:TEMP\$PluginName-build"
$Output = "$ArchiveDir\$PluginName.txz"

Write-Host "[BUILD] Cleaning build folder..."
Remove-Item -Recurse -Force $BuildDir -ErrorAction SilentlyContinue
Remove-Item -Force $Output -ErrorAction SilentlyContinue

Write-Host "[BUILD] Creating directory structure..."
New-Item -ItemType Directory -Force -Path "$BuildDir\usr\local\emhttp\plugins\$PluginName" | Out-Null

if (!(Test-Path $Source)) {
    Write-Host "[ERROR] Source path not found:"
    Write-Host $Source
    exit 1
}

Write-Host "[BUILD] Copying files..."
Copy-Item -Recurse "$Source\*" "$BuildDir\usr\local\emhttp\plugins\$PluginName\"

Write-Host "[BUILD] Fixing line endings..."
Get-ChildItem -Recurse $BuildDir -Include *.page,*.php,*.txt,*.cfg | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $content = $content -replace "^\uFEFF", ""
    $content = $content -replace "`r`n", "`n"
    Set-Content -NoNewline -Encoding UTF8 $_.FullName $content
}

Write-Host "[BUILD] Creating TXZ package..."
tar -cJf $Output -C $BuildDir .

Write-Host "[DONE] Output:"
Write-Host $Output