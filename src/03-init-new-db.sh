#!/bin/bash

# 需要安装工具 jq: https://jqlang.github.io/jq/download/

# 随机后缀, 不用管
RND=$RANDOM

# 本地的 4 个信息
# 需要是一个未初始化新库
LOCAL_URL="http://192.168.1.222:9025" # 用外部可访问的地址, 不要用 localhost
LOCAL_USER_NAME=eli
LOCAL_USER_PWD=test1234
LOCAL_ORG_NAME=el
LOCAL_BUCKET_NAME=industry_security_t_alpha

echo
echo "开始初始化本地库"
# 初始化 LOCAL_URL
influx setup \
  --json \
  --host $LOCAL_URL \
  --name "elconfig_$RND" \
  --username $LOCAL_USER_NAME \
  --password $LOCAL_USER_PWD \
  --org $LOCAL_ORG_NAME \
  --bucket $LOCAL_BUCKET_NAME \
  --force

# 需要保证 LOCAL_URL 是全新未初始化的库, 否则会失败
if [ $? -ne 0 ]; then
  echo "$LOCAL_URL 已经被初始化过了, 不能使用此脚本!"
  exit 1
fi
echo "开始初始化本地库 ok"
echo

LOCAL_TOKEN=`influx auth ls --user $LOCAL_USER_NAME --json | jq -r '.[0].token'`
LOCAL_ORG_ID=`influx org ls --json | jq -r '.[0].id'`

cat <<EOF > remote_vars.sh
#!/bin/bash

REMOTE_URL="$LOCAL_URL"
REMOTE_TOKEN="$LOCAL_TOKEN"
REMOTE_ORG_ID="$LOCAL_ORG_ID"
REMOTE_BUCKET_NAME=$LOCAL_BUCKET_NAME
EOF
