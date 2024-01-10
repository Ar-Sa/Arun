# escape=`

FROM mcr.microsoft.com/windows/server:ltsc2022
USER ContainerAdministrator

COPY WorkingAllAdmins.ps1 c:/temp/

RUN powershell.exe -Command Install-WindowsFeature -Name "RSAT-AD-PowerShell" –IncludeAllSubFeature
WORKDIR c:/temp

CMD ["powershell.exe","-File","test.ps1"]

#ENTRYPOINT ["powershell.exe"]
#CMD ["powershell.exe","-File" ".`\WorkingAllAdmins.ps1"]
#CMD powershell.exe -File .`\WorkingAllAdmins.ps1
