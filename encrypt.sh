#!/bin/bash

# 设置错误处理
set -e

# 步骤1: 检查.env文件是否存在
if [ ! -f .env ]; then
    echo "错误: .env 文件不存在"
    exit 1
fi

# 步骤2: 加载环境变量，过滤注释和空行
export $(cat .env | grep -v '^#' | xargs)

# 步骤3: 创建新的config.properties
rm -f config.properties && touch config.properties

# 步骤4: 写入基本配置
cat << EOF > config.properties
sf.from.endpoint=$SFDC_FROM_ENDPOINT
sf.from.username=$SFDC_FROM_USERNAME
sf.to.endpoint=$SFDC_TO_ENDPOINT
sf.to.username=$SFDC_TO_USERNAME
process.encryptionKeyFile=$PROCESS_ENCRYPTIONKEYFILE
process.enableLastRunOutput=$PROCESS_ENABLELASTRUNOUTPUT
process.enableExtractStatusOutput=$PROCESS_ENABLEEXTRACTSTATUSOUTPUT
dataAccess.readUTF8=$DATAACCESS_READUTF8
dataAccess.writeUTF8=$DATAACCESS_WRITEUTF8
sfdc.useBulkApi=$SFDC_USEBULKAPI
sfdc.timeoutSecs=$SFDC_TIMEOUTSECS
sfdc.noCompression=$SFDC_NOCOMPRESSION
sfdc.bulkApiCheckStatusInterval=$SFDC_BULKAPICHECKSTATUSINTERVAL
sfdc.bulkApiSerialMode=$SFDC_BULKAPISERIALMODE
sfdc.enableRetries=$SFDC_ENABLERETRIES
sfdc.extractionRequestSize=$SFDC_EXTRACTIONREQUESTSIZE
sfdc.insertNulls=$SFDC_INSERTNULLS
sfdc.loadBatchSize=$SFDC_LOADBATCHSIZE
sfdc.maxRetries=$SFDC_MAXRETRIES
sfdc.minRetrySleepSecs=$SFDC_MINRETRYSLEEPSECS
sfdc.debugMessages=$SFDC_DEBUGMESSAGES
sfdc.timezone=$SFDC_TIMEZONE
sfdc.externalIdField=$SFDC_EXTERNALIDFIELD
sfdc.version=$SFDC_VERSION
EOF

# 步骤5: 函数定义 - 检查字符串是否为空
is_empty() {
    local var="$1"
    [[ -z "${var// }" ]] && return 0 || return 1
}

# 函数：从日志提取密码
extract_password() {
    local log_file="$1"
    grep "\[java\]" "$log_file" | grep -v "encryption" | sed 's/.*\[java\] *//' | tr -d '[:space:]'
}

# 步骤6: 检查两个密码是否都为空
if is_empty "$SFDC_FROM_PASSWORD" && is_empty "$SFDC_TO_PASSWORD"; then
    echo "警告: FROM 和 TO 密码都为空，跳过加密步骤"
    exit 0
fi

# 步骤7: 处理 FROM 密码
if ! is_empty "$SFDC_FROM_PASSWORD"; then
    echo "处理 FROM 密码..."
    # 执行加密
    ant encrypt -Dpassword=$SFDC_FROM_PASSWORD -Dapiversion=$SFDC_VERSION > encrypt_from_password.log
    # 提取加密后的密码
    sfdc_from_password=$(extract_password encrypt_from_password.log)
    if [ -n "$sfdc_from_password" ]; then
        echo "SFDC FROM 密码加密成功"
        echo "sfdc.from.password=$sfdc_from_password" >> config.properties
    else
        echo "警告: SFDC FROM 密码加密失败"
        echo "日志内容:"
        cat encrypt_from_password.log
    fi
    # 清理日志文件
    rm -f encrypt_from_password.log
else
    echo "跳过 SFDC FROM 密码处理"
fi

# 步骤8: 处理 TO 密码
if ! is_empty "$SFDC_TO_PASSWORD"; then
    echo "处理 SFDC TO 密码..."
    # 执行加密
    ant encrypt -Dpassword=$SFDC_TO_PASSWORD -Dapiversion=$SFDC_VERSION > encrypt_to_password.log
    # 提取加密后的密码
    sfdc_to_password=$(extract_password encrypt_to_password.log)
    if [ -n "$sfdc_to_password" ]; then
        echo "SFDC TO 密码加密成功"
        echo "sfdc.to.password=$sfdc_to_password" >> config.properties
    else
        echo "警告: SFDC TO 密码加密失败"
        echo "日志内容:"
        cat encrypt_to_password.log
    fi
    # 清理日志文件
    rm -f encrypt_to_password.log
else
    echo "跳过 SFDC TO 密码处理"
fi

echo "配置文件生成完成"