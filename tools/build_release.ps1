$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$archive=Join-Path $root 'release\mod_potion_helper.zip'
if(Test-Path $archive){Remove-Item $archive -Force}
Push-Location $root
try { Compress-Archive -LiteralPath '.\scripts', '.\gfx' -DestinationPath $archive -CompressionLevel Optimal } finally { Pop-Location }
Write-Host "Created $archive"
