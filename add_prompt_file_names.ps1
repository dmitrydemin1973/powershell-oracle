<#
    .SYNOPSIS
     This script adds PROMPT sql file names to sql file before call sql script.
     Author: Dmitry Demin dmitrydemin1973@gmail.com

    .DESCRIPTION
     This script adds PROMPT sql file names to sql file before call sql script.
    
    .PARAMETER sql_file_input

     Specify the input sql script.

    .PARAMETER sql_file_output

     Specify the output sql script.

    .PARAMETER log_file

     Specify the log file.

    .EXAMPLE
     This script adds PROMPT sql file names to sql file before call sql script.
    .\add_prompt_file_names.ps1  -sql_file_input .\sql\start.sql -sql_file_output .\sql\start_prompt.sql -log_file log_file.log
#>


param(
[string]$sql_file_input="C:\upwork\powershell-oracle_git\sql\start.sql",
[string]$sql_file_output="C:\upwork\powershell-oracle_git\sql\start_prompt.sql",
[string]$log_file="log_add_prompt.log"
)

$upper_line = "PROMPT ""Start script: "
$bottom_line = "PROMPT ""---------------------------------------------------------------------------------------------------------"""

                       


$date_time_start = Get-Date -Format "yyyy-MM-dd HH:mm:ss"            

Write-host "Script start time : $date_time_start "
try
{
echo "Script start time :  $date_time_start ">>$log_file
}
catch {
Write-Host "Log File $log_file.  Other type of error was found:"
Write-Host "Exception type is $($_.Exception.GetType().Name)"
exit
}

echo "===========================================================================================" | tee-object -Append  -filepath $log_file
echo "Input sql file: $sql_file_input"  | tee-object -Append  -filepath $log_file
echo "Output sql file: $sql_file_output"  | tee-object -Append  -filepath $log_file

$data_file = Get-Content $sql_file_input

$null | Set-Content -Path $sql_file_output

foreach ($line_file in $data_file)
{

  if ($line_file.TrimStart().StartsWith("@"))

  {

   $start_prompt_line= $upper_line + $line_file.TrimStart().replace("@","")  + """"
   
   Out-File -filepath $sql_file_output -append  -inputobject $start_prompt_line -encoding default
   Out-File -filepath $sql_file_output -append  -inputobject $line_file.TrimStart() -encoding default
   Out-File -filepath $sql_file_output -append  -inputobject $bottom_line -encoding default
  }

  else 
  {
   Out-File -filepath $sql_file_output -append -inputobject $line_file -encoding default
  }
    
}


