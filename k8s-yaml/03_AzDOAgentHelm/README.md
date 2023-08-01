## To generate the template

helm template AzDOAgent

## To apply the template

helm upgrade --install --atomic --wait azdoagent ./AzDOAgent --namespace azdo

## To apply the template overriding values from values.yaml
- Generate the template: helm template azdoagent --set azdo.pat=vxb5xam7mn36wniw45nymkisgudqteikuv2b7fpaigo7rsbpev2a --set pool=k8skeda -f ./AzDOAgent/values_incomplete.yaml

- Apply the template: helm upgrade --install --atomic --wait azdoagent ./AzDOAgent --namespace azdo --set azdo.pat=vxb5xam7mn36wniw45nymkisgudqteikuv2b7fpaigo7rsbpev2a --set pool=k8skeda -f values_incomplete.yaml

## To uninstall the template

helm uninstall azdoagent  --namespace azdo

## For the Azure Pipeline

https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/helm-deploy-v0?view=azure-pipelines