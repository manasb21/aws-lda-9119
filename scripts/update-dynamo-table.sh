#!/usr/bin/env bash



hashkey=$1
message=$2

sed -i -e "s/HASHKEY/${hashkey}/g" dynamodbData/item.json
sed -i -e "s/MESSAGE/${message}/g" dynamodbData/item.json

aws dynamodb put-item --table-name ppro-${hashkey} --item file://dynamodbData/item.json