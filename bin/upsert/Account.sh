#/bin/sh

source .env

apiversion=$SFDC_VERSION
externalId=$SFDC_EXTERNALIDFIELD

ant upsert -Dsobject_name=Account -Dsdl="./sdl/Account.sdl" -Dcsv="../upsert/csv/Account_All.csv" -Dextid=$externalId -Dapiversion=$apiversion

if [ $? -eq 0 ]; then
    echo ""
    echo ""
    echo ">>>>>>>>>>>>>>>>>>>>> Account_All Upsert Succeed >>>>>>>>>>>>>>>>>>>>>"
    echo ""
    echo ""
else
    echo ""
    echo ""
    echo "～～～～～～～～～～～～ Account_All Upsert Failed ～～～～～～～～～～～～"
    echo ""
    echo ""
    exit 1
fi