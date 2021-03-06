<#
    .SYNOPSIS
    Script to get OTC token for EY federated users to execute terraform and create resources

    .DESCRIPTION
    - connect to login.microsoftonline.com and get request id, cookies and other required detail then connect to EY adfs and validate creds and get SAML response.
	- connect OTC with SAMLResponse and RelayState to get the OTC token.
	- ui form to create ecs in otc
    
    .NOTES
    Author:     Arun Sabale
    Created:    31-05-2019
    Version:    1.0
    
    .Note 
    
#>
function GenerateForm {

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$EXIT = New-Object System.Windows.Forms.Button
$RESET = New-Object System.Windows.Forms.Button
$SUBMIT = New-Object System.Windows.Forms.Button
$groupBox3 = New-Object System.Windows.Forms.GroupBox
$WORKLOAD = New-Object System.Windows.Forms.ComboBox
$label17 = New-Object System.Windows.Forms.Label
$SERVICELINE = New-Object System.Windows.Forms.TextBox
$label16 = New-Object System.Windows.Forms.Label
$APPNAME = New-Object System.Windows.Forms.TextBox
$label15 = New-Object System.Windows.Forms.Label
$EYREGION = New-Object System.Windows.Forms.TextBox
$label13 = New-Object System.Windows.Forms.Label
$OWNER = New-Object System.Windows.Forms.TextBox
$label12 = New-Object System.Windows.Forms.Label
$CHARGECODE = New-Object System.Windows.Forms.TextBox
$label11 = New-Object System.Windows.Forms.Label
$APPTYPE = New-Object System.Windows.Forms.ComboBox
$label10 = New-Object System.Windows.Forms.Label
$TECHCONTACTS = New-Object System.Windows.Forms.TextBox
$label9 = New-Object System.Windows.Forms.Label
$ACCESSEDVIAINTERNET = New-Object System.Windows.Forms.ComboBox
$label8 = New-Object System.Windows.Forms.Label
$groupBox2 = New-Object System.Windows.Forms.GroupBox
$securitygroup = New-Object System.Windows.Forms.ComboBox
$label18 = New-Object System.Windows.Forms.Label
$subnetName = New-Object System.Windows.Forms.ComboBox
$label7 = New-Object System.Windows.Forms.Label
$vpcName = New-Object System.Windows.Forms.ComboBox
$label6 = New-Object System.Windows.Forms.Label
$groupBox1 = New-Object System.Windows.Forms.GroupBox
$serverrole = New-Object System.Windows.Forms.ComboBox
$label20 = New-Object System.Windows.Forms.Label
$Noofdisk = New-Object System.Windows.Forms.NumericUpDown
$DataDisk = New-Object System.Windows.Forms.Label
$keyPair = New-Object System.Windows.Forms.ComboBox
$vmSize = New-Object System.Windows.Forms.ComboBox
$PHYSICALREGION = New-Object System.Windows.Forms.ComboBox
$label5 = New-Object System.Windows.Forms.Label
$label14 = New-Object System.Windows.Forms.Label
$label4 = New-Object System.Windows.Forms.Label
$imageName = New-Object System.Windows.Forms.ComboBox
$label3 = New-Object System.Windows.Forms.Label
$ecsName = New-Object System.Windows.Forms.TextBox
$label2 = New-Object System.Windows.Forms.Label
$statusBar1 = New-Object System.Windows.Forms.StatusBar
$env = New-Object System.Windows.Forms.ComboBox
$label1 = New-Object System.Windows.Forms.Label
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.
$handler_RESET_Click= 
{
#TODO: Place custom script here

}

$handler_label6_Click= 
{
#TODO: Place custom script here

}

$handler_label12_Click= 
{
#TODO: Place custom script here

}

$handler_comboBox7_SelectedIndexChanged= 
{
#TODO: Place custom script here

}

$EXIT_OnClick= 
{
#TODO: Place custom script here

}

$SUBMIT_OnClick= 
{
#TODO: Place custom script here

}

$handler_label8_Click= 
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
$System_Drawing_Size.Height = 626
$System_Drawing_Size.Width = 612
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.Name = "form1"
$form1.Text = "OTC VM CREATION"


$EXIT.DataBindings.DefaultDataSourceUpdateMode = 0
$EXIT.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 347
$System_Drawing_Point.Y = 565
$EXIT.Location = $System_Drawing_Point
$EXIT.Name = "EXIT"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$EXIT.Size = $System_Drawing_Size
$EXIT.TabIndex = 9
$EXIT.Text = "EXIT"
$EXIT.UseVisualStyleBackColor = $True
$EXIT.add_Click($EXIT_OnClick)

$form1.Controls.Add($EXIT)


$RESET.DataBindings.DefaultDataSourceUpdateMode = 0
$RESET.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 249
$System_Drawing_Point.Y = 565
$RESET.Location = $System_Drawing_Point
$RESET.Name = "RESET"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$RESET.Size = $System_Drawing_Size
$RESET.TabIndex = 8
$RESET.Text = "RESET"
$RESET.UseVisualStyleBackColor = $True
$RESET.add_Click($handler_RESET_Click)

$form1.Controls.Add($RESET)


$SUBMIT.DataBindings.DefaultDataSourceUpdateMode = 0
$SUBMIT.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 146
$System_Drawing_Point.Y = 565
$SUBMIT.Location = $System_Drawing_Point
$SUBMIT.Name = "SUBMIT"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$SUBMIT.Size = $System_Drawing_Size
$SUBMIT.TabIndex = 7
$SUBMIT.Text = "SUBMIT"
$SUBMIT.UseVisualStyleBackColor = $True
$SUBMIT.add_Click($SUBMIT_OnClick)

$form1.Controls.Add($SUBMIT)


$groupBox3.DataBindings.DefaultDataSourceUpdateMode = 0
$groupBox3.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,1,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 389
$groupBox3.Location = $System_Drawing_Point
$groupBox3.Name = "groupBox3"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 155
$System_Drawing_Size.Width = 565
$groupBox3.Size = $System_Drawing_Size
$groupBox3.TabIndex = 6
$groupBox3.TabStop = $False
$groupBox3.Text = "TAGS"

$form1.Controls.Add($groupBox3)
$WORKLOAD.DataBindings.DefaultDataSourceUpdateMode = 0
$WORKLOAD.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$WORKLOAD.FormattingEnabled = $True
$WORKLOAD.Items.Add("Windows")|Out-Null
$WORKLOAD.Items.Add("Linux")|Out-Null
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 119
$WORKLOAD.Location = $System_Drawing_Point
$WORKLOAD.Name = "WORKLOAD"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 121
$WORKLOAD.Size = $System_Drawing_Size
$WORKLOAD.TabIndex = 19

$groupBox3.Controls.Add($WORKLOAD)

$label17.DataBindings.DefaultDataSourceUpdateMode = 0
$label17.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 118
$label17.Location = $System_Drawing_Point
$label17.Name = "label17"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label17.Size = $System_Drawing_Size
$label17.TabIndex = 18
$label17.Text = "WORKLOAD :"

$groupBox3.Controls.Add($label17)

$SERVICELINE.DataBindings.DefaultDataSourceUpdateMode = 0
$SERVICELINE.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 69
$SERVICELINE.Location = $System_Drawing_Point
$SERVICELINE.Name = "SERVICELINE"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 119
$SERVICELINE.Size = $System_Drawing_Size
$SERVICELINE.TabIndex = 17
$SERVICELINE.Text = "ie Assurance"

$groupBox3.Controls.Add($SERVICELINE)

$label16.DataBindings.DefaultDataSourceUpdateMode = 0
$label16.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 66
$label16.Location = $System_Drawing_Point
$label16.Name = "label16"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label16.Size = $System_Drawing_Size
$label16.TabIndex = 16
$label16.Text = "SERVICELINE :"

$groupBox3.Controls.Add($label16)

$APPNAME.DataBindings.DefaultDataSourceUpdateMode = 0
$APPNAME.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 407
$System_Drawing_Point.Y = 66
$APPNAME.Location = $System_Drawing_Point
$APPNAME.Name = "APPNAME"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 130
$APPNAME.Size = $System_Drawing_Size
$APPNAME.TabIndex = 15
$APPNAME.Text = "ie Project Name"

$groupBox3.Controls.Add($APPNAME)

$label15.DataBindings.DefaultDataSourceUpdateMode = 0
$label15.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 43
$label15.Location = $System_Drawing_Point
$label15.Name = "label15"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label15.Size = $System_Drawing_Size
$label15.TabIndex = 14
$label15.Text = "TECHCONTACTS :"

$groupBox3.Controls.Add($label15)

$EYREGION.DataBindings.DefaultDataSourceUpdateMode = 0
$EYREGION.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 407
$System_Drawing_Point.Y = 41
$EYREGION.Location = $System_Drawing_Point
$EYREGION.Name = "EYREGION"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 130
$EYREGION.Size = $System_Drawing_Size
$EYREGION.TabIndex = 11
$EYREGION.Text = "ie eu-de"

$groupBox3.Controls.Add($EYREGION)

$label13.DataBindings.DefaultDataSourceUpdateMode = 0
$label13.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 322
$System_Drawing_Point.Y = 42
$label13.Location = $System_Drawing_Point
$label13.Name = "label13"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label13.Size = $System_Drawing_Size
$label13.TabIndex = 10
$label13.Text = "EY-REGION :"

$groupBox3.Controls.Add($label13)

$OWNER.DataBindings.DefaultDataSourceUpdateMode = 0
$OWNER.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 407
$System_Drawing_Point.Y = 14
$OWNER.Location = $System_Drawing_Point
$OWNER.Name = "OWNER"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 130
$OWNER.Size = $System_Drawing_Size
$OWNER.TabIndex = 9
$OWNER.Text = "ie ArSa@sabale.com"

$groupBox3.Controls.Add($OWNER)

$label12.DataBindings.DefaultDataSourceUpdateMode = 0
$label12.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 322
$System_Drawing_Point.Y = 17
$label12.Location = $System_Drawing_Point
$label12.Name = "label12"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label12.Size = $System_Drawing_Size
$label12.TabIndex = 8
$label12.Text = "OWNER EMAIL :"
$label12.add_Click($handler_label12_Click)

$groupBox3.Controls.Add($label12)

$CHARGECODE.DataBindings.DefaultDataSourceUpdateMode = 0
$CHARGECODE.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 95
$CHARGECODE.Location = $System_Drawing_Point
$CHARGECODE.Name = "CHARGECODE"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 121
$CHARGECODE.Size = $System_Drawing_Size
$CHARGECODE.TabIndex = 7
$CHARGECODE.Text = "ie 12345678"

$groupBox3.Controls.Add($CHARGECODE)

$label11.DataBindings.DefaultDataSourceUpdateMode = 0
$label11.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 93
$label11.Location = $System_Drawing_Point
$label11.Name = "label11"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label11.Size = $System_Drawing_Size
$label11.TabIndex = 6
$label11.Text = "CHARGECODE :"

$groupBox3.Controls.Add($label11)

$APPTYPE.DataBindings.DefaultDataSourceUpdateMode = 0
$APPTYPE.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$APPTYPE.FormattingEnabled = $True
$APPTYPE.Items.Add("TYPE A")|Out-Null
$APPTYPE.Items.Add("TYPE B")|Out-Null
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 407
$System_Drawing_Point.Y = 92
$APPTYPE.Location = $System_Drawing_Point
$APPTYPE.Name = "APPTYPE"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 130
$APPTYPE.Size = $System_Drawing_Size
$APPTYPE.TabIndex = 5

$groupBox3.Controls.Add($APPTYPE)

$label10.DataBindings.DefaultDataSourceUpdateMode = 0
$label10.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 322
$System_Drawing_Point.Y = 95
$label10.Location = $System_Drawing_Point
$label10.Name = "label10"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label10.Size = $System_Drawing_Size
$label10.TabIndex = 4
$label10.Text = "APPTYPE :"

$groupBox3.Controls.Add($label10)

$TECHCONTACTS.DataBindings.DefaultDataSourceUpdateMode = 0
$TECHCONTACTS.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 42
$TECHCONTACTS.Location = $System_Drawing_Point
$TECHCONTACTS.Name = "TECHCONTACTS"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 121
$TECHCONTACTS.Size = $System_Drawing_Size
$TECHCONTACTS.TabIndex = 3
$TECHCONTACTS.Text = "ie ArSa@sabale.com"

$groupBox3.Controls.Add($TECHCONTACTS)

$label9.DataBindings.DefaultDataSourceUpdateMode = 0
$label9.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 322
$System_Drawing_Point.Y = 70
$label9.Location = $System_Drawing_Point
$label9.Name = "label9"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label9.Size = $System_Drawing_Size
$label9.TabIndex = 2
$label9.Text = "APP-NAME :"

$groupBox3.Controls.Add($label9)

$ACCESSEDVIAINTERNET.DataBindings.DefaultDataSourceUpdateMode = 0
$ACCESSEDVIAINTERNET.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$ACCESSEDVIAINTERNET.FormattingEnabled = $True
$ACCESSEDVIAINTERNET.Items.Add("Yes")|Out-Null
$ACCESSEDVIAINTERNET.Items.Add("No")|Out-Null
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 16
$ACCESSEDVIAINTERNET.Location = $System_Drawing_Point
$ACCESSEDVIAINTERNET.Name = "ACCESSEDVIAINTERNET"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 121
$ACCESSEDVIAINTERNET.Size = $System_Drawing_Size
$ACCESSEDVIAINTERNET.TabIndex = 1
$ACCESSEDVIAINTERNET.add_SelectedIndexChanged($handler_comboBox7_SelectedIndexChanged)

$groupBox3.Controls.Add($ACCESSEDVIAINTERNET)

$label8.DataBindings.DefaultDataSourceUpdateMode = 0
$label8.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 20
$label8.Location = $System_Drawing_Point
$label8.Name = "label8"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 155
$label8.Size = $System_Drawing_Size
$label8.TabIndex = 0
$label8.Text = "ACCESSED-VIA-INTERNET :"
$label8.add_Click($handler_label8_Click)

$groupBox3.Controls.Add($label8)



$groupBox2.DataBindings.DefaultDataSourceUpdateMode = 0
$groupBox2.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,1,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 276
$groupBox2.Location = $System_Drawing_Point
$groupBox2.Name = "groupBox2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 106
$System_Drawing_Size.Width = 481
$groupBox2.Size = $System_Drawing_Size
$groupBox2.TabIndex = 5
$groupBox2.TabStop = $False
$groupBox2.Text = "VPC INFO"

$form1.Controls.Add($groupBox2)
$securitygroup.DataBindings.DefaultDataSourceUpdateMode = 0
$securitygroup.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 73
$securitygroup.Location = $System_Drawing_Point
$securitygroup.Name = "securitygroup"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$securitygroup.Size = $System_Drawing_Size
$securitygroup.TabIndex = 5

$groupBox2.Controls.Add($securitygroup)

$label18.DataBindings.DefaultDataSourceUpdateMode = 0
$label18.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 74
$label18.Location = $System_Drawing_Point
$label18.Name = "label18"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label18.Size = $System_Drawing_Size
$label18.TabIndex = 4
$label18.Text = "SECURITY GROUP :"

$groupBox2.Controls.Add($label18)

$subnetName.DataBindings.DefaultDataSourceUpdateMode = 0
$subnetName.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$subnetName.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 47
$subnetName.Location = $System_Drawing_Point
$subnetName.Name = "subnetName"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$subnetName.Size = $System_Drawing_Size
$subnetName.TabIndex = 3

$groupBox2.Controls.Add($subnetName)

$label7.DataBindings.DefaultDataSourceUpdateMode = 0
$label7.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 47
$label7.Location = $System_Drawing_Point
$label7.Name = "label7"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label7.Size = $System_Drawing_Size
$label7.TabIndex = 2
$label7.Text = "SUBNET NAME :"

$groupBox2.Controls.Add($label7)

$vpcName.DataBindings.DefaultDataSourceUpdateMode = 0
$vpcName.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$vpcName.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 20
$vpcName.Location = $System_Drawing_Point
$vpcName.Name = "vpcName"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$vpcName.Size = $System_Drawing_Size
$vpcName.TabIndex = 1

$groupBox2.Controls.Add($vpcName)

$label6.DataBindings.DefaultDataSourceUpdateMode = 0
$label6.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 20
$label6.Location = $System_Drawing_Point
$label6.Name = "label6"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label6.Size = $System_Drawing_Size
$label6.TabIndex = 0
$label6.Text = "VPC NAME :"
$label6.add_Click($handler_label6_Click)

$groupBox2.Controls.Add($label6)



$groupBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$groupBox1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,1,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 53
$groupBox1.Location = $System_Drawing_Point
$groupBox1.Name = "groupBox1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 207
$System_Drawing_Size.Width = 481
$groupBox1.Size = $System_Drawing_Size
$groupBox1.TabIndex = 4
$groupBox1.TabStop = $False
$groupBox1.Text = "VM INFO"

$form1.Controls.Add($groupBox1)
$serverrole.DataBindings.DefaultDataSourceUpdateMode = 0
$serverrole.FormattingEnabled = $True
$serverrole.Items.Add("WB (Web Server)")|Out-Null
$serverrole.Items.Add("AP (Application server)")|Out-Null
$serverrole.Items.Add("SQ (SQL BD)")|Out-Null
$serverrole.Items.Add("CS (Cache Service)")|Out-Null
$serverrole.Items.Add("RS (SQL Reporting server)")|Out-Null
$serverrole.Items.Add("AS (SQL Analysis server)")|Out-Null
$serverrole.Items.Add("IS (SQL integration Service)")|Out-Null
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 47
$serverrole.Location = $System_Drawing_Point
$serverrole.Name = "serverrole"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$serverrole.Size = $System_Drawing_Size
$serverrole.TabIndex = 15

$groupBox1.Controls.Add($serverrole)

$label20.DataBindings.DefaultDataSourceUpdateMode = 0
$label20.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 44
$label20.Location = $System_Drawing_Point
$label20.Name = "label20"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label20.Size = $System_Drawing_Size
$label20.TabIndex = 14
$label20.Text = "SERVER ROLE :"

$groupBox1.Controls.Add($label20)

$Noofdisk.DataBindings.DefaultDataSourceUpdateMode = 0
$Noofdisk.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 178
$Noofdisk.Location = $System_Drawing_Point
$Noofdisk.Maximum = 24
$Noofdisk.Name = "Noofdisk"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 53
$Noofdisk.Size = $System_Drawing_Size
$Noofdisk.TabIndex = 11

$groupBox1.Controls.Add($Noofdisk)

$DataDisk.DataBindings.DefaultDataSourceUpdateMode = 0
$DataDisk.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 175
$DataDisk.Location = $System_Drawing_Point
$DataDisk.Name = "DataDisk"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$DataDisk.Size = $System_Drawing_Size
$DataDisk.TabIndex = 10
$DataDisk.Text = "DATA DISK :"

$groupBox1.Controls.Add($DataDisk)

$keyPair.DataBindings.DefaultDataSourceUpdateMode = 0
$keyPair.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$keyPair.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 127
$keyPair.Location = $System_Drawing_Point
$keyPair.Name = "keyPair"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$keyPair.Size = $System_Drawing_Size
$keyPair.TabIndex = 9

$groupBox1.Controls.Add($keyPair)

$vmSize.DataBindings.DefaultDataSourceUpdateMode = 0
$vmSize.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$vmSize.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 100
$vmSize.Location = $System_Drawing_Point
$vmSize.Name = "vmSize"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$vmSize.Size = $System_Drawing_Size
$vmSize.TabIndex = 8

$groupBox1.Controls.Add($vmSize)

$PHYSICALREGION.DataBindings.DefaultDataSourceUpdateMode = 0
$PHYSICALREGION.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$PHYSICALREGION.FormattingEnabled = $True
$PHYSICALREGION.Items.Add("eu-de-01")|Out-Null
$PHYSICALREGION.Items.Add("eu-de-02")|Out-Null
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 153
$PHYSICALREGION.Location = $System_Drawing_Point
$PHYSICALREGION.Name = "PHYSICALREGION"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$PHYSICALREGION.Size = $System_Drawing_Size
$PHYSICALREGION.TabIndex = 13

$groupBox1.Controls.Add($PHYSICALREGION)

$label5.DataBindings.DefaultDataSourceUpdateMode = 0
$label5.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 127
$label5.Location = $System_Drawing_Point
$label5.Name = "label5"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label5.Size = $System_Drawing_Size
$label5.TabIndex = 7
$label5.Text = "KEY PAIR :"

$groupBox1.Controls.Add($label5)

$label14.DataBindings.DefaultDataSourceUpdateMode = 0
$label14.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 152
$label14.Location = $System_Drawing_Point
$label14.Name = "label14"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 111
$label14.Size = $System_Drawing_Size
$label14.TabIndex = 12
$label14.Text = "PHYSICAL REGION :"

$groupBox1.Controls.Add($label14)

$label4.DataBindings.DefaultDataSourceUpdateMode = 0
$label4.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 100
$label4.Location = $System_Drawing_Point
$label4.Name = "label4"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label4.Size = $System_Drawing_Size
$label4.TabIndex = 6
$label4.Text = "VM SIZE :"

$groupBox1.Controls.Add($label4)

$imageName.DataBindings.DefaultDataSourceUpdateMode = 0
$imageName.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$imageName.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 73
$imageName.Location = $System_Drawing_Point
$imageName.Name = "imageName"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$imageName.Size = $System_Drawing_Size
$imageName.TabIndex = 5

$groupBox1.Controls.Add($imageName)

$label3.DataBindings.DefaultDataSourceUpdateMode = 0
$label3.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 71
$label3.Location = $System_Drawing_Point
$label3.Name = "label3"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label3.Size = $System_Drawing_Size
$label3.TabIndex = 4
$label3.Text = "IMAGE NAME :"

$groupBox1.Controls.Add($label3)

$ecsName.DataBindings.DefaultDataSourceUpdateMode = 0
$ecsName.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 180
$System_Drawing_Point.Y = 20
$ecsName.Location = $System_Drawing_Point
$ecsName.Name = "ecsName"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 192
$ecsName.Size = $System_Drawing_Size
$ecsName.TabIndex = 3
$ecsName.Text = "3 letters app short name"

$groupBox1.Controls.Add($ecsName)

$label2.DataBindings.DefaultDataSourceUpdateMode = 0
$label2.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 23
$label2.Location = $System_Drawing_Point
$label2.Name = "label2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label2.Size = $System_Drawing_Size
$label2.TabIndex = 2
$label2.Text = "APP SHORT NAME :"

$groupBox1.Controls.Add($label2)


$statusBar1.DataBindings.DefaultDataSourceUpdateMode = 0
$statusBar1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = 604
$statusBar1.Location = $System_Drawing_Point
$statusBar1.Name = "statusBar1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 22
$System_Drawing_Size.Width = 612
$statusBar1.Size = $System_Drawing_Size
$statusBar1.TabIndex = 3
$statusBar1.Text = "Status.."

$form1.Controls.Add($statusBar1)

$env.DataBindings.DefaultDataSourceUpdateMode = 0
$env.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,0,3,1)
$env.FormattingEnabled = $True
$env.Items.Add("Type A PROD Tenant")|Out-Null
$env.Items.Add("Type A Non-PROD Tenant")|Out-Null
$env.Items.Add("Type A Management Tenant")|Out-Null
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 205
$System_Drawing_Point.Y = 16
$env.Location = $System_Drawing_Point
$env.Name = "env"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 192
$env.Size = $System_Drawing_Size
$env.TabIndex = 1

$form1.Controls.Add($env)

$label1.DataBindings.DefaultDataSourceUpdateMode = 0
$label1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",6.75,1,3,1)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 16
$label1.Location = $System_Drawing_Point
$label1.Name = "label1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 129
$label1.Size = $System_Drawing_Size
$label1.TabIndex = 0
$label1.Text = "SELECT OTC  ENV :"

$form1.Controls.Add($label1)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm
