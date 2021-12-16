<#
.SYNOPSIS
This script convert Local Profile to VHD and migrate to FSLogix Profile Container file share

.NOTES
  Version:          1.0
  Author:           Arun Sabale          
#>

#########################################################################################
# Requires -RunAsAdministrator
# Requires FSLogix Agent with comes with FSlogix app(frx.exe)
# Modify below parameter
#########################################################################################
# fslogix target file share profile path
$FilesharePath = "<\\domain.com\share\path>"
# User profile source path - you can copy all user profiles to single folder and then run the script
$userProfilePath = "c:\users"
#########################################################################################
# Main code
#########################################################################################
$ENV:PATH=”$ENV:PATH;C:\Program Files\fslogix\apps\”
$oldprofiles = gci $userProfilePath | ?{$_.psiscontainer -eq $true} | select -Expand fullname | sort | out-gridview -OutputMode Multiple -title "Select profile(s) to convert"

# foreach old profile
foreach ($old in $oldprofiles) {

$sam = ($old | split-path -leaf)
$sid = (New-Object System.Security.Principal.NTAccount($sam)).translate([System.Security.Principal.SecurityIdentifier]).Value

$nfolder = join-path $FilesharePath ($sam+"_"+$sid)
if (!(test-path $nfolder)) {New-Item -Path $nfolder -ItemType directory | Out-Null}
& icacls $nfolder /setowner "$env:userdomain\$sam" /T /C
& icacls $nfolder /grant $env:userdomain\$sam`:`(OI`)`(CI`)F /T

$vhd = Join-Path $nfolder ("Profile_"+$sam+".vhdx")

frx.exe copy-profile -filename $vhd -sid $sid
} 
