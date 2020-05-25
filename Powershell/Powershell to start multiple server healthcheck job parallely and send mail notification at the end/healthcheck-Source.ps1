################################################################################# 
## 
## Server Health Check 
## Created by Arun Sabale
## Date : 16 june 2014 
## Version : 1.0 
##
################################################################################ 

#File server health monitoring


$datet=(Get-Date)
$startdate= (Get-Date)
$critical="90"
$warning="80"
$erroractionpreference = “SilentlyContinue” 


$block2=
{
Param([string]$srv)
$date1 = get-date -uformat "%Y%m%d%M" 
$datet=(Get-Date)
Add-Content "C:\arun\output-donotopen\arun-HealthCheckReport-$srv-$date1.csv" "srv,proc,memor,memo,netw,net";  
do
{
if(test-connection $srv -Count 2)
{

$proc  =(get-counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1  -MaxSamples 1 -ComputerName $srv| select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average).average
$memory = gwmi -Class win32_operatingsystem -computername $srv |Select-Object @{Name = "MemoryUsage"; Expression = { “{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize)}}
$memo=(get-counter -Counter "\Memory\Available MBytes" -SampleInterval 1  -MaxSamples 1 -ComputerName $srv| select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average).average
$netw=(get-counter -Counter "\Network Interface(*)\Bytes Total/sec" -SampleInterval 1  -MaxSamples 1 -ComputerName $srv| select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average).average
$netb=(get-counter -Counter "\Network Interface(*)\Current Bandwidth" -SampleInterval 1  -MaxSamples 1 -ComputerName $srv| select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average).average
$datel
$memor=$memory.MemoryUsage
Write-Host " processor usage- $proc"
Write-Host " Memory usage - $memor"
Write-Host " Memory (Available MBytes)- $memo"
Write-Host " Network send/receive bytes - $netw"
Write-Host " Current bandwidth - $netb"
$net=(( ($netw*8)*100) / ($netb) ) 
Write-Host " network usage - $net"
Write-Host "**************"



#write to xls

Add-Content "C:\arun\output-donotopen\arun-HealthCheckReport-$srv-$date1.csv" "$srv,$proc,$memor,$memo,$netw,$net";  

}
else
{
Add-Content "C:\arun\output-donotopen\arun-HealthCheckReport-$srv-$date1.csv" "$srv,"0000","0000","0000","0000","0000"";  
}

}
while ( (get-date) -lt ($datet.Addminutes(0)))

# collect eventlogs
$wmidiskblock = {
Param($ComputerName = "LocalHost")
$time = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime((Get-Date).Addminutes(-10))
Get-WmiObject Win32_NTLogEvent -ComputerName $ComputerName -filter "(LogFile='System' or LogFile='application') and (type='error' or type='warning') and TimeGenerated>='$time'" #| select LogFile, SourceName, Type, UserName, EventCode, TimeGenerated , Message
}


if(Test-Connection $srv -Count 2)
{
Start-Job -scriptblock $wmidiskblock  -ArgumentList $srv
}
Get-Job | Wait-Job
$logs = Get-Job | Receive-Job
 
 $loc= Get-Location
 $save1 = "C:\arun\output-donotopen\HealthCheck-eventlogs-$srv-$date1.csv" 
$logs |export-csv $save1

 }




$startdate= (Get-Date)

$username = "na\sa-itsus-gfsmig"
$secpasswd = ConvertTo-SecureString "its789GF$" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("$username", $secpasswd)

Write-Host "Starting theread" -ForegroundColor Green
foreach($comp in get-content "c:\arun\sourceserver.txt")
{
Start-Job -ScriptBlock $block2 -ArgumentList $comp # -Credential $mycreds
}
Get-Job | Wait-Job
Get-Job | Wait-Job
Get-Job | Receive-Job

Write-Host "All thereads completed " -ForegroundColor Green
Get-Job | Remove-Job



$y = New-Object -comobject Excel.Application 
$y.visible = $false

$z = $y.Workbooks.Add() 
$x = $z.Worksheets.Item(1)

$x.Cells.Item(1,1) = “Machine Name”
$x.Cells.Item(1,2) = “Time” 
$x.Cells.Item(1,3) = “Processor usage(%)” 
$x.Cells.Item(1,4) = “Memory usage(%)” 
$x.Cells.Item(1,5) = “network usage(%)” 


$d = $x.UsedRange 
$d.Interior.ColorIndex = 19 
$d.Font.ColorIndex = 11 
$d.Font.Bold = $True 
$d.EntireColumn.AutoFit()

$intRow = 2

$p = $z.Worksheets.Item(2)

$p.Cells.Item(1,1) = “Machine Name”
$p.Cells.Item(1,2) = “Time” 
$p.Cells.Item(1,3) = “EntryType” 
$p.Cells.Item(1,4) = “EventID” 
$p.Cells.Item(1,5) = “Source” 
$p.Cells.Item(1,6) = “username” 
$p.Cells.Item(1,7) = “Eventlog” 
$p.Cells.Item(1,8) = “Message” 

$q = $p.UsedRange 
$q.Interior.ColorIndex = 19 
$q.Font.ColorIndex = 11 
$q.Font.Bold = $True 
$q.EntireColumn.AutoFit()

$intRowr = 2


$path="c:\arun\output-donotopen\"
$allcsv = Get-ChildItem -path $path|where {$_.name -like "*.csv" -and $_.name -like "arun-HealthCheckReport*"}
foreach($csv in $allcsv)
{
$csvpath=$path+$csv
$bbb2=Import-Csv $csvpath
foreach($logs2 in $bbb2)
{
$srv=$logs2.srv
$proc=$logs2.proc
$memor=$logs2.memor
$memo=$logs2.memo
$netw=$logs2.netw
$net=$logs2.net

if ($proc -ge $warning -or $memor -ge $warning -or $net -ge $warning) 
        {$ColorIndex = 44} 
              elseif ($proc -ge $critical -or $memor -ge $critical -or $net -ge $critical)  
                {$ColorIndex = 3} 
				elseif($proc -like "0000")
				{$ColorIndex = 3} 
                else {$ColorIndex = 2}
$x.Cells.Item($intRow, 1) = $srv.ToUpper() 
$x.Cells.Item($intRow, 1).Interior.ColorIndex =$ColorIndex 
$x.Cells.Item($intRow, 2) = $datel 
$x.Cells.Item($intRow, 2).Interior.ColorIndex =$ColorIndex 
$x.Cells.Item($intRow, 3) =  [math]::floor($proc) 
$x.Cells.Item($intRow, 3).Interior.ColorIndex =$ColorIndex 
$x.Cells.Item($intRow, 4) = [math]::floor($memor)
$x.Cells.Item($intRow, 4).Interior.ColorIndex =$ColorIndex 
$x.Cells.Item($intRow, 5) = [math]::floor($net)
$x.Cells.Item($intRow, 5).Interior.ColorIndex =$ColorIndex 

$intRow = $intRow + 1 
$ColorIndex=""
$srv=""
$proc=""
$memor=""
$memo=""
$netw=""
$net=""
}
}


$path="c:\arun\output-donotopen\"
$allcsv = Get-ChildItem -path $path|where {$_.name -like "*.csv" -and $_.name -like "arun-HealthCheckReport*"}
foreach($csv in $allcsv)
{
$csvpath=$path+$csv
Remove-Item $csvpath -Confirm:$false -Force
}

$path="c:\arun\output-donotopen\"
$allcsv = Get-ChildItem -path $path|where {$_.name -like "*.csv" -and $_.name -like "HealthCheck-eventlogs*"}
foreach($csv in $allcsv)
{
$csvpath=$path+$csv
$bbb=Import-Csv $csvpath
foreach($logs1 in $bbb)
{
$p.Cells.Item($intRowr, 1) = $logs1.__server 
$p.Cells.Item($intRowr, 1).Interior.ColorIndex =$ColorIndex 
$p.Cells.Item($intRowr, 2) = $logs1.TimeGenerated
$p.Cells.Item($intRowr, 2).Interior.ColorIndex =$ColorIndex 
$p.Cells.Item($intRowr, 3) =  $logs1.Type
$p.Cells.Item($intRowr, 3).Interior.ColorIndex =$ColorIndex 
$p.Cells.Item($intRowr, 4) = $logs1.EventCode
$p.Cells.Item($intRowr, 4).Interior.ColorIndex =$ColorIndex 
$p.Cells.Item($intRowr, 5) = $logs1.SourceName
$p.Cells.Item($intRowr, 5).Interior.ColorIndex =$ColorIndex 
$p.Cells.Item($intRowr, 6) = $logs1.username
$p.Cells.Item($intRowr, 6).Interior.ColorIndex =$ColorIndex
$p.Cells.Item($intRowr, 7) = $logs1.LogFile
$p.Cells.Item($intRowr, 7).Interior.ColorIndex =$ColorIndex
$p.Cells.Item($intRowr, 8) = $logs1.Message
$p.Cells.Item($intRowr, 8).Interior.ColorIndex =$ColorIndex
$intRowr = $intRowr + 1 
$ColorIndex=""
}
}
 $path="c:\arun\output-donotopen\"
$allcsv = Get-ChildItem -path $path|where {$_.name -like "*.csv" -and $_.name -like "HealthCheck-eventlogs*"}
foreach($csv in $allcsv)
{
$csvpath=$path+$csv
Remove-Item $csvpath -Confirm:$false -Force
}



$d.EntireColumn.AutoFit()
 
 $date1 = get-date -uformat "%Y%m%d%M" 
 $loc= Get-Location
 $save = "C:\arun\arun-HealthCheckReport-$date1.xls" 
 $z.SaveAs($save)
 $z.Save()
 $y.quit()
#Email

#$Attach1 = ".\perf.htm"
#$Attach2 = ".\FreeSpace.htm"
$Attach3 = $save
#$Attach4 = $save1
#$att = new-object Net.Mail.Attachment($Attach1)
#$att1 = new-object Net.Mail.Attachment($Attach2)
$att2 = new-object Net.Mail.Attachment($Attach3)
#$att3 = new-object Net.Mail.Attachment($Attach4)
$msg = new-object Net.Mail.MailMessage
$msg.IsBodyHTML = $true
$smtpServer = "smtp.na.arun.com"
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$Credentials = new-object System.Net.networkCredential 

$Credentials.domain = "na" 
$Credentials.UserName = "sbokade" 
$Credentials.Password = "Storage@11"
$smtp.Credentials = $Credentials

$msg.From = "sbokade@its.arun.com"
$msg.To.Add("Vwatkar1@its.arun.com")
$msg.To.Add("sbokade@its.arun.com")
#$msg.To.Add("drathod@its.arun.com")
$msg.To.Add("arun.sabale@arun.com")
$date = get-date -format MMddyyyy 
$msg.Subject = "arun health check - $date"
$msg.Body = " 
All,<br>
 Please check health report for FnP servers @ C:\arun\.
<br><br>
Check attached report and take appropriate actions against critical server(marked in RED).
<br>
<br>"
$msg.Body += "<head><pre>$style</pre></head>"
#$msg.Body += Get-Content .\perf.htm
$msg.Body += "<br>"
#$msg.Body += Get-Content .\FreeSpace.htm
#$msg.Attachments.Add($att)
#$msg.Attachments.Add($att1)
$msg.Attachments.Add($att2)
#$msg.Attachments.Add($att3)
$smtp.Send($msg)
#$att.Dispose()
#$att1.Dispose()
$att2.Dispose()
#$att3.Dispose()

$enddate= (Get-Date)

Write-Host "***************************************************"
Write-Host "Server Health Check Script completed successfull" -ForegroundColor Green
Write-Host "script started @ $startdate and completed @ $enddate"
Write-Host "***************************************************"