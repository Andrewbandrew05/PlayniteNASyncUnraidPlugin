$PluginName = "PlayniteNASyncUnraidPlugin"

$Source = ".\src\usr\local\emhttp\plugins\$PluginName"
$ArchiveDir = ".\archive"
$BuildDir = "$env:TEMP\$PluginName-build"
$PluginManifest = ".\PlayniteNASyncUnraidPlugin.plg"
$Output = "$ArchiveDir\$PluginName.txz"

New-Item -ItemType Directory -Force -Path $ArchiveDir | Out-Null
Write-Host "[BUILD] Cleaning..."
Remove-Item -Recurse -Force $BuildDir -ErrorAction SilentlyContinue
Remove-Item -Force $Output -ErrorAction SilentlyContinue

if (!(Test-Path $Source)) {
    Write-Host "[ERROR] Missing source folder: $Source"
    exit 1
}

Write-Host "[BUILD] Creating structure..."
New-Item -ItemType Directory -Force -Path "$BuildDir\usr\local\emhttp\plugins\$PluginName" | Out-Null

Write-Host "[BUILD] Copying files..."
Copy-Item -Recurse "$Source\*" "$BuildDir\usr\local\emhttp\plugins\$PluginName\"

Write-Host "[BUILD] Fixing encoding (FORCE UTF-8 no BOM)..."
$files = @(Get-ChildItem -Recurse $BuildDir -File)
if (Test-Path $PluginManifest) {
    $files += Get-Item $PluginManifest
}
foreach ($file in $files) {
    $path = $file.FullName
    $text = Get-Content $path -Raw
    $text = $text -replace "^\uFEFF", ""
    $text = $text -replace "`r`n", "`n"
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
}

Write-Host "[BUILD] Creating TXZ..."
tar -cJf $Output -C $BuildDir .

Write-Host "[DONE]"
Write-Host $Output