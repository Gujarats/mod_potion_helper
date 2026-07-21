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
Require-Token 'scripts/items/accessory/potion_helper_health_item.nut' 'this.m.ItemType = this.Const.Items.ItemType.Usable;'
Require-Token 'scripts/items/accessory/potion_helper_health_item.nut' 'this.m.IsUsable = true;'
Require-Token 'scripts/items/accessory/potion_helper_health_item.nut' 'if (_actor.getHitpoints() >= _actor.getHitpointsMax())'
Require-Token 'scripts/skills/actives/potion_helper_drink_skill.nut' '"skills/potion_helper_health_" + this.m.Tier + ".png"'
Require-Token 'scripts/skills/actives/potion_helper_drink_skill.nut' '"skills/potion_helper_health_" + this.m.Tier + "_sw.png"'
Require-Token 'scripts/skills/actives/potion_helper_drink_skill.nut' '"sounds/combat/drink_01.wav"'

foreach ($tier in @('low', 'medium', 'high')) {
    foreach ($suffix in @('', '_sw')) {
        $skillIcon = Join-Path $root "gfx/skills/potion_helper_health_$tier$suffix.png"
        if (-not (Test-Path -LiteralPath $skillIcon -PathType Leaf)) { throw "Missing skill icon $skillIcon" }
    }
}

Write-Host 'Potion Helper layout validation passed.'
