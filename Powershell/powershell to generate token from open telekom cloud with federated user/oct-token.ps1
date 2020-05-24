<#
    .SYNOPSIS
    Script to get OTC token for EY federated users to execute terraform and create resources

    .DESCRIPTION
    - connect to login.microsoftonline.com and get request id, cookies and other required detail then connect to EY adfs and validate creds and get SAML response.
    - connect OTC with SAMLResponse and RelayState to get the OTC token.
    
    .NOTES
    Author:     Arun Sabale
    Created:    31-05-2019
    Version:    1.0
    
    .Note 
    
#>

# update creds
$user1 = "user@mydom.net"
$pass1 = "01000000d08c9ddf0115d1118c7a00c04fc297eb010000009ba5defef272144f8f67361350018d910000000002000000000003660000c000000010000000b99edd1953f3895b64d22f0c019dbaae0000000004800000a0000000100000006f53a12c3ae51625e96b3c0133ff5b5320000000aee53c5e126759856dc9fa59c16e9f0712bfd0d64c03f06e39a8e57c6ff3fb2a14000000b5342e58a96aa25824273b25351f027d12736540" | convertto-securestring
$path = "C:\temp" 

# get the toek  url from OTC and update below
$uri = "https://iam.eu-de.otc.t-systems.com/v3/OS-FEDERATION/identity_providers/myautomation/protocols/saml/auth" 
$url3 = "https://login.microsoftonline.com/common/GetCredentialType?mkt=en"
$uri7 = "https://login.microsoftonline.com/login.srf"



try {   
       
    #Create Log folder and file
    if (!(Get-ChildItem $path -Directory -ErrorAction SilentlyContinue | where { $_.Name -eq "log" })) 
    {
        write-output "Creating Log folder"
        $logfolder = $($path) + "\log"
        New-Item $logfolder -ItemType directory | Out-Null
    }

    write-output "Creating Log file" 
   $logpath = $($path) + "\log\TokenLog-$(get-date -Format yyyyMMdd).log"
    if (test-path $logpath) 
    {
        write-output "Token Log file already exist" 
    }
    else {
        New-Item  $logpath -Force  -ItemType file | Out-Null 
    }   

    "Token Request started @ $(get-date)" | Out-file -FilePath $logpath -Append 
    #req 1 to OTC token url

    $headerHost = $uri.Split("/")[2]
    $Header1 = @{
        "Host"                      = "$headerHost"
        "Accept-Language"           = "en,zh-CN;q=0.9,zh;q=0.8"
        "DNT"                       = "1"
        "Upgrade-Insecure-Requests" = "1"
        "Accept"                    = "application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
        "Accept-Encoding"           = "gzip, deflate, br"
    }
    $result1 = ""
    $result1 = Invoke-WebRequest -Uri $uri -Headers $Header1
    $url1 = $result1.BaseResponse.ResponseUri.AbsoluteUri
    $querystring = $result1.BaseResponse.ResponseUri.Query
    $result1.BaseResponse.StatusCode
    $statuscode=""
    $statuscode = $result1.BaseResponse.StatusCode
    "Req 1 status code is $statuscode" | Out-file -FilePath $logpath -Append

    try {
        #Req 2 to MS url
        $header2 = @{
            "Host"                      = "login.microsoftonline.com"
            "User-Agent"                = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101 Firefox/67.0"
            "Accept"                    = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
            "Accept-Language"           = "en-US,en;q=0.5"
            "Accept-Encoding"           = "gzip, deflate, br"
            "DNT"                       = "1"
            "Upgrade-Insecure-Requests" = "1"
        }

        $result2 = Invoke-WebRequest -Uri $url1 –Headers $Header2 -Method get  
        $statuscode=""
        $statuscode = $result2.BaseResponse.StatusCode
        "Req 2 status code is $statuscode" | Out-file -FilePath $logpath -Append
        $requestid = $result2.Headers["x-ms-request-id"]
        $tempresult1 = $result2.RawContent.replace("`"apiCanary`":", "^")
        $apiCanary = ($tempresult1.Split("^")[1]).split("`"")[1]
        $tempresult1 = $result2.RawContent.replace("`"correlationId`":", "^")
        $correlationId = ($tempresult1.Split("^")[1]).split("`"")[1]
        $Cookie = $result2.Headers["Set-Cookie"]
        $tempresult1 = $result2.RawContent.replace("`"sCtx`":", "^")
        $sCtx = ($tempresult1.Split("^")[1]).split("`"")[1]
        $tempresult1 = $result2.RawContent.replace("`"sFT`":", "^")
        $sFT = ($tempresult1.Split("^")[1]).split("`"")[1]
        $tempresult1 = $result2.RawContent.replace("`"hpgid`":", "^")
        $hpgid = ($tempresult1.Split("^")[1]).split(",")[0]
    }
    catch {
        throw "failed in Req2, Error - $_"
    }

    Try {
        #Req 3 to MS URL
        $header3 = @{
            "Origin"            = "https://login.microsoftonline.com"
            "Content-type"      = "application/json; charset=UTF-8"
            "Host"              = "login.microsoftonline.com"
            "User-Agent"        = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101 Firefox/67.0"
            "Accept"            = "application/json"
            "Accept-Language"   = "en-US,en;q=0.5"
            "Accept-Encoding"   = "gzip, deflate, br"
            "Referer"           = "$url1"
            "hpgid"             = "1104"
            "hpgact"            = "1900"
            "canary"            = "$apiCanary"
            "client-request-id" = "$correlationId"
            "hpgrequestid"      = "$requestid"
            "DNT"               = "1"
            "Cookie"            = "$Cookie"
        }

        $body3 = "{`"username`":`"$user1`",`"isOtherIdpSupported`":true,`"checkPhones`":false,`"isRemoteNGCSupported`":true,`"isCookieBannerShown`":false,`"isFidoSupported`":false,`"originalRequest`":`"$sCtx`",`"country`":`"DE`",`"forceotclogin`":false,`"flowToken`":`"$sFT`"}"
        $result3 = Invoke-RestMethod -Method post -Uri $url3 -Headers $header3 -Body $body3
        $url4 = $result3.Credentials.FederationRedirectUrl

    }
    catch {
        throw "failed in Req3, Error - $_"
    }


    [Net.ServicePointManager]::SecurityProtocol = 'Tls12'
    <#
#req 4 - to adfs
$header4 = @{
"Host"="adfsdevpoc.ey.com"
"User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101 Firefox/67.0"
"Accept"="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
"Accept-Language"="en-US,en;q=0.5"
"Accept-Encoding"="gzip, deflate, br"
"Referer"="https://login.microsoftonline.com/"
"DNT"="1"
"Upgrade-Insecure-Requests"="1"
}
$result4 = Invoke-webrequest -Method get -Uri $url4 -Headers $header4
$result4.BaseResponse.StatusCode
#>

    try {
        #req 5 to adfs
        $headerhost5 = $url4.Split("/")[2]
        $header5 = @{
            "Host"                      = "$headerhost5"
            "User-Agent"                = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101 Firefox/67.0"
            "Accept"                    = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
            "Accept-Language"           = "en-US,en;q=0.5"
            "Accept-Encoding"           = "gzip, deflate, br"
            "Referer"                   = "$url4"
            "Content-Type"              = "application/x-www-form-urlencoded"
            "DNT"                       = "1"
            "Upgrade-Insecure-Requests" = "1"
        }

        $Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($pass1)
        $Pw1 = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)
        $pw1= ((((($pw1.Replace("#", "%23")).Replace("@", "%40")).Replace("=", "%3D")).Replace("+", "%2B")).Replace("&amp", "%26"))
        $body5 = "UserName=$user1&Password=$pw1&AuthMethod=FormsAuthentication"

        $result5 = Invoke-WebRequest -Method post -Uri $url4 -Headers $header5 -Body $body5 -SessionVariable session
        $statuscode=""
        $statuscode = $result5.BaseResponse.StatusCode
        "Req 5 status code is $statuscode" | Out-file -FilePath $logpath -Append
        $result5.BaseResponse.StatusCode
        $Cookie5 = ($result5.Headers["Set-Cookie"]).Replace("; path=/adfs; HttpOnly; Secure", "")
    }
    catch {
        throw "failed in Req5, Error - $_"
    }

    Try {
        #req 6 to adfs
        $headerhost5 = $url4.Split("/")[2]
        $Header6 = @{
            "Host"                      = "$headerhost5"
            "User-Agent"                = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101 Firefox/67.0"
            "Accept"                    = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
            "Accept-Language"           = "en-US,en;q=0.5"
            "Accept-Encoding"           = "gzip, deflate, br"
            "Referer"                   = "$url4"
            "DNT"                       = "1"
            "Cookie"                    = "$Cookie5"
            "Upgrade-Insecure-Requests" = "1"
        }

        $result6 = Invoke-WebRequest -Method get -Uri $url4 -Headers $header6 -WebSession $session
        $statuscode=""
        $statuscode = $result6.BaseResponse.StatusCode
        "Req 6 status code is $statuscode" | Out-file -FilePath $logpath -Append
        $result6.BaseResponse.StatusCode
        $tempresult6 = $result6.RawContent.replace("wresult`" value=`"", "^")
        $wresult = ($tempresult6.Split("^")[1]).split("`"")[0]
        $tempresult6 = $result6.RawContent.replace("wctx`" value=`"", "^")
        $wctx = ($tempresult6.Split("^")[1]).split("`"")[0]
        $wctx = $wctx.Replace("=", "%3D")
        $wctx = $wctx.Replace("estsredirect", "LoginOptions%3D3%26estsredirect")
        $wresult = $wresult.Replace("=", "%3D")
    }
    catch {
        throw "failed in Req6, Error - $_"
    }

    Try {

        #req7 to MSOL

        $header7 = @{
            "Host"                      = "login.microsoftonline.com"
            "User-Agent"                = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101 Firefox/67.0"
            "Accept"                    = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
            "Accept-Language"           = "en-US,en;q=0.5"
            "Accept-Encoding"           = "gzip, deflate, br"
            "Referer"                   = "https://adfsdevpoc.ey.com/"
            "Content-Type"              = "application/x-www-form-urlencoded; charset=UTF-8"
            "DNT"                       = "1"
            "Cookie"                    = "$cookie"
            "Upgrade-Insecure-Requests" = "1"
        }

        $body7 = "wa=wsignin1.0&wresult=$wresult&wctx=$wctx"
        $body77 = (((((((($body7.Replace("/", "%2F")).replace(":", "%3A")).Replace("<", "%3C")).Replace(">", "%3E")).Replace("&lt;", "%3C")).Replace("+", "%2B")).Replace("=&quot", "%3D%22")).Replace("&quot", "%22")).Replace(";", "")
        $body77 = ((((($body77.Replace("#", "%23")).Replace("@", "%40")).Replace("==", "%3D%3D")).Replace(" ", "+")).Replace("&amp", "%26"))

        #Get-Content -Path  "C:\BS\OTC\body7.txt" | Set-Content -Encoding Ascii -Path "C:\BS\OTC\body77.txt"

        $result7 = Invoke-WebRequest -uri $uri7 -Method Post -Headers $Header7 -Body $body77
        $statuscode=""
        $statuscode = $result7.BaseResponse.StatusCode
        "Req 7 status code is $statuscode" | Out-file -FilePath $logpath -Append
        $result7.BaseResponse.StatusCode
        $tempresult7 = $result7.RawContent.replace("action=`"", "^")
        $url7 = ($tempresult7.Split("^")[1]).split("`"")[0]

        $tempresult7 = $result7.RawContent.replace("`"SAMLResponse`" value=", "^SAMLResponse=")
        $SAMLResponse = ($tempresult7.Split("^")[1]).split("/>")[0]
        $tempresult7 = $result7.RawContent.replace("`"RelayState`" value=", "^RelayState=")
        $RelayState = ($tempresult7.Split("^")[1]).split("/>")[0]
    }
    catch {
        throw "failed in Req7, Error - $_"
    }

    Try {
        #req 8 to otc
        $headerhost8 = $url7.Split("/")[2]
        $header8 = @{
            "Host"                      = "$headerhost8"
            "User-Agent"                = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101 Firefox/67.0"
            "Accept"                    = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
            "Accept-Language"           = "en-US,en;q=0.5"
            "Accept-Encoding"           = "gzip, deflate, br"
            "Referer"                   = "https://login.microsoftonline.com/"
            "Content-Type"              = "application/x-www-form-urlencoded"
            "DNT"                       = "1"
            "Upgrade-Insecure-Requests" = "1"
        }

        $body8 = ((($SAMLResponse + "&" + $RelayState).Replace(" ", "")).replace("`"", "")).replace("+", "%2B")
        $result8 = Invoke-WebRequest -uri $url7 -Method Post -Headers $Header8 -Body $body8
        $result8.BaseResponse.StatusCode
        $statuscode=""
        $statuscode = $result8.BaseResponse.StatusCode
        "Req 8 status code is $statuscode" | Out-file -FilePath $logpath -Append

        $token = $result8.Headers["X-Subject-Token"]

        #cleanup of old log  file
        write-output "Deleting old log files from $($path)\log older than $CleanupOlderThan ..." 
        "Deleting old log files from $($path)\log older than $CleanupOlderThan ..."  | Out-file -FilePath $logpath -Append 
        Get-ChildItem "$($path)\log" |where {$_.LastWriteTime -lt (get-date).AddDays(-$CleanupOlderThan) -and $_.Name -like "*.log"} | Remove-Item -Force


        #$token | out-file -FilePath "C:\temp\token.txt"
        $token
        
    }
    catch {
        throw "failed in Req8, Error - $_"
    }
    "Token Request completed successfully @ $(get-date)" | Out-file -FilePath $logpath -Append


}
catch {
    write-output "Failed to get OTC token, Error - $_ "
    "Error - Failed to get OTC token, Error - $_" | Out-file -FilePath $logpath -Append
}
# SIG # Begin signature block
# MIIFnQYJKoZIhvcNAQcCoIIFjjCCBYoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6fWBn56WjIPw3/vExe3nHhaQ
# oHugggMzMIIDLzCCAhegAwIBAgIQH5/ocd7OWZtEe0Z9PM4aQTANBgkqhkiG9w0B
# AQsFADAfMR0wGwYDVQQDDBRhcnVuLm0uc2FiYWxlQGV5LmNvbTAeFw0xOTA2MDMw
# NjE0NDZaFw0yMDA2MDMwNjM0NDZaMB8xHTAbBgNVBAMMFGFydW4ubS5zYWJhbGVA
# ZXkuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvIhdNvz+1xEq
# 2ldne3IrW//N6vQ0jd4czPLFQyGijcgBCyq9zqM8qBo13LXrV3Gr6Hxc0x4cSaHV
# JTUSYFfX4ycSM5unuFoBu87Ra0DnHUHerURLn30xc8tVLg915fpNwGqpXKw65kzf
# wjQOHoWra+cZ6LWfVqM7lwroRfh2YD5ZxorTeCnqaCMYqtmKPxnuR4/fGGRur0nO
# K0lfwJUN4liVb/FuuPGgJdoFHDfPDn2CmuG0tyOJGx3KtbLwki1ZuHDZDoa1pjhB
# lcI7sddHvCCjhcxO2+Xwf1gDbCXH3sL1FVOli4y0jk/bwP1ZjGxmpKZkh4HTU2KP
# 8L3rT3IyQQIDAQABo2cwZTAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYB
# BQUHAwMwHwYDVR0RBBgwFoIUYXJ1bi5tLnNhYmFsZUBleS5jb20wHQYDVR0OBBYE
# FL2NL4xI2zf60Z69t3ymJ6QuIhXfMA0GCSqGSIb3DQEBCwUAA4IBAQCFcLTPI1qR
# mvgBIvBgD6C3exe+Zf8BUb3rB8DDVL5WdJl0WxzVbyqlfXjf2MNS/1BzV5xWexDW
# kWBujnNgVxi7sjOsuJ2uKy7Yagvrg660kh5p9kK3f2tkaJNIWynTac1JbtV/VcyH
# xC8FDQxScB87rLxbGMbom/3w/bI2OkmVvZ97SbmPKxyB/eN50B79KwMcyHElCdEu
# kFScRhQtjFkwfSOvPy4DZOlgE6E5vo0cRzZmActoOszIxK8p7+K64kBw+n0Od9CM
# fQLNKLuujKQRtxZtSFDFOf3ArQI9Xx8vGBAdfm08/SuwUWFLadxifFb8zXsh40xb
# dzZyIOunJQFMMYIB1DCCAdACAQEwMzAfMR0wGwYDVQQDDBRhcnVuLm0uc2FiYWxl
# QGV5LmNvbQIQH5/ocd7OWZtEe0Z9PM4aQTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGC
# NwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU0y83x17P
# +Z9ahQBUiQzlr5sIlzgwDQYJKoZIhvcNAQEBBQAEggEASp4UxT7jJxbls/pJ/ZZa
# gp4H2DdMviWWWjXjusVtjS474dK+K74gTlTdhMaI48swZRo216bvNRUIdwKYVQcT
# +qUzedvjPDvHXSaYuoNb5BLdracYi67O6FYbDpGmkqIZhp8cknrbBdR1KeglFuYE
# ZS3FOCooTF1pVmmBSPjfWYQyovMxcPWmZeD1Uat7xPb3FY4QabDJVF6kzJXmqh6u
# 4iShd2hWCt8K3u0ugzxBmTEu+d+hdCvi/nqLqxQuIQlW1s1ovywFo2E0pP2U7yYU
# K9r3901CCZmos/qHm8bbSJzZ2JcZqIFfHdUEEC/bzYWKcHAnOjeieV2xJK4PRkrN
# Ww==
# SIG # End signature block
