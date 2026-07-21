$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

function Require-Token([string] $File, [string] $Token) {
    $path = Join-Path $root $File
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing $File" }
    if (-not (Get-Content -Raw -LiteralPath $path).Contains($Token)) { throw "Missing '$Token' in $File" }
}

Require-Token 'scripts/!mods_preload/mod_potion_helper.nut' 'mod_potion_helper'
Require-Token 'scripts/!mods_preload/mod_potion_helper.nut' 'mod_msu >= 1.9.0'
Require-Token 'scripts/!mods_preload/mod_potion_helper.nut' 'LowHealthPct'
Require-Token 'scripts/!mods_preload/mod_potion_helper.nut' 'ArmorRepairMinPct'
Require-Token 'scripts/mods/potion_helper_service.nut' 'PotionHelper'
Require-Token 'scripts/mods/potion_helper_market.nut' 'marketplace_building'
$healthItem = Get-Content -LiteralPath (Join-Path $root 'scripts/items/accessory/potion_helper_health_item.nut')
if ($healthItem.Count -lt 20) { throw 'Health potion item must remain formatted as a multi-line Squirrel class.' }
Write-Host 'Potion Helper layout validation passed.'
