$Endpoint = New-UDEndpoint -Url "/process" -Method "POST" -Endpoint {
    param($Name)

    #Start-Process -FilePath $Name
    $guid = (New-Guid).Guid
    New-item -Path "C:\temp\$guid.txt" -Value $Name
} 

Start-UDRestApi -Endpoint $Endpoint -Port 80
#Invoke-RestMethod -Uri http://localhost:80/api/process -Body @{Name = "Hello World"} -Method Post