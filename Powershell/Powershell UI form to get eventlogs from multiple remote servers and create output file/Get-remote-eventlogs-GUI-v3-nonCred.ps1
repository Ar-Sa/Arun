#Generated Form Function

function GenerateForm {

########################################################################

# Generated On: 12/10/2014 6:27 AM

# Generated By: Arun sabale

########################################################################

$ErrorActionPreference= 'silentlycontinue' 

#region Import the Assemblies

[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null

#endregion

 

#region Generated Form Objects

$form1 = New-Object System.Windows.Forms.Form

$label3 = New-Object System.Windows.Forms.Label

$statusBar1 = New-Object System.Windows.Forms.StatusBar

$button3 = New-Object System.Windows.Forms.Button

$button2 = New-Object System.Windows.Forms.Button

$button1 = New-Object System.Windows.Forms.Button

$richTextBox1 = New-Object System.Windows.Forms.RichTextBox

$label2 = New-Object System.Windows.Forms.Label

$label1 = New-Object System.Windows.Forms.Label

$dateTimePicker2 = New-Object System.Windows.Forms.DateTimePicker

$dateTimePicker1 = New-Object System.Windows.Forms.DateTimePicker

$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox2 = New-Object System.Windows.Forms.TextBox


#endregion Generated Form Objects

 

#----------------------------------------------

#Generated Event Script Blocks

#----------------------------------------------

#Provide Custom Code for events specified in PrimalForms.
$handler_textBox2_TextChanged= 
{
#TODO: Place custom script here
}

#Provide Custom Code for events specified in PrimalForms.
$handler_textBox1_TextChanged= 
{
#TODO: Place custom script here
}

#Provide Custom Code for events specified in PrimalForms.

$handler_button2_Click=
{
$richTextBox1.lines=""
}


$handler_dateTimePicker2_ValueChanged=

{
$enddate1 = $dateTimePicker2.Text
$enddate = $enddate1 + " "+ $TextBox2.text
$statusBar1.Text=$enddate
}

$handler_button1_Click=
{
If(!($richTextBox1.lines ))
{
$statusBar1.Text="Enter Server name.."
}
else
{
net use y: /delete
$enddate1 = $dateTimePicker2.Text
$enddate = $enddate1 + " "+ $TextBox2.text
$statusBar1.Text=$enddate
write-host "enddate is $enddate"

$startdate1 = $dateTimePicker1.Text
$startdate = $startdate1 + " "+ $TextBox1.text
$statusBar1.Text=$startdate
Write-Host "startdate is $startdate"

#$servers= $richTextBox1.Text -split(" ")
$servers= $richTextBox1.Lines
foreach($srv in $servers)
{
$statusBar1.Text="checking $srv"
if(Test-Connection $srv -Count 2)
{
$statusBar1.Text="$srv is reachable, collecting events"
Write-Host "$srv is reachable, collecting events"
$fdate  = get-date -Format ddMMyyyy
$enddate2=$enddate -split(" ")
$startdate2=$startdate -split(" ")
$localPath = "$env:userprofile\Desktop\$($srv)_Application_$($fdate).evtx"
$remotepath =  "\\"+$srv+"\c$"

Write-Host "path is $localPath"


if(test-path $localPath)
{
Remove-Item $localPath -Force
Write-Host "Removing old file $localPath"
}

function GetMilliseconds ($date) {
$ts = New-TimeSpan -Start $date -End (Get-Date)
[math]::Round($ts.TotalMilliseconds)
}

net use y: $remotepath
$movepath = "y:\$($srv)_Application_$($fdate).evtx"
write-host "remote path mapped to $movepath"
if(test-path $movepath)
{
Remove-Item $movepath -Force
Write-Host "Removing old file $movepath"
}
$startDate1 = GetMilliseconds(get-date $startDate)
$endDate1 = GetMilliseconds(get-date $endDate)
write-host $startDate1
write-host $endDate1
wevtutil.exe epl application "c:\$($srv)_Application_$($fdate).evtx" /r:"$srv" /q:"*[System[TimeCreated[timediff(@SystemTime) >= $endDate1] and TimeCreated[timediff(@SystemTime) <= $startDate1]]]"
Write-Host "Moving log file to desktop..."
Move-item  $movepath $localPath -Force
net use y: /delete
$statusBar1.Text="Collected events for $srv"
Write-Host "Collected events for $srv"
Write-Host "========================="
}
elseif(!(Test-Connection $srv -Count 2))
{
$statusBar1.Text="$srv is NOT reachable"
Write-Host "$srv is NOT reachable"
}
}
}
$statusBar1.Text="event extraction completed for ALL SERVERS"
Write-Host "=========================================="
Write-host "event extraction completed for ALL SERVERS"
Write-Host "=========================================="

}



$handler_dateTimePicker1_ValueChanged=

{

$startdate1 = $dateTimePicker1.Text
$startdate = $startdate1 + " "+ $TextBox1.text
$statusBar1.Text=$startdate

}

 

$handler_statusBar1_PanelClick=

{

#TODO: Place custom script here

 

}

 

$handler_button3_Click=

{

$form1.Close()

 

}

 

$handler_richTextBox1_TextChanged=

{

$statusBar1.Text = "Enter one server per line.."

 

}

 

$handler_label2_Click=

{

#TODO: Place custom script here

 

}

 

$handler_label1_Click=

{

#TODO: Place custom script here

 

}

 

$OnLoadForm_StateCorrection=

{#Correct the initial state of the form to prevent the .Net maximized form issue

       $form1.WindowState = $InitialFormWindowState

}

 

#----------------------------------------------

#region Generated Form Code

$System_Drawing_Size = New-Object System.Drawing.Size

$System_Drawing_Size.Height = 264

$System_Drawing_Size.Width = 430

$form1.ClientSize = $System_Drawing_Size

$form1.DataBindings.DefaultDataSourceUpdateMode = 0

$form1.Name = "form1"

$form1.Text = " Event Extrator"

 

$label3.DataBindings.DefaultDataSourceUpdateMode = 0

$label3.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,1,3,0)

$label3.ForeColor = [System.Drawing.Color]::FromArgb(255,0,102,204)

 

$System_Drawing_Point = New-Object System.Drawing.Point

$System_Drawing_Point.X = 13

$System_Drawing_Point.Y = 71

$label3.Location = $System_Drawing_Point

$label3.Name = "label3"

$System_Drawing_Size = New-Object System.Drawing.Size

$System_Drawing_Size.Height = 23

$System_Drawing_Size.Width = 100

$label3.Size = $System_Drawing_Size

$label3.TabIndex = 9

$label3.Text = "Server Names"

 

$form1.Controls.Add($label3)

 

$statusBar1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point

$System_Drawing_Point.X = 0

$System_Drawing_Point.Y = 242

$statusBar1.Location = $System_Drawing_Point

$statusBar1.Name = "statusBar1"

$System_Drawing_Size = New-Object System.Drawing.Size

$System_Drawing_Size.Height = 22

$System_Drawing_Size.Width = 430

$statusBar1.Size = $System_Drawing_Size

$statusBar1.TabIndex = 8

$statusBar1.Text = "Ready"

$statusBar1.add_PanelClick($handler_statusBar1_PanelClick)

 

$form1.Controls.Add($statusBar1)

 

 

$button3.DataBindings.DefaultDataSourceUpdateMode = 0

 

$System_Drawing_Point = New-Object System.Drawing.Point

$System_Drawing_Point.X = 253

$System_Drawing_Point.Y = 205

$button3.Location = $System_Drawing_Point

$button3.Name = "button3"

$System_Drawing_Size = New-Object System.Drawing.Size

$System_Drawing_Size.Height = 23

$System_Drawing_Size.Width = 75

$button3.Size = $System_Drawing_Size

$button3.TabIndex = 7

$button3.Text = "Exit"

$button3.UseVisualStyleBackColor = $True

$button3.add_Click($handler_button3_Click)

 

$form1.Controls.Add($button3)

 

 

$button2.DataBindings.DefaultDataSourceUpdateMode = 0

 

$System_Drawing_Point = New-Object System.Drawing.Point

$System_Drawing_Point.X = 147

$System_Drawing_Point.Y = 206

$button2.Location = $System_Drawing_Point

$button2.Name = "button2"

$System_Drawing_Size = New-Object System.Drawing.Size

$System_Drawing_Size.Height = 23

$System_Drawing_Size.Width = 75

$button2.Size = $System_Drawing_Size

$button2.TabIndex = 6

$button2.Text = "Clear"

$button2.UseVisualStyleBackColor = $True

$button2.add_Click($handler_button2_Click)

 

$form1.Controls.Add($button2)

 

 

$button1.DataBindings.DefaultDataSourceUpdateMode = 0

 

$System_Drawing_Point = New-Object System.Drawing.Point

$System_Drawing_Point.X = 42

$System_Drawing_Point.Y = 206

$button1.Location = $System_Drawing_Point

$button1.Name = "button1"

$System_Drawing_Size = New-Object System.Drawing.Size

$System_Drawing_Size.Height = 23

$System_Drawing_Size.Width = 75

$button1.Size = $System_Drawing_Size

$button1.TabIndex = 5

$button1.Text = "Get Log"

$button1.UseVisualStyleBackColor = $True

$button1.add_Click($handler_button1_Click)

 

$form1.Controls.Add($button1)

 

$richTextBox1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point

$System_Drawing_Point.X = 128

$System_Drawing_Point.Y = 71

$richTextBox1.Location = $System_Drawing_Point

$richTextBox1.Name = "richTextBox1"

$System_Drawing_Size = New-Object System.Drawing.Size

$System_Drawing_Size.Height = 90

$System_Drawing_Size.Width = 200

$richTextBox1.Size = $System_Drawing_Size

$richTextBox1.TabIndex = 4

$richTextBox1.Text = ""

$richTextBox1.add_TextChanged($handler_richTextBox1_TextChanged)



 

$form1.Controls.Add($richTextBox1)

 

$label2.DataBindings.DefaultDataSourceUpdateMode = 0

$label2.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,1,3,0)

$label2.ForeColor = [System.Drawing.Color]::FromArgb(255,0,102,204)

 

$System_Drawing_Point = New-Object System.Drawing.Point

$System_Drawing_Point.X = 12

$System_Drawing_Point.Y = 45

$label2.Location = $System_Drawing_Point

$label2.Name = "label2"

$System_Drawing_Size = New-Object System.Drawing.Size

$System_Drawing_Size.Height = 20

$System_Drawing_Size.Width = 61

$label2.Size = $System_Drawing_Size

$label2.TabIndex = 3

$label2.Text = "To Date"

$label2.add_Click($handler_label2_Click)

 

$form1.Controls.Add($label2)

 

$label1.DataBindings.DefaultDataSourceUpdateMode = 0

$label1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,1,3,0)

$label1.ForeColor = [System.Drawing.Color]::FromArgb(255,0,102,204)

 

$System_Drawing_Point = New-Object System.Drawing.Point

$System_Drawing_Point.X = 13

$System_Drawing_Point.Y = 22

$label1.Location = $System_Drawing_Point

$label1.Name = "label1"

$System_Drawing_Size = New-Object System.Drawing.Size

$System_Drawing_Size.Height = 16

$System_Drawing_Size.Width = 74

$label1.Size = $System_Drawing_Size

$label1.TabIndex = 2

$label1.Text = "From Date"

$label1.add_Click($handler_label1_Click)

 

$form1.Controls.Add($label1)



$dateTimePicker2.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
#$dateTimePicker2.CustomFormat = "MM/dd/yyyy hh:mm:ss tt" 

$System_Drawing_Point.X = 128
$System_Drawing_Point.Y = 45
$dateTimePicker1.MaxDate = "2020-12-31"
$dateTimePicker2.Location = $System_Drawing_Point
$dateTimePicker2.Name = "dateTimePicker2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 170
$dateTimePicker2.Size = $System_Drawing_Size
$dateTimePicker2.TabIndex = 1
$dateTimePicker2.add_ValueChanged($handler_dateTimePicker2_ValueChanged)

$form1.Controls.Add($dateTimePicker2)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 310
$System_Drawing_Point.Y = 45
$textBox2.Location = $System_Drawing_Point
$textBox2.Name = "textBox2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 70
$textBox2.Size = $System_Drawing_Size
$textBox2.TabIndex = 2
$textBox2.Text = "11:59:59 PM"
$textBox2.add_TextChanged($handler_textBox2_TextChanged)
$form1.Controls.Add($textBox2)
$dateTimePicker1.Checked = $False
$dateTimePicker1.DataBindings.DefaultDataSourceUpdateMode = 0

 

$dateTimePicker1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
#$dateTimePicker1.CustomFormat = "MM/dd/yyyy hh:mm:ss tt"
$System_Drawing_Point.X = 128
$System_Drawing_Point.Y = 22
$dateTimePicker1.Location = $System_Drawing_Point
$dateTimePicker1.Name = "dateTimePicker1"
$System_Drawing_Size = New-Object System.Drawing.Size
$dateTimePicker1.MaxDate = "2020-12-31"
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 170

$dateTimePicker1.Size = $System_Drawing_Size

$dateTimePicker1.TabIndex = 0

$dateTimePicker1.add_ValueChanged($handler_dateTimePicker1_ValueChanged)

 

$form1.Controls.Add($dateTimePicker1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 310
$System_Drawing_Point.Y = 22
$textBox1.Location = $System_Drawing_Point
$textBox1.Name = "textBox1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 70
$textBox1.Size = $System_Drawing_Size
$textBox1.TabIndex = 2
$textBox1.Text = "12:00:01 AM"
$textBox1.add_TextChanged($handler_textBox1_TextChanged)
$form1.Controls.Add($textBox1)
$dateTimePicker1.Checked = $False
$dateTimePicker1.DataBindings.DefaultDataSourceUpdateMode = 0
 

#endregion Generated Form Code

 

#Save the initial state of the form

$InitialFormWindowState = $form1.WindowState

#Init the OnLoad event to correct the initial state of the form

$form1.add_Load($OnLoadForm_StateCorrection)

#Show the Form

$form1.ShowDialog()| Out-Null

 

} #End Function

 

#Call the Function
cls
GenerateForm
