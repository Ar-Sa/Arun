<#
    .DESCRIPTION
        Runbook to Create AVD personal hostpool

    .NOTES
        AUTHOR: Arun sabale 
        LASTEDIT: Dec 05, 2021
#>

param(

    [Parameter(mandatory = $false)]
    [string]$HostpoolType = "pooled", #Personal / Pooled

    [Parameter(mandatory = $false)]
    [string]$loadBalancerType = "BreadthFirst",#<for pooled- BreadthFirst|DepthFirst & for personal - Persistent>

    [Parameter(mandatory = $true)]
    [string]$HostPoolName = "avdhostPool2",

    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName = "AVD-RG",

    [Parameter(mandatory = $true)]
    [int]$HostCount = 2,

    [Parameter(mandatory = $true)]
    [string]$rdshNamePrefix = "Azeus2pl",

    [Parameter(mandatory = $true)]
    [string]$rdshVmSize = "Standard_D4s_v3",

    [Parameter(mandatory = $true)]
    [string]$existingVnetName = "AVD-vnet",

    [Parameter(mandatory = $true)]
    [string]$existingSubnetName = "AVD-subnet1",

    [Parameter(mandatory = $true)]
    [string]$virtualNetworkResourceGroupName= "AVD-RG",

    [Parameter(mandatory = $true)]
    [string]$location = "eastus2",

    [Parameter(mandatory = $false)]
    [string]$ApplicationGroupType = "Desktop",  #Desktop or RemoteApp

    [Parameter(mandatory = $true)]
    [string]$DomainPass = "********",

    [Parameter(mandatory = $true)]
    [string]$DomainUser = "admin*@powershelltalk.com",

    [Parameter(mandatory = $true)]
    [string]$Domain = "powershelltalk.com",

    [Parameter(mandatory = $true)]
    [string]$DomainOU = "OU=AADDC Computers,DC=powershelltalk,DC=com",

    [Parameter(mandatory = $false)]
    [string]$MaxSessionLimit=4, #applicable only if pooled hostpool

    [Parameter(mandatory = $false)]
    [string]$CustomRdpProperty="drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;audiocapturemode:i:1;encode redirected video capture:i:1;redirected video capture encoding quality:i:1;camerastoredirect:s:*",  #https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/rdp-files

    [Parameter(mandatory = $true)]
    [string]$imageID = "/subscriptions/1d96a493-e9d6-404f-96c6-c4a483b6d7b3/resourceGroups/AVD-RG/providers/Microsoft.Compute/galleries/AVDimage/images/avd-multisession/versions/0.0.1"

)

try{

    #login to Azure - make sure you login to correct azure subscription via connect-AzAccount or using below commented code

    #$SPNKey = ConvertTo-SecureString "$password" -AsPlainText -Force
    #$psCred = New-Object System.Management.Automation.PSCredential($userid , $SPNKey)
    #connect-AzAccount -Credential $psCred 
    #Select-AzSubscription 1d96a493-e9d6-404f-96c6-c4a483b6d7b3
    
    #region create RG
    $RGDetail = Get-AzResourceGroup -Name $ResourceGroupName -Location $location -ErrorAction SilentlyContinue
    if($RGDetail)
    {
        Write-Output "RG $ResourceGroupName already exist"
    }
    else{
        $RGDetail1 = New-AzResourceGroup -Name $ResourceGroupName -Location $location
        Write-Output "RG $ResourceGroupName created"
    }
    #endregion


    #region create workspace
    $WorkspaceName= "W-"+$HostPoolName
    $ErrorActionPreference= "SilentlyContinue"
    $WPDetail = get-AzWvdWorkspace -Name $WorkspaceName -ResourceGroupName $ResourceGroupName 
    $ErrorActionPreference= "Continue"
    if($WPDetail)
    {
        Write-Output "WorkspaceName $WorkspaceName already exist"
    }
    else{
        $WorkspaceDetail = New-AzWvdWorkspace -Name $WorkspaceName -ResourceGroupName $ResourceGroupName `
        -Location $location
        Write-Output "WorkspaceName $WorkspaceName created"
    }
    #endregion

    #region create Hostpool
    $appGroup= $HostPoolName+"-app"
    $ErrorActionPreference= "SilentlyContinue"
    $hpDetail = get-AzWvdHostPool -Name $HostPoolName -ResourceGroupName $ResourceGroupName 
    $ErrorActionPreference= "Continue"
    if($hpDetail)
    {
        Write-Output "HostPoolName $HostPoolName already exist"
    }
    else{
      
        $hpDetail1 =  New-AzWvdHostPool -ResourceGroupName $resourcegroupname -Name $HostPoolName `
        -MaxSessionLimit $MaxSessionLimit -HostPoolType $HostpoolType -LoadBalancerType $loadBalancerType `
        -Location $location -PreferredAppGroupType $ApplicationGroupType -CustomRdpProperty $CustomRdpProperty

        Write-Output "HostPoolName $HostPoolName created"
        
    }
    #endregion

    #region create desktop App group
    $ErrorActionPreference= "SilentlyContinue"
    $agDetail = get-AzWvdApplicationGroup -ResourceGroupName $ResourceGroupName -Name $appGroup
    $ErrorActionPreference= "Continue"
    if($agDetail)
    {
        Write-Output "App group $appGroup already exist"
    }
    else{           

        $dag = New-AzWvdApplicationGroup -Name $appGroup -ResourceGroupName $resourcegroupname `
        -HostPoolArmPath $hpDetail1.Id -Location $location -ApplicationGroupType $ApplicationGroupType

        $reg = Register-AzWvdApplicationGroup -ResourceGroupName $ResourceGroupName -WorkspaceName `
        $WorkspaceName -ApplicationGroupPath $dag.id
        Write-Output "App group $appGroup created"
        
    }
    #endregion


    #region get registration token
    $token = (new-AzWvdRegistrationInfo -HostPoolName $HostPoolName -ResourceGroupName $ResourceGroupName `
    -ExpirationTime $((get-date).ToUniversalTime().AddDays(1).ToString('yyyy-MM-ddTHH:mm:ss.fffffffZ'))).Token
    #endregion


    #region create session host

    Write-Output "creating vm .."

    #calling ARM template

        $tagsObject = @{
                'Hostpool'     = $HostPoolName
                'size'     = $rdshVmSize
            }

        $Parameters = [ordered]@{
                        "imageReferenceID"      = "$imageID"
                        "rdshPrefix" = "$rdshNamePrefix"
                        "rdshVMDiskType"            = "StandardSSD_LRS"
                        "rdshVmSize"   = "$rdshVmSize"
                        "administratorAccountUsername"     = "$DomainUser"
                        "administratorAccountPassword"     = "$DomainPass"
                        "Domain"        = "$Domain"
                        "ouPath"            = "$DomainOU"
                        "existingSubnetName"          = "$existingSubnetName"
                        "networkInterfaceTags"            = $tagsObject
                        "virtualMachineTags"        = $tagsObject
                        "vmInitialNumber"          = 1
                        "hostpoolToken"        = $token
                        "hostpoolName" = "$HostPoolName"
                        "vmLocation"        = "$location"
                        "virtualNetworkResourceGroupName" = "$virtualNetworkResourceGroupName"
                         "existingVnetName" = "$existingVnetName"
                         "rdshNumberOfInstances"=$HostCount
                        }
                    

        New-AzResourceGroupDeployment -TemplateUri "https://raw.githubusercontent.com/Ar-Sa/Arun/master/Powershell/Powershell%20and%20ARM%20to%20create%20azure%20virtual%20desktop%20personal%20desktop/New-personalAVDTemplate.json" `
        -TemplateParameterObject $Parameters -ResourceGroupName $ResourceGroupName -Name $HostPoolName
      #endregion                
}
catch
{
Write-Output "failed to create hostpool"
Write-Error "failed to create hostpool"
}
