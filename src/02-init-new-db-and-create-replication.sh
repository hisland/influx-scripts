#!/bin/bash

# 需要安装工具 jq: https://jqlang.github.io/jq/download/

# 随机后缀, 不用管
RND=$RANDOM

# 本地的 4 个信息
# 需要是一个未初始化新库
LOCAL_URL="http://192.168.1.222:9025"
LOCAL_USER_NAME=eli
LOCAL_USER_PWD=test1234
LOCAL_ORG_NAME=el
LOCAL_BUCKET_NAME=industry_security_t_alpha

# 远端的 4 个信息
# 需要将 TOKEN, ORG_ID, BUCKET_NAME 创建好
REMOTE_URL="http://192.168.1.222:9023"
REMOTE_TOKEN="dergxW1hvsEfqFo2S7dog_ZhhXr5XkYopmYQm_Xuc6KzfHRgr0sNvzLkmTTtn8rz7ggY87vWhtPmk08sYHYK6A=="
REMOTE_ORG_ID="ce9690fafdee5814"
REMOTE_BUCKET_NAME=industry_security_t_beta

echo
echo "1."
echo "REMOTE org list, "
echo "请检查是否存在 REMOTE_ORG_ID: $REMOTE_ORG_ID"
influx org ls \
  --host $REMOTE_URL \
  --token $REMOTE_TOKEN

echo
echo "2."
echo "检查 REMOTE bucket 是否存在"
influx bucket ls \
  --host $REMOTE_URL \
  --token $REMOTE_TOKEN \
  --org-id $REMOTE_ORG_ID \
  --name $REMOTE_BUCKET_NAME --json
if [ $? -ne 0 ]; then
    echo
    echo "ERROR: REMOTE_BUCKET_NAME: $REMOTE_BUCKET_NAME bucket不存在, 请先去创建"
    echo
    exit 1
fi

echo
echo "3."
echo "开始初始化本地库"
# 初始化 LOCAL_URL
influx setup \
  --host $LOCAL_URL \
  --name "elconfig_$RND" \
  --username $LOCAL_USER_NAME \
  --password $LOCAL_USER_PWD \
  --org $LOCAL_ORG_NAME \
  --bucket $LOCAL_BUCKET_NAME \
  --force

# 需要保证 LOCAL_URL 是全新未初始化的库, 否则会失败
if [ $? -ne 0 ]; then
    echo "$LOCAL_URL 已经被初始化过了, 不能使用此脚本"
    exit 1
fi
echo "开始初始化本地库 ok"
echo

LOCAL_INFLUX_BUCKET_ID=$(influx bucket ls -n $LOCAL_BUCKET_NAME --json|jq -r '.[0].id')
echo "LOCAL_INFLUX_BUCKET_ID: $LOCAL_INFLUX_BUCKET_ID"


echo
echo "4."
echo "建立 REMOTE"
REMOTE_NEW_NAME="remote_for_replica_$RND"
tt=$(influx remote create \
  --json \
  --name $REMOTE_NEW_NAME \
  --remote-url $REMOTE_URL \
  --remote-api-token $REMOTE_TOKEN \
  --remote-org-id $REMOTE_ORG_ID)

REMOTE_ID=`echo $tt|jq -r '.id'`
echo "REMOTE 信息:"
influx remote ls --json
echo "建立 REMOTE ok: $bb"


echo
echo "5."
echo "建立 replication"
REPLICA_NEW_NAME="replica_$RND"
influx replication create \
  --json \
  --name $REPLICA_NEW_NAME \
  --remote-id $REMOTE_ID \
  --local-bucket-id $LOCAL_INFLUX_BUCKET_ID \
  --remote-bucket $REMOTE_BUCKET_NAME
echo "建立 replication ok"

echo
echo
echo "完成, 请查看是否正确"
