Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$source = Join-Path (Split-Path -Parent $root) 'data_001\gfx\ui\items\consumables\potion_02.png'
$destination = Join-Path $root 'gfx\ui\items\consumables'
$skillDestination = Join-Path $root 'gfx\skills'
New-Item -ItemType Directory -Force -Path $destination | Out-Null
New-Item -ItemType Directory -Force -Path $skillDestination | Out-Null

$colors = @{
    'potion_helper_health_high.png' = [System.Drawing.Color]::FromArgb(220, 40, 35)
    'potion_helper_health_medium.png' = [System.Drawing.Color]::FromArgb(235, 120, 25)
    'potion_helper_health_low.png' = [System.Drawing.Color]::FromArgb(50, 175, 65)
    'potion_helper_armor.png' = [System.Drawing.Color]::FromArgb(35, 35, 40)
}

foreach ($entry in $colors.GetEnumerator()) {
    $input = [System.Drawing.Bitmap]::new($source)
    $output = [System.Drawing.Bitmap]::new($input.Width, $input.Height)
    try {
        for ($x = 0; $x -lt $input.Width; $x++) {
            for ($y = 0; $y -lt $input.Height; $y++) {
                $pixel = $input.GetPixel($x, $y)
                if ($pixel.A -eq 0) { $output.SetPixel($x, $y, $pixel); continue }
                $brightness = ($pixel.R + $pixel.G + $pixel.B) / 765.0
                if ($pixel.R -gt $pixel.G + 20 -and $pixel.R -gt $pixel.B + 20) {
                    $output.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($pixel.A, [int]($entry.Value.R * $brightness), [int]($entry.Value.G * $brightness), [int]($entry.Value.B * $brightness)))
                } else { $output.SetPixel($x, $y, $pixel) }
            }
        }
        $output.Save((Join-Path $destination $entry.Key), [System.Drawing.Imaging.ImageFormat]::Png)
        if ($entry.Key -like 'potion_helper_health_*') {
            $output.Save((Join-Path $skillDestination $entry.Key), [System.Drawing.Imaging.ImageFormat]::Png)
            $disabled = [System.Drawing.Bitmap]::new($output.Width, $output.Height)
            try {
                for ($x = 0; $x -lt $output.Width; $x++) {
                    for ($y = 0; $y -lt $output.Height; $y++) {
                        $pixel = $output.GetPixel($x, $y)
                        $luminance = [int](0.299 * $pixel.R + 0.587 * $pixel.G + 0.114 * $pixel.B)
                        $disabled.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($pixel.A, $luminance, $luminance, $luminance))
                    }
                }
                $disabledName = [System.IO.Path]::GetFileNameWithoutExtension($entry.Key) + '_sw.png'
                $disabled.Save((Join-Path $skillDestination $disabledName), [System.Drawing.Imaging.ImageFormat]::Png)
            } finally { $disabled.Dispose() }
        }
    } finally { $input.Dispose(); $output.Dispose() }
}
