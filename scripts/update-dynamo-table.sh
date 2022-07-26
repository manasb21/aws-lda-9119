#!/usr/bin/env bash

set -xe

hashkey=$1
message=$2

sed -i ''  "s/HASHKEY/${hashkey}/g" dynamodbData/item.json
sed -i '' "s/MESSAGE/${message}/g" dynamodbData/item.json


aws dynamodb put-item --table-name ppro-${hashkey} --item file://dynamodbData/item.json



sed -i ''  "s/${hashkey}/HASHKEY/g" dynamodbData/item.json
sed -i '' "s/${message}/MESSAGE/g" dynamodbData/item.json