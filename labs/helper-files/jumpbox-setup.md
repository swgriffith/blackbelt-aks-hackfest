## Create Jumpbox VM
Open the Azure Cloud Shell
https://shell.azure.com

Run the following:
```
RG=<Insert Resource Group Name>
VMName=<Insert Lab VM Name>
LOC=<Insert Azure Region>
az group create -n $RG -l $LOC
az vm create -g $RG -n $VMName --image Centos --generate-ssh-keys --verbose

az vm extension set \
  --resource-group $RG \
  --vm-name $VMName \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings '{"fileUris": ["https://raw.githubusercontent.com/swgriffith/blackbelt-aks-hackfest/master/labs/helper-files/setup.sh"], "commandToExecute": "./setup.sh"}' \
  --verbose
```


## Jumpbox updates

Internal use only

## Install Mongo

* Terminal: `sudo vi /etc/yum.repos.d/mongodb-org.repo`

* Add the following:

```
[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
```

* Run `sudo yum install mongodb-org`

* Change port to 27019 in mongo config. `sudo vi /etc/mongod.conf`

* Run `sudo systemctl start mongod`

* Test connection `mongo localhost:27019`

## Update tools (eg AZ CLI)

Avoid version 2.4 since it has a bug. Use version 2.3

```
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

sudo yum install azure-cli-2.0.23-1.el7
```

## Install Docker

```
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce

sudo systemctl start docker

sudo usermod -aG docker stephen
```
Log out and back in to refresh groups

## Install Git
```
sudo yum install git
```

## Install NodeJS & NPM

```
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs

```


## Clean up Docker

```
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images)
```

