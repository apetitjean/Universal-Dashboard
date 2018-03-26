<#

    Cryptodashboard demo
    A. Petitjean

#>


Import-Module UniversalDashboard

$EndpointInitializatinScript = {
    Function Get-PoloniexTickerInfo {
        Param (
            [Parameter(Mandatory = $true)]
            [ValidateSet("USDT_BTC", "USDT_BCH", "USDT_ETH", "USDT_LTC", "USDT_XRP", "USDT_DASH")]
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
        
}

$Page1 = New-UDPage -Name "Crypto Dashboard" `
                    -Content {
                                New-UDRow -Columns {
                                    New-UDColumn -Size 2 -Endpoint {
                                        New-UDCounter -Title "Bitcoin" -Icon bitcoin -Format '$0,0.00' -Endpoint { 
                                            Get-PoloniexTickerInfo -Pair "USDT_BTC" | ConvertTo-Json
                                        } -AutoRefresh -RefreshInterval 5
                                    } 

                                    New-UDColumn -Size 2 {
                                        New-UDCounter -Title "Bitcoin Cash" -Icon btc -Format '$0,0.00' -Endpoint {
                                            Get-PoloniexTickerInfo -Pair "USDT_BCH" | ConvertTo-Json
                                        } -AutoRefresh -RefreshInterval 5
                                    }

                                    New-UDColumn -Size 2 {
                                        New-UDCounter -Title "Ethereum" -Icon dollar -Format '$0,0.00' -Endpoint {
                                            Get-PoloniexTickerInfo -Pair "USDT_ETH" | ConvertTo-Json
                                        } -AutoRefresh -RefreshInterval 5
                                    }

                                    New-UDColumn -Size 2 {
                                        New-UDCounter -Title "Litecoin" -Icon dollar -Format '$0,0.00' -Endpoint {
                                            Get-PoloniexTickerInfo -Pair "USDT_LTC" | ConvertTo-Json
                                        } -AutoRefresh -RefreshInterval 5
                                    }

                                    New-UDColumn -Size 2 {
                                        New-UDCounter -Title "Ripple" -Format '$0,0.00' -Icon dollar -Endpoint {
                                            Get-PoloniexTickerInfo -Pair "USDT_XRP" | ConvertTo-Json
                                        } -AutoRefresh -RefreshInterval 5
                                    }

                                    New-UDColumn -Size 2 {
                                        New-UDCounter -Title "Dash" -Icon dollar -Format '$0,0.00' -Endpoint {
                                            Get-PoloniexTickerInfo -Pair "USDT_DASH" | ConvertTo-Json
                                        } -AutoRefresh -RefreshInterval 5
                                    }
                                } 

                                New-UDRow -Columns {
                                    New-UDColumn -Size 6 {
                                        New-UDMonitor -Title 'Suivi temps réel du cours du Bitcoin' `
                                                      -Type Line -DataPointHistory 120 `
                                                      -Options @{ 'fill' = $true } `
                                                      -RefreshInterval 10 `
                                                      -Endpoint {
                                            Get-PoloniexTickerInfo -Pair "USDT_BTC" | Out-UDMonitorData
                                        }
                                    }
                                    New-UDColumn -Size 6 {
                                       New-UDChart -Title "Cours de l'action Microsoft" -Type Line  `
                                                -Endpoint {
                                                    $StockData = Invoke-RestMethod -Uri 'https://api.iextrading.com/1.0/stock/msft/chart/6m' -Method Get 
                                                    $StockData | Out-UDChartData -LabelProperty 'date' -DataProperty 'close'
                                                }
                                    }
                                }  

                                New-UDRow -Columns {
                                    New-UDColumn -Size 12 {
                                        New-UDCounter -Title "Capitalisation totale" -Format '$0,0' -Endpoint {
                                            (Invoke-WebRequest -Uri 'https://api.coinmarketcap.com/v1/global/' -UseBasicParsing -ErrorAction SilentlyContinue).content | 
                                                ConvertFrom-Json | Select-Object -ExpandProperty total_market_cap_usd | 
                                                ConvertTo-Json
                                        } -TextSize Medium -TextAlignment center
                                    }
                                } -AutoRefresh -RefreshInterval 5
                     } 
                                                            
$Dashboard = New-UDDashboard -Title "Marché des crypto monnaies"  -Pages @($Page1) -EndpointInitializationScript $EndpointInitializatinScript
Start-UDDashboard -Dashboard $Dashboard -Port 8081 