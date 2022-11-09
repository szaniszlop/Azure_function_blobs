#!bin/bash

export myrg="functionAppRg"
export sbId="$(az account show --query 'id' --out tsv | sed -e 's/\r//g')"
export fnAppName="blobfunctions-1666431214276"
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"