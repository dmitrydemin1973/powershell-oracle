# powershell-oracle

run_export_all_tables.ps1 

**.SYNOPSIS**

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
