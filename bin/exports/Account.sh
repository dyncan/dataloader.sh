#/bin/sh

apiversion=$1

ant start_export -Dsobject_name=Account -Dcsv_file_name="All" -Dsoql="select CreatedById, CreatedDate, Integration_Id__c, LastActivityDate, LastModifiedById, LastModifiedDate from Account LIMIT 1 " -Dapiversion=$apiversion

if [ $? -eq 0 ]; then
    echo ">>>>>>>>>>>>>>>>>>>>> Account Export Succeed >>>>>>>>>>>>>>>>>>>>>"
    echo ""
    echo ""
else
    echo "～～～～～～～～～～～～ Account Export Failed ～～～～～～～～～～～～"
    echo ""
    echo ""
    exit 1
fi