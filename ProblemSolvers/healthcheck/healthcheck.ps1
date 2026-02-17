<#setting variables for html report#>
$uptime = get-uptime -since
$userDetails = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$username = $userDetails.Split('\')[-1] <#splitting username and removing the "\WNSM\" to use for output path#>
$basecpuSpeed = (Get-CimInstance -Class Win32_Processor).MaxClockSpeed / 1000
$MaxClockSpeed = ((Get-CimInstance CIM_Processor).MaxClockSpeed) / 1000
$ProcessorPerformance = (Get-Counter -Counter "\Processor Information(_Total)\% Processor Performance").CounterSamples.CookedValue
$actualCPUSpeed = ($MaxClockSpeed * ($ProcessorPerformance / 100)) <#obtaining current cpu speed by multiplying the max clock speed by 100th the performance#>
$trimmedActualCPUSpeed = $actualCPUSpeed.ToString().Substring(0, 4) <##>

<#testing string/variable results#>
Write-Host "Max Clock Speed: $MaxClockSpeed GHz"
Write-Host "CPU Speed: $trimmedActualCPUSpeed GHz"

<#building html report#>
$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>PC Health Check</title>
</head>
<body>
    <h1> Username: $userDetails</h1>
    <p>uptime: $uptime</p>
    <p>Base CPU Speed: $basecpuSpeed Ghz</p>
    <p>Current CPU Speed: $trimmedActualCPUSpeed Ghz</p>
</body>
</html>
"@
$htmlContent | Out-File -FilePath "C:\Users\$userName\healthcheck.html"