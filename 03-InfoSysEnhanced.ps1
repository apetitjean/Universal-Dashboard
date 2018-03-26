$MyDashboard = New-UDDashboard -Title "Dashboard système" -Content {
    New-UDRow -Columns {
        New-UDColumn -Size 6 -Content {
            New-UDTable -Title "Informations" -Headers @(" ", " ") -Endpoint {
                @{
                'Computer Name'         = $env:COMPUTERNAME
                'Operating System'      = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
                'Total Disk Space (C:)' = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB | ForEach-Object { "$([Math]::Round($_, 2)) GB " }
                'Free Disk Space (C:)'  = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace / 1GB | ForEach-Object { "$([Math]::Round($_, 2)) GB " }
                }.GetEnumerator() | Out-UDTableData -Property @("Name", "Value")
            }
        }
    
        New-UDColumn -Size 6 -Content {
            New-UdMonitor -Title "CPU (% processor time)" `
                          -Type Line `
                          -DataPointHistory 20 `
                          -ChartBackgroundColor '#80FF6B63' `
                          -ChartBorderColor '#FFFF6B63' `
                          -Endpoint {
                Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue | 
                    Select-Object -ExpandProperty CounterSamples | 
                    Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
            } -AutoRefresh -RefreshInterval 3
        }
    } # Row
}

Start-UDDashboard -Port 8081 -Dashboard $MyDashboard