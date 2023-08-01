# Resources: https://learn.microsoft.com/en-Us/azure/azure-monitor/containers/container-insights-enable-aks?tabs=azure-cli

$env:logAnalyticsWorkspaceName = "loga-$env:clusterName"

# Create Log Analytics workspace
az monitor log-analytics workspace create `
    --resource-group $env:ResourceGroupName `
    --workspace-name $env:logAnalyticsWorkspaceName

# Get the workspace ID and key
$logAnalyticsResourceId = $(az monitor log-analytics workspace show `
    --resource-group $env:ResourceGroupName `
    --workspace-name $env:logAnalyticsWorkspaceName --query id -o tsv)

# Enable Container Insights
az aks enable-addons -a monitoring -n $env:clusterName -g $env:ResourceGroupName --workspace-resource-id $logAnalyticsResourceId


Sample Monitoring Queries:

// List container logs per namespace 
// View container logs from all the namespaces in the cluster. 
ContainerLog
|where TimeGenerated > startofday(ago(1d))
|join kind=inner (
KubePodInventory
| where TimeGenerated > startofday(ago(1d))
| where Name contains "azdevops-scaledjob"
| distinct Computer, ContainerID, Namespace, Name
)//KubePodInventory Contains namespace information
on Computer, ContainerID
| order by TimeGenerated 