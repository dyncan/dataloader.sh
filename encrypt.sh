#/bin/sh

# loading .env file
export $(cat .env | xargs)

rm -f config.properties && touch config.properties

# Write properties to config.properties file
echo "sf.from.endpoint=$SFDC_FROM_ENDPOINT" > config.properties
echo "sf.from.username=$SFDC_FROM_USERNAME" >> config.properties
echo "sf.to.endpoint=$SFDC_TO_ENDPOINT" >> config.properties
echo "sf.to.username=$SFDC_TO_USERNAME" >> config.properties
echo "process.encryptionKeyFile=$PROCESS_ENCRYPTIONKEYFILE" >> config.properties
echo "process.enableLastRunOutput=$PROCESS_ENABLELASTRUNOUTPUT" >> config.properties
echo "process.enableExtractStatusOutput=$PROCESS_ENABLEEXTRACTSTATUSOUTPUT" >> config.properties
echo "dataAccess.readUTF8=$DATAACCESS_READUTF8" >> config.properties
echo "dataAccess.writeUTF8=$DATAACCESS_WRITEUTF8" >> config.properties
echo "sfdc.useBulkApi=$SFDC_USEBULKAPI" >> config.properties
echo "sfdc.timeoutSecs=$SFDC_TIMEOUTSECS" >> config.properties
echo "sfdc.noCompression=$SFDC_NOCOMPRESSION" >> config.properties
echo "sfdc.bulkApiCheckStatusInterval=$SFDC_BULKAPICHECKSTATUSINTERVAL" >> config.properties
echo "sfdc.bulkApiSerialMode=$SFDC_BULKAPISERIALMODE" >> config.properties
echo "sfdc.enableRetries=$SFDC_ENABLERETRIES" >> config.properties
echo "sfdc.extractionRequestSize=$SFDC_EXTRACTIONREQUESTSIZE" >> config.properties
echo "sfdc.insertNulls=$SFDC_INSERTNULLS" >> config.properties
echo "sfdc.loadBatchSize=$SFDC_LOADBATCHSIZE" >> config.properties
echo "sfdc.maxRetries=$SFDC_MAXRETRIES" >> config.properties
echo "sfdc.minRetrySleepSecs=$SFDC_MINRETRYSLEEPSECS" >> config.properties
echo "sfdc.debugMessages=$SFDC_DEBUGMESSAGES" >> config.properties
echo "sfdc.timezone=$SFDC_TIMEZONE" >> config.properties
echo "sfdc.externalIdField=$SFDC_EXTERNALIDFIELD" >> config.properties
echo "sfdc.version=$SFDC_VERSION" >> config.properties

# Encrypted passwords
ant encrypt -Dpassword=$SFDC_FROM_PASSWORD -Dapiversion=$SFDC_VERSION > encrypt_from_password.log
encrypt_from_password=$(sed -n '38s/.\{12\}\(.\{64\}\).*/\1/p' encrypt_from_password.log)

echo "The output string of encrypt from password is: $encrypt_from_password"
echo "sfdc.from.password=$encrypt_from_password" >> config.properties


ant encrypt -Dpassword=$SFDC_TO_PASSWORD -Dapiversion=$SFDC_VERSION > encrypt_to_password.log
encrypt_to_password=$(sed -n '38s/.\{12\}\(.\{64\}\).*/\1/p' encrypt_to_password.log)

echo "The output string of encrypt to password is: $encrypt_to_password"
echo "sfdc.to.password=$encrypt_to_password" >> config.properties

rm -f encrypt_from_password.log
rm -f encrypt_to_password.log