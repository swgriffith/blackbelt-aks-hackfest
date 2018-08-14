# Lab Environment

## Classroom Setting

These labs are designed for delivery in a classroom setting with the **Azure Global Blackbelt Team.** To avoid local machine setup inconsistency we recommend using a pre-configured jump box. The following steps will create that jump box. ***This setup process will take approximately 30 minutes.***

## Create Jumpbox VM
Open the Azure Cloud Shell
https://shell.azure.com

Execute the following commands in order to create a new resource group and VM configured for the lab:
```
#Resource Group Name
RG=<Insert Resource Group Name>

#Name to be used for the VM and DNS. Try to make it unique.
VMName=<Insert Lab VM Name>

#Azure Region (ex. westus, westus2)
LOC=<Insert Azure Region>

#If you dont already have a resource group created run this
az group create -n $RG -l $LOC

#Create the VM
az vm create -g $RG -n $VMName -l $LOC --image Centos --generate-ssh-keys --public-ip-address-dns-name $VMName --verbose

#Open the port for the web application in the Azure Network Security Group
az vm open-port --resource-group $RG --name $VMName --port 8080 --priority 100

#Open the port for RDP into the Lab VM
az vm open-port --resource-group $RG --name $VMName --port 3389 --priority 101

#Execute the setup script to install required components [this will take ~20 minutes]
az vm extension set \
  --resource-group $RG \
  --vm-name $VMName \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings '{"fileUris": ["https://gist.githubusercontent.com/swgriffith/f330ff4b2084fa9787109c36da831876/raw/0be290cc2042fc7baa5d9eb8c4b1e3b8601169a8/setup.sh"], "commandToExecute": "./setup.sh"}' \
  --verbose

```

## Connect to the Lab VM
Get the public ip of the vm either from the CLI output or by finding the vm in the Azure portal. Using the public ip SSH into the vm:

```
ssh <insert public ip>
#enter yes to accept the certificate add
#enter your certificate password if you set one
```

## Set your user password
While most authentication to the jump box will use ssh certificate based authentication, for some of the labs you may choose to RDP into the server, which will require a pasword for your user account. Run the following to set your user password:

```
sudo passwd $USER
```

## Option: Docker without sudo
If you want to run docker without 'sudo' on every command you need to add your user to the docker group as follows:

```
sudo usermod -aG docker $USER 
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

You're subscription must have the following providers registered. If you dont have permission to run the following then contact a subscription owner.

```
az provider register -n Microsoft.Network
az provider register -n Microsoft.Storage
az provider register -n Microsoft.Compute
az provider register -n Microsoft.ContainerService
az provider register -n Microsoft.ContainerRegistry
```

