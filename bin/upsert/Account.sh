#/bin/sh

apiversion=50

ant upsert -Dsobject_name=Account -Dsdl="./sdl/Account.sdl" -Dcsv="../upsert/csv/Account_All.csv" -Dextid="Integration_Id__c" -Dapiversion=$apiversion

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