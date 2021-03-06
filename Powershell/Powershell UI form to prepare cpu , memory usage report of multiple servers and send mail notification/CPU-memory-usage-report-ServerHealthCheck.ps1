﻿########################################################################
# Generated On: 12/17/2014 11:08 PM
# Generated By: Arun sabale
########################################################################

$alimit="75"
$ServerListFile = "C:\servers.txt" 

$ErrorActionPreference= 'silentlycontinue' 
cls
$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue 
$Outputreport  = @() 
$Outputreport = "<HTML><TITLE> Server Health Report </TITLE>
                     <BODY background-color:peachpuff>
                     <font color =""#99000"" face=""Microsoft Tai le"">
                     <H2> Server Health Report </H2></font>
                     <Table border=1 cellpadding=0 cellspacing=0>
                     <TR bgcolor=gray align=center>
                       <TD><B>Server Name</B></TD>
                       <TD><B>Avrg.CPU Utilization</B></TD>
                       <TD><B>Memory Utilization</B></TD></TR>"

ForEach($computername in $ServerList) 
{
if(test-connection $computername)
{
write-host "checking $computername"
$AVGProc = Get-WmiObject -computername $computername win32_processor | 
Measure-Object -property LoadPercentage -Average | Select Average
$OS = gwmi -Class win32_operatingsystem -computername $computername |
Select-Object @{Name = "MemoryUsage"; Expression = {“{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }}


$AVGProc2 = $AVGProc.Average
$computername
$AVGProc2
if($AVGProc2 -ge $alimit) 
          { 
          write-host "$AVGProc2 is more that 80% for $computername"
          $cpuclr = "Red" 
          } 
          else { $cpuclr = "white" }




$OS2 = $os.MemoryUsage
$OS2
if( $os2 -ge $alimit) 
          { 
          write-host "$os2 is more that 80% for $computername"
          $memclr = "Red"
          } else { $memclr = "white" }


          
          
          $Outputreport += "<TR bgcolor=white>" 
          $Outputreport += "<TD>$computername</TD><TD align=center bgcolor=$cpuclr>$AVGProc2</TD><TD align=center bgcolor=$memclr>$os2</TD></TR>" 
        
   
      }
      else { write-host "$computername server is not reachable"} 
      $OS2 = ""
      $OS = ""
      $AVGProc2 = ""
      $AVGProc=""
      } 
 $Outputreport += "</Table></BODY></HTML>" 
$Outputreport | out-file C:\Health.htm 

Invoke-Expression C:\Health.htm

##Send email functionality from below line, use it if you want   
$smtpServer = "10.12.32.14"
$smtpFrom = "admin@micro.com"
$smtpTo = "admin@micro.com"
$messageSubject = "Chicago DC Servers Health report"
$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.Subject = $messageSubject
$message.IsBodyHTML = $true
$message.Body = "<head><pre>$style</pre></head>"
$message.Body += Get-Content C:\Health.htm
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($message)

