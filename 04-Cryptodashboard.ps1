<#

    Cryptodashboard demo
    A. Petitjean

#>


Import-Module UniversalDashboard
Function Get-PoloniexTickerInfo {
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("USDT_BTC", "USDT_TRX", "USDT_ETH", "USDT_LTC", "USDT_XRP", "USDT_DASH")]
        [String]$Pair
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $URI = 'http://poloniex.com/public?command=returnTicker'
    
    try {
        $res = (Invoke-WebRequest -Uri $URI -UseBasicParsing).content | ConvertFrom-Json
        $res | Select-Object -ExpandProperty $Pair | Select-Object -ExpandProperty last 
    }
    catch {}            
}

$Page1 = New-UDPage -Name "Crypto Dashboard" -Content {
    New-UDRow -Columns {
        New-UDColumn -Size 2 -Endpoint {
            New-UDCounter -Title "Bitcoin" -Icon bitcoin -Format '$0,0.00' -Endpoint { 
                Get-PoloniexTickerInfo -Pair "USDT_BTC" | ConvertTo-Json
            } -AutoRefresh -RefreshInterval 5
        } 

        New-UDColumn -Size 2 {
            New-UDCounter -Title "Tron" -Format '$0,0.00' -Endpoint {
                Get-PoloniexTickerInfo -Pair "USDT_TRX" | ConvertTo-Json
            } -AutoRefresh -RefreshInterval 5
        }

        New-UDColumn -Size 2 {
            New-UDCounter -Title "Ethereum" -Format '$0,0.00' -Endpoint {
                Get-PoloniexTickerInfo -Pair "USDT_ETH" | ConvertTo-Json
            } -AutoRefresh -RefreshInterval 5
        }

        New-UDColumn -Size 2 {
            New-UDCounter -Title "Litecoin" -Format '$0,0.00' -Endpoint {
                Get-PoloniexTickerInfo -Pair "USDT_LTC" | ConvertTo-Json
            } -AutoRefresh -RefreshInterval 5
        }

        New-UDColumn -Size 2 {
            New-UDCounter -Title "Ripple" -Format '$0,0.00' -Endpoint {
                Get-PoloniexTickerInfo -Pair "USDT_XRP" | ConvertTo-Json
            } -AutoRefresh -RefreshInterval 5
        }

        New-UDColumn -Size 2 {
            New-UDCounter -Title "Dash" -Format '$0,0.00' -Endpoint {
                Get-PoloniexTickerInfo -Pair "USDT_DASH" | ConvertTo-Json
            } -AutoRefresh -RefreshInterval 5
        }
    } 

 
                     } 

$EI = New-UDEndpointInitialization -Function Get-PoloniexTickerInfo                                                            
$Dashboard = New-UDDashboard -Title "Marché des crypto monnaies"  -Pages @($Page1) -EndpointInitialization $EI
Start-UDDashboard -Dashboard $Dashboard -Port 8081 