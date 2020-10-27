<#
    .SYNOPSIS
     Sql error counting

     Author: Dmitry Demin dmitrydemin1973@gmail.com

    .DESCRIPTION
    The function calculates sql errors in the log file. Combines and counts errors by error codes.

    .PARAMETER Input_File
    Specify the path to the log file for analyze 

    .PARAMETER Output_File
    Specify the path to the output log file 

    .EXAMPLE
    Sql error counting from inputfile to a outputfile:
    .\analyze_oracle_error_log.ps1 -Input_File  "C:\log_file.log" -Output_File "C:\count_error_log.log"
#>


param(
[string]$input_file = "log_file.log",
[string]$output_file = "count_error_log.log"
)

#
#
#$full_log_path="C:\upwork\powershell_analyze_error_v2\log_analyze_file.log"

$full_log_path=$output_file

$ListIgnoredError="*ORA-01430*","*ORA-00955*","*ORA-00001*"


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
Write-Host "File $pathfile  is not accessible."
      echo "File $pathfile  is not accessible." >>$full_log_path


exit
}

catch [System.Management.Automation.ItemNotFoundException]
{
Write-Host "File $pathfile  is not found."
      echo "File $pathfile  is not found." >>$full_log_path
exit
}
catch {
Write-Host "File $pathfile.  Other type of error was found:"
Write-Host "Exception type is $($_.Exception.GetType().Name)"
      echo "Exception type is $($_.Exception.GetType().Name)" >>$full_log_path
exit
}

}

                         
Write-Host "==========================================================================================="
      echo "===========================================================================================" >> $full_log_path 



$date_time_start = Get-Date -Format "yyyy MM dd HH:mm:ss"            

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


Check_File($input_file)

$sqlOutput_tab=Get-Content($input_file)


$sqlOutput_tab_error=$sqlOutput_tab | where {$_ -notlike "" } |where {$_ -like "*ORA-[0-9,0-9,0-9,0-9,0-9]*" -or $_ -like "*SP2-[0-9,0-9,0-9,0-9]*"  }

write-Host "-------------------------------------List Ignored ORA- Error--------------------------------------------"
      echo "-------------------------------------List Ignored ORA- Error--------------------------------------------" >> $full_log_path 
write-host $ListIgnoredError
     echo  $ListIgnoredError >> $full_log_path 
write-Host "--------------------------------------Found and ignored-------------------------------------------------"
      echo "--------------------------------------Found and ignored-------------------------------------------------" >> $full_log_path 

foreach ( $oraerror in $ListIgnoredError) 
{

$sqlOutput_tab_ignored_error=$sqlOutput_tab_error | where {$_ -notlike "" } |where {$_ -like  $oraerror }
$sqlOutput_tab_error=$sqlOutput_tab_error|where {$_ -notlike  $oraerror }

if ($sqlOutput_tab_ignored_error.count -gt 0) 
 {
     Write-Output "Found and ignored : $oraerror count:  $($sqlOutput_tab_ignored_error.count)" 
             echo "Found and ignored : $oraerror count:  $($sqlOutput_tab_ignored_error.count)"  >>$full_log_path

 }
}
#Write-Output  "Count Errors :  $($sqlOutput_tab_error.count) "


$hashErrors = @{}

foreach ($i in $sqlOutput_tab_error) {


if ($hashErrors.ContainsKey($i)) {

[int]$hashErrors.$i += 1

} else {
$hashErrors.Add($i,"1")
}
}


if ($sqlOutput_tab_error.count -gt 0)
{
Write-Host "-------------------------------------List other Error------------------------------------------------"
      echo "-------------------------------------List other Error------------------------------------------------" >> $full_log_path 


   $hashErrors.keys | foreach {
        Write-Host "Error: $_, Count : $($hashErrors.Item($_))"
              echo "Error: $_, Count : $($hashErrors.Item($_))" >>$full_log_path
      }

#      Write-Output $sqlOutput_tab_error        
#      echo   $sqlOutput_tab_error >>$full_log_path
Write-Host "-----------------------------------------------------------------------------------------------------"
      echo "-----------------------------------------------------------------------------------------------------" >> $full_log_path 
  Write-Host "User $user_tab script completed with errors!"
        echo "User $user_tab script completed with errors!" >>$full_log_path
Write-Output  "User $user_tab total count errors :  $($sqlOutput_tab_error.count) " 
        echo  "User $user_tab total count errors :  $($sqlOutput_tab_error.count) " >>$full_log_path

}
else 
{
          Write-Host "User $user_tab count Errors :  $($sqlOutput_tab_error.count) "
          Write-Host "User $user_tab Script completed successfully without errors!"
          echo "User $user_tab script completed successfully without errors!" >>$full_log_path

}





