# Resources: https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver


az aks enable-addons `
    --addons azure-keyvault-secrets-provider `
    --name $env:clusterName `
    --resource-group $env:ResourceGroupName

# Create the Keyvault
az keyvault create -n $env:keyVaultName -g $env:ResourceGroupName -l $env:location

# Add AKS Key Vault secrets
az keyvault secret set --vault-name $env:keyVaultName -n K8S-AZP-TOKEN --value $env:PAT
az keyvault secret set --vault-name $env:keyVaultName -n K8S-AZP-URL --value $env:azdoOrg
az keyvault secret set --vault-name $env:keyVaultName -n K8S-AZP-POOL --value $env:azdoPoolName

# Grant Permissions for the AKS Cluster to access the Key Vault

# There's a specific user created by AKS to connect to the Key Vault: 
# https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-identity-access#access-with-a-user-assigned-managed-identity
$secredtUserId=$(az aks show -g $env:ResourceGroupName -n $env:aksClusterManagedIdentityName --query addonProfiles.azureKeyvaultSecretsProvider.identity.clientId -o tsv)
az keyvault set-policy -n $env:keyVaultName --secret-permissions get --spn $secredtUserId
