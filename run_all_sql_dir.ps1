<#
    .SYNOPSIS
     This script executes all sql files from the specified directory and creates separate log files in a specified directory.
     Author: Dmitry Demin dmitrydemin1973@gmail.com

    .DESCRIPTION
     In the script, the format for displaying the date and decimal separator is configured.

    .PARAMETER username
     Specify the username  for example SCOTT

    .PARAMETER password
     Specify the password  for example TIGER

    .PARAMETER connect_string
     Specify the connect_string(TNS alias)  for connect to database from $ORACLE_HOME/network/admin/tnsnames.ora.  

    .PARAMETER auto_commit
     Specify the autocommit for session. Default autocommit OFF.  

    .PARAMETER sql_path

     Specify the directory for executing sql scripts.

    .PARAMETER logs_path

     Specify the directory for output log.

    .PARAMETER log_file

     Specify the log file.

    .EXAMPLE
     This script executes all sql files from the specified directory and creates separate csv files in a specified directory.
    .\run_export_all_tables.ps1 -username SCOTT -password tiger -connect_string ORCL -sql_path C:\export\sql\  -logs_path  C:\export\log\log_file.log
#>


param(
[string]$username = "scott", 
[string]$password = "tiger",
[string]$connect_string = "192.168.0.166:1521/TEST",
[string]$auto_commit = "OFF",
[string]$sql_path="C:\upwork\powershell-oracle_git\sql\",
[string]$logs_path="C:\upwork\powershell-oracle_git\log\",
[string]$log_file="C:\upwork\powershell-oracle_git\log_file.log"
)
# Column separator for csv file 
$COLSEP=";"
# NLS_NUMERIC_CHARACTERS
$NLS_NUMERIC_CHARACTERS=".,"
$NLS_DATE_FORMAT="DD.MM.YYYY HH24:MI:SS"
#[string]$connect_string = "server2003ora10:1521/ORCL"
# Log file 
$full_sql_path=$sql_path
$full_csv_path=$logs_path
$full_log_path=$log_file
#csv file extension
$csv_ext=".log"
#Set NLS_LANG for session sqlplus 
#"RUSSIAN_CIS.UTF8"
#"RUSSIAN_CIS.CL8MSWIN1251"
#"AMERICAN_AMERICA.UTF8"
#$NLS_LANG="RUSSIAN_CIS.CL8MSWIN1251"
$NLS_LANG="AMERICAN_AMERICA.CL8MSWIN1251"
#$NLS_LANG="AMERICAN_AMERICA.UTF8"

#Set NLS_LANG for session sqlplus 
[Environment]::SetEnvironmentVariable("NLS_LANG",$NLS_LANG , [System.EnvironmentVariableTarget]::PROCESS)
$env_path_NLS=[Environment]::GetEnvironmentVariable("NLS_LANG", [EnvironmentVariableTarget]::PROCESS)

echo "SET session NLS_LANG: $env_path_NLS" | tee-object -Append  -filepath $full_log_path


$SqlQueryExportTable1 = 
@"

set autocommit $AUTO_COMMIT
set define off
set timing on
set linesize 10000
set pagesize 10000
set pause off
set echo on
set heading on
set termout ON
SET FEEDBACK ON
SET TAB ON
SET UNDERLINE ON
set trimspool on

ALTER SESSION SET NLS_NUMERIC_CHARACTERS='$NLS_NUMERIC_CHARACTERS';
ALTER SESSION SET NLS_DATE_FORMAT='$NLS_DATE_FORMAT'; 
   
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


#chcp 1251

$sqlQuery_show_table_all=$SqlQueryExportTable1

$files_input = Get-Childitem -File $full_sql_path  

foreach ($file_input in $files_input)
{

  $full_sql_path_file=$full_sql_path+$file_input 
  echo  "Found SQL file  $full_sql_path_file  " | tee-object -Append  -filepath $full_log_path

  $user_tab="@" + $full_sql_path_file+" "

  $sqlQuery_show_table_all=$sqlQuery_show_table_all+"PROMPT Start script: "+$user_tab+"`n"
  $sqlQuery_show_table_all=$sqlQuery_show_table_all+$user_tab+"`n"
  $sqlQuery_show_table_all=$sqlQuery_show_table_all+"PROMPT Stop script: "+$user_tab+"`n"
  $sqlQuery_show_table_all=$sqlQuery_show_table_all+" `n"
  $sqlQuery_show_table_all=$sqlQuery_show_table_all+"PROMPT ---------------------------------------------------------------------------------------------------------`n"
  $sqlQuery_show_table_all=$sqlQuery_show_table_all+" `n"

  $full_csv_path_file=$full_csv_path +  $file_input + "_" + $date_time_log + $csv_ext

}

$sqlQuery_show_table_all=$sqlQuery_show_table_all+$SqlQueryExportTable2
$sqlOutput_tab = $sqlQuery_show_table_all | sqlplus  $username/$password@$connect_string

Out-File -filepath $full_csv_path_file -append -inputobject $sqlOutput_tab -encoding default

echo "-------------------------------------------------------------------------------------------"  | tee-object -Append  -filepath $full_log_path

