<#
    .SYNOPSIS
     The script exports all user tables to separate CSV files.
     Author: Dmitry Demin dmitrydemin1973@gmail.com

    .DESCRIPTION
     In the script, the format for displaying the date and decimal separator is configured.

    .PARAMETER username
    Specify the username  for example SCOTT

    .PARAMETER password
    Specify the password  for example TIGER

    .PARAMETER connect_string
    Specify the connect_string(TNS alias)  for connect to database from $ORACLE_HOME/network/admin/tnsnames.ora.  

    .PARAMETER csv_dir_path
    Specify the csv directory for csv files

    .PARAMETER  log_file
    Specify the  log file for this script.  


    .EXAMPLE
      The script exports all user tables to separate CSV files.
    .\run_export_all_tables.ps1 -username SCOTT -password tiger -connect_string ORCL -csv_dir_path C:\upwork\powershell_sqlplus_export_csv\csv\  -log_file log_file.log
#>


param(
[string]$username = "scott", 
[string]$password = "tiger",
[string]$connect_string = "esmd",
[string]$csv_dir_path = "C:\upwork\powershell_sqlplus_export_csv\csv\",
[string]$log_file = "C:\upwork\powershell_sqlplus_export_csv\log_file.log"
)
# Column separator for csv file 
$COLSEP=";"
# NLS_NUMERIC_CHARACTERS
$NLS_NUMERIC_CHARACTERS=".,"
$NLS_DATE_FORMAT="DD.MM.YYYY HH24:MI:SS"
# Log file 
$full_log_path=$log_file
# CSV directory
$full_csv_path=$csv_dir_path
#csv file extension
$csv_ext=".csv"
#Set NLS_LANG for session sqlplus 
#"RUSSIAN_CIS.UTF8"
#"RUSSIAN_CIS.CL8MSWIN1251"
#"AMERICAN_AMERICA.UTF8"
$NLS_LANG="AMERICAN_AMERICA.CL8MSWIN1251"
#$NLS_LANG="AMERICAN_AMERICA.UTF8"

#Set NLS_LANG for session sqlplus 
[Environment]::SetEnvironmentVariable("NLS_LANG",$NLS_LANG , [System.EnvironmentVariableTarget]::PROCESS)
$env_path_NLS=[Environment]::GetEnvironmentVariable("NLS_LANG", [EnvironmentVariableTarget]::PROCESS)

echo "SET session NLS_LANG: $env_path_NLS" | tee-object -Append  -filepath $full_log_path


$sqlQuery_show_user_tables = 
@"
set heading off
set termout OFF
SET FEEDBACK OFF
SET TAB OFF
set pause off
set verify off
SET UNDERLINE OFF
set trimspool on
set timing off
set echo off
set linesize 1000
set pagesize 100
select  TNAME  from tab where tabtype='TABLE' and tname not like 'BIN$%'
;
exit
"@

$SqlQueryExportTable1 = 
@"
set heading off
set termout OFF
SET FEEDBACK OFF
SET TAB OFF
set pause off
set verify off
SET UNDERLINE OFF
set trimspool on
set timing off
set echo off
set linesize 10000
set pagesize 0
SET COLSEP '$COLSEP'
ALTER SESSION SET NLS_NUMERIC_CHARACTERS='$NLS_NUMERIC_CHARACTERS';
ALTER SESSION SET NLS_DATE_FORMAT='$NLS_DATE_FORMAT'; 
select * from   
"@

$SqlQueryExportTable2 =
@"

exit
"@


function Check_File
{
     param (
          [string]$pathfile 
     )


try {
$A=Get-Content -Path $pathfile  -ErrorAction Stop
}
catch [System.UnauthorizedAccessException]
{
#Write-Host "File $pathfile  is not accessible."
echo "File $pathfile  is not accessible." | tee-object -Append  -filepath $full_log_path


exit
}

catch [System.Management.Automation.ItemNotFoundException]
{
#Write-Host "File $pathfile  is not found."
echo "File $pathfile  is not found." | tee-object -Append  -filepath $full_log_path
exit
}
catch {
Write-Host "File $pathfile.  Other type of error was found:"
#Write-Host "Exception type is $($_.Exception.GetType().Name)"
   echo "Exception type is $($_.Exception.GetType().Name)" | tee-object -Append  -filepath $full_log_path
exit
}

}

                         
echo "===========================================================================================" | tee-object -Append  -filepath $full_log_path



$date_time_start = Get-Date -Format "yyyy-MM-dd HH:mm:ss"            
$date_time_log = Get-Date -Format "yyyyMMddHHmmss"            

Write-host "Script start time : $date_time_start "
try
{
echo "Script start time :  $date_time_start ">>$full_log_path
}
catch {
Write-Host "Log File $full_log_path.  Other type of error was found:"
Write-Host "Exception type is $($_.Exception.GetType().Name)"
exit
}


chcp 1251

$sqlQuery =  $sqlQuery_show_user_tables

$sqlOutput = $sqlQuery | sqlplus -s  $username/$password@$connect_string

$UserList =$sqlOutput| where {$_-notlike "" }
$i=1

   echo  "Found tables for export : " | tee-object -Append  -filepath $full_log_path

foreach ($user_tab in $UserList)
{
   echo " $i $user_tab"  | tee-object -Append  -filepath $full_log_path
   $i=$i+1
}


foreach ($user_tab in $UserList)
{
$sqlQuery_show_table_all=""

$sqlQuery_show_table_all=$SqlQueryExportTable1+ $user_tab+ $SqlQueryExportTable2

$full_csv_path_file=$full_csv_path +  $user_tab + "_" + $date_time_log + $csv_ext

echo "-------------------------------------------------------------------------------------------"  | tee-object -Append  -filepath $full_log_path
echo "For table : $user_tab will be created new csv file: $full_csv_path_file" | tee-object -Append  -filepath $full_log_path


echo  "Script will run for table: $user_tab "  | tee-object -Append  -filepath $full_log_path

$sqlOutput_tab = $sqlQuery_show_table_all | sqlplus -s $username/$password@$connect_string
$sqlOutput_count = $sqlOutput_tab.count
 if ($sqlOutput_tab.count -gt 0) 
{
Out-File -filepath $full_csv_path_file -append -inputobject $sqlOutput_tab -encoding default
echo  "Exported rows:  $sqlOutput_count "  | tee-object -Append  -filepath $full_log_path
}
else
{
echo  "No exported rows: 0 row"  | tee-object -Append  -filepath $full_log_path
echo  "$full_csv_path_file file not created "  | tee-object -Append  -filepath $full_log_path
}

echo "-------------------------------------------------------------------------------------------"  | tee-object -Append  -filepath $full_log_path
}



