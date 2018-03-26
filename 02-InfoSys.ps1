$MyDashboard = New-UDDashboard -Title "Informations système" -Content {
    New-UDTable -Title "Espace disque" -Headers @(" ", " ") -Endpoint {
        @{
           'Computer Name'         = $env:COMPUTERNAME
           'Operating System'      = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
           'Total Disk Space (C:)' = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB | ForEach-Object { "$([Math]::Round($_, 2)) GB " }
           'Free Disk Space (C:)'  = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace / 1GB | ForEach-Object { "$([Math]::Round($_, 2)) GB " }
         }.GetEnumerator() | Out-UDTableData -Property @("Name", "Value")
    }     
}

Start-UDDashboard -Port 8081 -Dashboard $MyDashboard