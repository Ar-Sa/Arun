function PS-Translate {
  param (
    [Parameter(Mandatory)]
    [string]$Text,
    [Parameter(Mandatory)]
    [string]$TargetLanguage,
    [Parameter()]
    [string]$SourceLanguage="auto"
  )

$Url = “https://translate.googleapis.com/translate_a/single?client=gtx&sl=$($SourceLanguage)&tl=$($TargetLanguage)&dt=t&q=$Text”
$Res = Invoke-RestMethod -Uri $Url -Method Get
$result = $Res[0].SyncRoot | foreach { $_[0] }
return $result
}

#example to use the function
PS-Translate -SourceLanguage auto -TargetLanguage nl -Text “good morning”
