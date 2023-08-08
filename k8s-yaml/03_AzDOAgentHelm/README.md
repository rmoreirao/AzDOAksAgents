## To generate the template

helm template AzDOAgent

## To apply the template

helm upgrade --install --atomic --wait azdoagent ./AzDOAgent --namespace azdo

## To apply the template overriding values from values.yaml
- Generate the template: helm template azdoagent --set azdo.pat=!AZDO_PAT_TOKEN! --set pool=k8skeda -f ./AzDOAgent/values_incomplete.yaml

- Apply the template: helm upgrade --install --atomic --wait azdoagent ./AzDOAgent --namespace azdo --set azdo.pat=!AZDO_PAT_TOKEN! --set pool=k8skeda -f values_incomplete.yaml

## To uninstall the template

helm uninstall azdoagent  --namespace azdo

## For the Azure Pipeline

- Doc: https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/helm-deploy-v0?view=azure-pipelines
- Create a Kubernetes Service Connection to use with the Helm pipeline task
- See pipeline: azdo-pipelines\azdo_helm.yml