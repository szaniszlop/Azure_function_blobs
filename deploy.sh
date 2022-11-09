#!/bin/bash

./login.sh
	
. ./config.sh

set -e 

az group create --name $myrg --location westeurope

az deployment group create \
  --name FunctionsAppDeployment \
  --resource-group $myrg \
  --template-file functionApp.json \
  --parameters '@functionApp.parameters.json'
 
mvn clean package -DfnAppName=${fnAppName} -DmyRg=${myrg}

if [[ -d ./target/azure-functions/${fnAppName} ]]; then
  mydir=$(pwd)
  cd ./target/azure-functions/${fnAppName}
  zip -r9 ${mydir}/target/${fnAppName}.zip  ./*
  cd ${mydir}
  fnApp=$(az resource list -g functionAppRg --query "[?kind == 'functionapp' && type == 'Microsoft.Web/sites' ].name" -o tsv | sed -e 's/\r//g')
  az functionapp deployment source config-zip -g ${myrg} -n ${fnApp} --src ./target/${fnAppName}.zip 
fi
