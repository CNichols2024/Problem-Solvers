<#setting variables for html report#>
$lastBoot = get-uptime -since
$userDetails = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$username = $userDetails.Split('\')[-1] <#splitting username and removing the "\WNSM\" to use for output path#>
$basecpuSpeed = (Get-CimInstance -Class Win32_Processor).MaxClockSpeed / 1000
$MaxClockSpeed = ((Get-CimInstance CIM_Processor).MaxClockSpeed) / 1000
$ProcessorPerformance = (Get-Counter -Counter "\Processor Information(_Total)\% Processor Performance").CounterSamples.CookedValue
$actualCPUSpeed = ($MaxClockSpeed * ($ProcessorPerformance / 100)) <#obtaining current cpu speed by multiplying the max clock speed by 100th the performance#>
$trimmedActualCPUSpeed = $actualCPUSpeed.ToString().Substring(0, 4) <#trimming the speed to the first 2 digits after decimal#>
<#Getting Domain connection Status and name#>
$domainCheck = (Get-CimInstance Win32_ComputerSystem).PartOfDomain
$domainName = (Get-CimInstance Win32_ComputerSystem).Domain
<#Getting battery capacity details. Try/catch to account for desktops/VM#>
try {
    $designedCapacity = (Get-WmiObject -Class "BatteryStaticData" -Namespace "ROOT\WMI").DesignedCapacity
    $actualCapacity = (Get-CimInstance -ClassName BatteryFullChargedCapacity -Namespace ROOT/WMI).FullChargedCapacity
    $capacityPercentage = $actualCapacity / $designedCapacity * 100
    $designedCapacity = [string]$designedCapacity + " mHw" #appending units to the capacity values for better readability in the report
} catch {
    
} finally {
    write-host("Battery information retrieval attempted. Check variables for results or errors.")
}
Write-Host("Designed Capacity: $designedCapacity") #outputting battery information to console for testing purposes
<#building html report#>
$htmlContent = @"
<!DOCTYPE html>
<html style="font-family: Arial, sans-serif;"> <!--setting font for the report-->
<head>
    <title>PC Health Check</title>
</head>
<body style="background-color: #3cb4e5;"> <!--setting background color for the report-->
    <h1> Username: $userDetails</h1>
    <p>Last Boot<br> $lastBoot</p>
    <p>Base CPU Speed: $basecpuSpeed Ghz</p>
    <p>Current CPU Speed: $trimmedActualCPUSpeed Ghz</p>
    <p>Domain Connection Status: $domainName / $domainCheck</p>
    <p>Battery Details</p>
    <ul>
        <li>Designed Capacity: $designedCapacity</li>
        <li>Actual Capacity: $actualCapacity mWh</li>
        <li>Battery Capacity Percentage: $capacityPercentage%</li>
    </ul>
</body>
</html>
"@
$htmlContent | Out-File -FilePath "C:\Users\$userName\healthcheck.html" <#exporting html file to user's profile directory#>