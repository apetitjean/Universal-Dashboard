<#

    Formulaire d'évaluation 
    A. Petitjean

#>


Import-Module UniversalDashboard

$EndpointInitializationScript = {        
}

$Page1 = New-UDPage -Name "Evaluation Universal Dashboard" `
                    -Content {
                        New-UDInput -Title "Votre avis compte !" -Endpoint {
                            param(
                                $TextboxSurname, 
                                $TextBoxName, 
                                $TextBoxEmail, 
                                $EvaluationSujet,
                                $EvaluationAnimateur,
                                $TextBoxLibre
                            ) 
                           #  New-UDInputAction -Toast "$TextboxSurname $TextBoxName : $EvaluationSujet"

                            $obj = [PSCustomObject]@{
                                'Nom'        = $TextboxName
                                'Prenom'     = $TextboxSurname 
                                'Email'      = $TextBoxEmail
                                'EvalSujet'  = $EvaluationSujet
                                'EvalAnim'   = $EvaluationAnimateur
                                'TexteLibre' = $TextBoxLibre
                            } 

                            # Invoke-RestMethod http://localhost:80/api/process -Method POST -Body $obj
                        
                            Invoke-RestMethod http://localhost:80/api/process `
                                    -Method POST `
                                    -Body @{name = ($obj  | ConvertTo-Json) } 
                        
                            New-UDInputAction -Toast "Merci ! Nous avons bien pris en compte vos remarques !" `
                                              -ClearInput `
                                              -Duration 5000
                        

                        } -Content {
                            New-UDInputField -Name TextboxSurname -Type textbox -Placeholder "Prénom" 
                            New-UDInputField -Name TextboxName    -Type textbox -Placeholder "Nom" 
                            New-UDInputField -Name TextboxEmail   -Type textbox -Placeholder "Adresse mail" 
                            New-UDInputField -Name EvaluationSujet `
                                             -Placeholder "Qu'avez-vous pensé du sujet ?" `
                                             -Type select `
                                             -Values @(
                                                  "C'était génial !", 
                                                  "C'était bien", 
                                                  "Bof Bof", 
                                                  "Nul à chier !") 
                            New-UDInputField -Name EvaluationAnimateur `
                                             -Placeholder "Qu'avez-vous pensé de l'animateur ?" `
                                             -Type select `
                                             -Values @(
                                                  "Super", 
                                                  "Bien", 
                                                  "Bof Bof", 
                                                  "Nul à chier !") 
                            New-UDInputField -Name TextboxLibre   -Type textbox -Placeholder "Ne soyez pas timide, exprimez vous !!! :-)" 

                        } #-FontColor "black"
                    
                        # New-UDInputAction -Toast "Clicked!"    
                    }                                
                    

$Dashboard = New-UDDashboard -Title "Formulaire d'évaluation Universal Dashboard - Arnaud PETITJEAN"  -Pages @($Page1) -EndpointInitializationScript $EndpointInitializationScript
Start-UDDashboard -Dashboard $Dashboard -Port 8081 