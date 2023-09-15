az aks nodepool add --resource-group $env:ResourceGroupName `
    --cluster-name $env:clusterName `
    --nodepool-name npwin `
    --enable-cluster-autoscaler `
    --node-count 1 `
    --min-count 0 `
    --max-count 10 `
    --mode User `
    --node-osdisk-type Ephemeral `
    --os-type Windows `
    --os-sku Windows2019 `
    --node-vm-size Standard_E4bds_v5 `
    --zones 1 2 3 

## Add Managed Disk OS Type
# az aks nodepool add --resource-group $env:ResourceGroupName `
#     --cluster-name $env:clusterName `
#     --nodepool-name npwin3 `
#     --enable-cluster-autoscaler `
#     --node-count 1 `
#     --min-count 0 `
#     --max-count 10 `
#     --mode User `
#     --scale-down-mode Deallocate `
#     --node-osdisk-type Managed `
#     --os-type Windows `
#     --os-sku Windows2019 `
#     --node-vm-size Standard_E4bds_v5 `
#     --zones 1 2 3 

