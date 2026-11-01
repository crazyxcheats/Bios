# remove_dinput8.ps1
# Deletes dinput8.dll from target BlueStacks folders (no download, no injection)

$ErrorActionPreference = "Stop"

# ---- কনফিগ ----
$targetPaths = @(
    "C:\Program Files\BlueStacks_nxt\dinput8.dll",
    "C:\Program Files\BlueStacks_msi5\dinput8.dll"
)

# ---- প্রতিটি টার্গেট চেক ও ডিলিট ----
$anySuccess = $false
foreach ($target in $targetPaths) {
    if (-not (Test-Path $target)) {
        Write-Host "⚠️ File not found: $target → Skipping" -ForegroundColor Yellow
        continue
    }

    try {
        Remove-Item -Path $target -Force -ErrorAction Stop
        Write-Host "🗑️ Deleted: $target" -ForegroundColor Green
        $anySuccess = $true
    } catch {
        Write-Host "❌ Failed to delete $target : $_" -ForegroundColor Red
    }
}

# ---- ফাইনাল স্ট্যাটাস ----
if ($anySuccess) {
    Write-Host "🎉 At least one dinput8.dll removed successfully." -ForegroundColor Green
    exit 0
} else {
    Write-Host "ℹ️ Nothing was deleted (files missing or all failed)." -ForegroundColor Cyan
    exit 0
}
