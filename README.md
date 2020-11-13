# powershell-oracle 

# analyze_oracle_error_log.ps1

**.SYNOPSIS**

 Sql error counting
  
 Author: Dmitry Demin dmitrydemin1973@gmail.com
   
**.DESCRIPTION**

  The function calculates sql errors in the log file. Combines and counts errors by error codes.
    
**.PARAMETER Input_File**
    
  Specify the path to the log file for analyze 
    
**.PARAMETER Output_File**

 Specify the path to the output log file 
    
 **.EXAMPLE**
 
 Sql error counting from inputfile to a outputfile:
    
    .\analyze_oracle_error_log.ps1 -Input_File  "C:\log_file.log" -Output_File "C:\count_error_log.log"

# run_export_all_tables.ps1 

**.SYNOPSIS**

  The script exports all user tables to separate CSV files.
  
  Author: Dmitry Demin dmitrydemin1973@gmail.com
  
**.DESCRIPTION**

   In the script, the format for displaying the date and decimal separator is configured.
   
**.PARAMETER username**

  Specify the username  for example SCOTT
  
**.PARAMETER password**

  Specify the password  for example TIGER
  
**.PARAMETER connect_string**

  Specify the connect_string(TNS alias)  for connect to database from $ORACLE_HOME/network/admin/tnsnames.ora.  
  
 **.PARAMETER csv_dir_path**
 
  Specify the csv directory for csv files
  
**.PARAMETER  log_file**

  Specify the  log file for this script.  
  
**.EXAMPLE**

The script exports all user tables to separate CSV files.

    .\run_export_all_tables.ps1 -username SCOTT -password tiger -connect_string ORCL -csv_dir_path C:\upwork\powershell_sqlplus_export_csv\csv\  -log_file log_file.log
>

# run_export_dir_tables.ps1

**.SYNOPSIS**

   This script executes all sql files from the specified directory and creates separate csv files for all tables in a specified directory.
  
   Author: Dmitry Demin dmitrydemin1973@gmail.com

**.DESCRIPTION**

   In the script, the format for displaying the date and decimal separator is configured.

**.PARAMETER username**

   Specify the username  for example SCOTT

**.PARAMETER password**

   Specify the password  for example TIGER

**.PARAMETER connect_string**
    
   Specify the connect_string(TNS alias)  for connect to database from $ORACLE_HOME/network/admin/tnsnames.ora.  

**PARAMETER sql_path**

   Specify the directory for executing sql scripts.

**.PARAMETER csv_path**

   Specify the directory for output csv.

**.PARAMETER log_path**

   Specify the log file.

 **.EXAMPLE**
 
   This script executes all sql files from the specified directory and creates separate csv files in a specified directory.
     
    .\run_export_all_tables.ps1 -username SCOTT -password tiger -connect_string ORCL -sql_path C:\export\sql\  -csv_path C:\export\csv\

# run_all_sql_dir.ps1

**.SYNOPSIS**

   This script executes all sql files from the specified directory and creates one log files in a specified directory.
     
   Author: Dmitry Demin dmitrydemin1973@gmail.com
     
**.DESCRIPTION**

   In the script, the format for displaying the date and decimal separator is configured.
     
**.PARAMETER username**
   
   Specify the username  for example SCOTT
   
**.PARAMETER password**
  
   Specify the password  for example TIGER
    
**.PARAMETER connect_string**
  
   Specify the connect_string(TNS alias)  for connect to database from $ORACLE_HOME/network/admin/tnsnames.ora.  
    
**.PARAMETER auto_commit**
  
   Specify the autocommit for session. Default autocommit OFF.  
     
**.PARAMETER sql_path**
  
   Specify the directory for executing sql scripts.
     
**.PARAMETER logs_path**
   
   Specify the directory for output log.
      
**.PARAMETER log_file
   
   Specify the log file.
   
**.EXAMPLE**

   This script executes all sql files from the specified directory and creates separate csv files in a specified directory.
   
          .\run_export_all_tables.ps1 -username SCOTT -password tiger -connect_string ORCL -sql_path C:\export\sql\  -logs_path  C:\export\log\log_file.log
