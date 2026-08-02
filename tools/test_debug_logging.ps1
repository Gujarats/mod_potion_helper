$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$preloadPath = Join-Path $root "scripts\!mods_preload\mod_potion_helper.nut"
$preload = Get-Content -Raw -LiteralPath $preloadPath

@(
	'DebugLogging',
	'addBooleanSetting("DebugLogging", true',
	'configureDebugLogging',
	'Debug.setFlag("default", enabled)',
	'debugLogging.addCallback'
) | ForEach-Object {
	if ($preload.IndexOf($_) -lt 0) {
		throw "Missing Potion Helper debug logging token: $_"
	}
}

Write-Output "Potion Helper debug logging configuration passed."
