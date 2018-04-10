## Create Jumpbox VM
Open the Azure Cloud Shell
https://shell.azure.com

Execute the following commands in order to create a new resource group and VM configured for the lab:
```
RG=<Insert Resource Group Name>
VMName=<Insert Lab VM Name>
LOC=<Insert Azure Region>
az group create -n $RG -l $LOC
az vm create -g $RG -n $VMName --image Centos --generate-ssh-keys --verbose

az vm open-port --resource-group $RG --name $VMName --port 8080

az vm extension set \
  --resource-group $RG \
  --vm-name $VMName \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings '{"fileUris": ["https://raw.githubusercontent.com/swgriffith/blackbelt-aks-hackfest/master/labs/helper-files/setup.sh"], "commandToExecute": "./setup.sh"}' \
  --verbose

```



## Clean up Docker

```
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images)
```

