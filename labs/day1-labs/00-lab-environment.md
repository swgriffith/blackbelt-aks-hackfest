# Lab Environment

## Classroom Setting

These labs are designed for delivery in a classroom setting with the **Azure Global Blackbelt Team.** We typically provide an Azure subscription and a Linux VM (jumpbox) for attendees to complete the labs.

## Create Jumpbox VM
Open the Azure Cloud Shell
https://shell.azure.com

Execute the following commands in order to create a new resource group and VM configured for the lab:
```
RG=<Insert Resource Group Name>
VMName=<Insert Lab VM Name>
LOC=<Insert Azure Region>
az group create -n $RG -l $LOC
az vm create -g $RG -n $VMName --image Centos --generate-ssh-keys --public-ip-address-dns-name $VMName --verbose

az vm open-port --resource-group $RG --name $VMName --port 8080

az vm extension set \
  --resource-group $RG \
  --vm-name $VMName \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings '{"fileUris": ["https://raw.githubusercontent.com/swgriffith/blackbelt-aks-hackfest/master/labs/helper-files/setup.sh"], "commandToExecute": "./setup.sh"}' \
  --verbose

```

## Connect to the Lab VM
Get the public ip of the vm either from the CLI output or by finding the vm in the Azure portal. Using the public ip SSH into the vm:

```
ssh <insert public ip>
#enter yes to accept the certificate add
#enter your certificate password if you set one
```

## Option: Docker without sudo
If you want to run docker without 'sudo' on every command you need to add your user to the docker group as follows:

```
sudo usermod -aG $USER 
```

### Login to the Azure CLI
In order to run the CLI from within the VM you'll need to log in using the following command. This command will prompt you to copy a code and then navigate to the device logon screen where you can paste that code and then authenticate using your standard Azure credentials.

```
az login

#Check your current subscription
az account list -o table

#If your IsDefault is not on the preferred subscription you can change as follows
az account set --subscription <SubscriptionID>
```

Finally, in the Azure CLI you'll want to run the following to make sure you're registered for the providers needed for the lab:

```
az provider register -n Microsoft.Network
az provider register -n Microsoft.Storage
az provider register -n Microsoft.Compute
az provider register -n Microsoft.ContainerService
```

