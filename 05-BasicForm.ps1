<#

    Formulaire d'évaluation 
    A. Petitjean

#>


Import-Module UniversalDashboard

$Page1 = New-UDPage -Name "Simple formulaire" `
                    -Content {
                        New-UDInput -Title "Une description" -Endpoint {
                            param(
                                $TextboxPrenom, 
                                $TextBoxNom, 
                                $Choix1
                            ) 
                             New-UDInputAction -Toast "$TextboxPrenom $TextBoxNom : $Choix1" -Duration 5000

                        } -Content {
                            New-UDInputField -Name TextboxPrenom -Type textbox -Placeholder "Prénom" 
                            New-UDInputField -Name TextboxNom    -Type textbox -Placeholder "Nom" 
                            New-UDInputField -Name Choix1 `
                                             -Placeholder "C'est qui le meilleur ?" `
                                             -Type select `
                                             -Values @(
                                                  "Moi", 
                                                  "Lui", 
                                                  "Jeffrey Snover") 
                        } #-FontColor "black"                    
                    }                                
                    

$Dashboard = New-UDDashboard -Title "Formulaire de démonstration"  -Pages @($Page1)
Start-UDDashboard -Dashboard $Dashboard -Port 8081 