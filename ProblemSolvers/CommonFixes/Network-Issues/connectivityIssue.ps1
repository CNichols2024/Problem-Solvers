<#Connection Test - Google#>
$pingTest = Test-Connection -ComputerName google.com -Count 4 -ErrorAction SilentlyContinue
if ($pingTest) {
    write-host("Ping test successful. Network connectivity appears to be working.")
} else {
    write-host("Ping test failed. Network connectivity issues detected. Following script to perform the following actions:")
    write-host("1. Flush and register DNS")
    ipconfig /flushdns
    start-sleep -Seconds 5 <#sleep to allow flushdns to take effect#>
    ipconfig /registerdns
    start-sleep -Seconds 5 <#sleep to allow registerdns to take effect#>
    write-host("    Flush and register DNS completed. Retesting connectivity...") <#indented for readbility#>
    write-host("Ping test result: $pingTest")
    if ($pingTest) {
        write-host("Ping test successful after flushing and registering DNS. Network connectivity appears to be working.")
    } else {
        write-host("Ping test still failed after flushing and registering DNS. Further troubleshooting may be required.")
    }
}

write-host("") <#adding a blank line for readability#>

