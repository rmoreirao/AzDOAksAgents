$env:resourceGroupName = "rg-aks-keda"
$env:clusterName = "aks-01"
$env:location = "uksouth"
$env:registryName = "acraksinadayrmoreirao"
$env:azdoOrg = "https://dev.azure.com/rmoreiraoms"
$env:azdoPoolName = "k8skeda" 
$env:PAT = "!AZDO_PAT_TOKEN!"
$env:aksAdminGroupName = "rbr-aks-admins-rmoreirao"
$env:keyVaultName = "kv-$env:clusterName"
$env:aksClusterManagedIdentityName = "clustermi"


#Create the resource group if not exists
az group create --name $env:resourceGroupName --location $env:location

$env:AKSAdminGroup = az ad group create --display-name $env:aksAdminGroupName `
                   --mail-nickname $env:aksAdminGroupName `
                   --query "id" -otsv

az acr create --resource-group $env:resourceGroupName `
              --name $env:registryName `
              --sku Basic

az identity create --name $env:aksClusterManagedIdentityName `
                   --resource-group $env:resourceGroupName `
                   --location uksouth 
                 
                 
$env:miResourceId = $(az identity show --resource-group $env:resourceGroupName --name $env:aksClusterManagedIdentityName --query id --output tsv)
$spId=$(az identity show --resource-group $env:resourceGroupName --name $env:aksClusterManagedIdentityName --query principalId --output tsv)
$acrResourceId=$(az acr show --resource-group $env:resourceGroupName --name $env:registryName --query id --output tsv)
# if the command below fails, wait a bit and execute it again
az role assignment create --assignee $spId --scope $acrResourceId --role acrpull

#Add current User to the group
$currentUserId = az ad signed-in-user show --query "id" -otsv 
az ad group member add --group $env:AKSAdminGroup --member-id $currentUserId

#install CLI Tools
az aks install-cli
winget install Helm.Helm

#build containers and push to ACR
$currentFolder = Get-Location

#### BUILD THE .NET 7 App ####
Set-Location .\src\DotNetCoreApp
az acr build -r $env:registryName -t webapp02:latest --platform linux .
Set-Location $currentFolder

#### BUILD THE .NET Framework App ####

## THIS IS NOT WORKING !!! ### 
# Set-Location .\src\DotnetFrameworkApp
# ./msbuild.bat
# az acr build -r $env:registryName -t webapp01:latest --platform windows --verbose --file .\publish . --debug
# Set-Location $currentFolder

#### BUILD THE wINDOWS AZURE DEVOPS AGENT ####
Set-Location .\src\AzDoAgent
az acr build -r $env:registryName `
    --build-arg AZP_URL=$env:azdoOrg `
    --build-arg AZP_TOKEN=$env:PAT `
    --build-arg AZP_POOL=$env:azdoPoolName `
    -t azdowin:latest `
    --platform windows .
    
Set-Location $currentFolder
