$organization = "hammadhchandio"
$MyPat = 'ixoj3ke7evy7bjacaupqog44jr5fis22ugccckvl2pkrzvaewkyq'
$B64Pat = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$MyPat"))
$poolName= "VMSSPool"
$serviceEndpointId = 'dd9843d5-bbf1-409f-9ac6-7f1af1e21e6b' # The resource Id of the ARM service connection, against which we authenticate access to the VMSS resource in Azure subscription
$serviceEndpointScope = '997d0fb7-b08d-4095-ab4d-9258e6a4cdd5' # Typically the Id of the project where the ARM service connection is generated

$azureSubId = "b9400fd0-5bf2-4045-a52b-67fc2bf96015"
$vmssResourceId = "/subscriptions/$azureSubId/resourceGroups/VMSS-AGENT-RG/providers/Microsoft.Compute/virtualMachineScaleSets/cvmsslinmax001"

$URL = "https://dev.azure.com/$organization/_apis/distributedtask/elasticpools?poolName=$poolName&authorizeAllPipelines=true&autoProvisionProjectPools=true&api-version=7.1-preview.1"

$headers = @{
    'Authorization' = 'Basic ' + $B64Pat
    'Content-Type' = 'application/json'
}

$body = @{
    agentInteractiveUI = $false
    azureId = $vmssResourceId
    desiredIdle = 1
    maxCapacity = 5
    osType = 1
    maxSavedNodeCount = 0
    recycleAfterEachUse = $false
    serviceEndpointId = $serviceEndpointId
    serviceEndpointScope = $serviceEndpointScope
    timeToLiveMinutes = 15
} | ConvertTo-Json

$response = Invoke-RestMethod -Method Post -Uri $URL -Headers $headers -Body $body
$response | ConvertTo-Json -Depth 10

# ALL Projects - List GET https://dev.azure.com/{organization}/_apis/projects?api-version=7.1-preview.4
# $projectsURL = "https://dev.azure.com/$organization/_apis/projects?api-version=7.1-preview.4"
# $projects = Invoke-RestMethod -Method Get -Uri $projectsURL -Headers $headers
# $projects | ConvertTo-Json -Depth 10