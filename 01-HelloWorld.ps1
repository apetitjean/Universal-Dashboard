$MyDashboard = New-UDDashboard -Title "Hello, World" -Content {
    New-UDCard -Title "Hello, Universal Dashboard" 
}

Start-UDDashboard -Port 8081 -Dashboard $MyDashboard