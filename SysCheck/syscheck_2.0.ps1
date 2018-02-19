
<#------VISUAL--------------------------------------------------------------------------------------------------------------------------------#>

### Copyright {2016} {Miguel Tillis Jr}

# Generated report location
$datapath= ".\"

#region System Info

       $OS = (Get-WmiObject Win32_OperatingSystem <#-computername $computer#>).caption
       $SystemInfo = Get-WmiObject -Class Win32_OperatingSystem <# -computername $computer#> | Select-Object Name, TotalVisibleMemorySize, FreePhysicalMemory
       $TotalRAM = $SystemInfo.TotalVisibleMemorySize/1MB
       $FreeRAM = $SystemInfo.FreePhysicalMemory/1MB
       $UsedRAM = $TotalRAM - $FreeRAM
       $RAMPercentFree = ($FreeRAM / $TotalRAM) * 100
       $TotalRAM = [Math]::Round($TotalRAM, 2)
       $FreeRAM = [Math]::Round($FreeRAM, 2)
       $UsedRAM = [Math]::Round($UsedRAM, 2)
       $RAMPercentFree = [Math]::Round($RAMPercentFree, 2)
      #$cputime= Get-counter -Counter "\Processor(_Total)\% Processor Time"
      #$cputime= Get-WmiObject win32_processor | select LoadPercentage | fl
       $cputime= Get-WmiObject win32_processor | select LoadPercentage | ConvertTo-Html -Fragment
       
       $numberOfCores= Get-WmiObject -class win32_processor -Property numberOfCores | findstr NumberOfCores
       $NumberOfLogicalProcessors= Get-WmiObject –class Win32_processor -Property NumberOfLogicalProcessors | findstr NumberOfLogicalProcessors 

       $cores= $numberOfCores -split "(:)" | Select-String -Pattern [0-9] | %{$_ -replace "",""}
       $processors= $NumberOfLogicalProcessors -split "(:)" | Select-String -Pattern [0-9] | %{$_ -replace "",""}
       
#endregion





<#------START CHART--------------------------------------------------------------------------------------------------------------------------------#>

function memorychart {
# load the appropriate assemblies 
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")

#System.Windows.Forms gives you the standard forms classes.
#While not necessary in order to use the Chart Controls, I’ll be using a form later to display the chart.
#System.Windows.Forms.DataVisualization is the main namespace for the chart controls.

#Next you’ll need to create a Chart object and set some basic properties:
# create chart object 
$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
$Chart.Width = 500 
$Chart.Height = 400 
$Chart.Left = 40 
$Chart.Top = 30

#Next you must define a ChartArea to draw on and add this to the Chart:
# create a chartarea to draw on and add to chart 
$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
$Chart.ChartAreas.Add($ChartArea)

# ------ MANIPULATE DATA----------------------------------

#SET DATA variables
$bingo= 10000000

#Now for some data to display:
#add data to chart 
$Cities = @{FreeRam=$FreeRam; UsedRam=$UsedRam} 
[void]$Chart.Series.Add("Data")
 
[void]$Chart.Titles.Add("Top 5 European Cities by Population") 
$Chart.Series["Data"].Points.DataBindXY($Cities.Keys, $Cities.Values)


<# -- PIE CHART FORMAT -- TO USE COMMENT OUT BAR CHART FORMAT #>
$Chart.Series["Data"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie

# display the chart on a form 
$Chart.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor 
                [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left 

# To make it very fancy - Exlpode regions
$Chart.Series["Data"]["PieLabelStyle"] = "Outside" 
$Chart.Series["Data"]["PieLineColor"] = "Black" 
$Chart.Series["Data"]["PieDrawingStyle"] = "Concave" 
($Chart.Series["Data"].Points.FindMaxByValue())["Exploded"] = $true
$Form = New-Object Windows.Forms.Form 
$Form.Text = "PowerShell Chart" 
$Form.Width = 600 
$Form.Height = 600 
$Form.controls.add($Chart) 
$Form.Add_Shown({$Form.Activate()}) 

##Show the Chart in a Window
#$Form.ShowDialog()

#$Chart.SaveImage($FileName + ".png","png")

#Set the title of the Chart to the current date and time 
       $Title = new-object System.Windows.Forms.DataVisualization.Charting.Title 
       $Chart.Titles.Add($Title) 
       $Chart.Titles[0].Text = "RAM Usage Chart (Used/Free)"

# To make it very fancy - Exlpode regions
$Chart.Series["Data"]["PieLabelStyle"] = "Outside" 
$Chart.Series["Data"]["PieLineColor"] = "Black" 
$Chart.Series["Data"]["PieDrawingStyle"] = "Concave" 
($Chart.Series["Data"].Points.FindMaxByValue())["Exploded"] = $true

#Save the chart to a file
$Chart.SaveImage($datapath + "memoryChart.png", "PNG")
}



## CALL CHART FUNCTION
memorychart
<#------END CHART-------------------------------------------------------------------------------------------------------------------------------------------------------------#>



# Assemble the HTML Header and CSS for our Report


$HTMLHeader = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>My Systems Report</title>
<style type="text/css">
<!--
body {
font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
}
    #report { width: 835px; }
    
    table{
       border-collapse: collapse;
       border: none;
       font: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
       color: black;
       margin-bottom: 10px;
}
    table td{
       font-size: 12px;
       padding-left: 0px;
       padding-right: 20px;
       text-align: left;
}
    table th {
       font-size: 12px;
       font-weight: bold;
       padding-left: 0px;
       padding-right: 20px;
       text-align: left;
}
h2{ clear: both; font-size: 130%; }
h3{
       clear: both;
       font-size: 115%;
       margin-left: 20px;
       margin-top: 30px;
}
p{ margin-left: 20px; font-size: 12px; }
table.list{ float: left; }
    table.list td:nth-child(1){
       font-weight: bold;
       border-right: 1px grey solid;
       text-align: right;
}
table.list td:nth-child(2){ padding-left: 7px; }
table tr:nth-child(even) td:nth-child(even){ background: #CCCCCC; }
table tr:nth-child(odd) td:nth-child(odd){ background: #F2F2F2; }
table tr:nth-child(even) td:nth-child(odd){ background: #DDDDDD; }
table tr:nth-child(odd) td:nth-child(even){ background: #E5E5E5; }
div.column { width: 320px; float: left; }
div.first{ padding-right: 20px; border-right: 1px  grey solid; }
div.second{ margin-left: 30px; }
table{ margin-left: 20px; }
-->
</style>
</head>
<body>
"@



# Disk space capacity check
function diskinfo {
$diskleft= gwmi win32_logicaldisk | where {$_.DriveType -ne "5"} | where {$_.DriveType -ne "2"}

# for each disk in the list of logical disks do this
foreach ($disk in $diskleft) {

$diskname = $disk | select DeviceID -ExpandProperty DeviceID

$freeSpace= $disk | select FreeSpace | %{$_.freespace/1GB}
$diskcap= $disk | select Size | %{$_.Size/1GB}
$percent_available = $freeSpace/$diskcap

    [int]$threshhold = 15

$percent_readable= $percent_available*100


if ($percent_readable -lt $threshhold)
{
    $warn = "<b style='color:red'>$diskname is full</b><br><b style='color:red'>Free Space: $freeSpace GB</b><br>"
    $warn
        } Else { 
        echo "$diskname is not full<br>"
        echo "$diskname percent available: %$percent_readable<br>"
        echo "$diskname Free Space Available: $freeSpace GB<br><br>"
        }

    }
}
$diskinfo= diskinfo


# Get top processes
$TopProcesses = Get-Process | Sort WS -Descending | Select ProcessName, Id, WS -First 10 | ConvertTo-Html -Fragment

#region Services Report
       $ServicesReport = @()
       $Services = Get-WmiObject -Class Win32_Service <#-ComputerName $computer#> | Where {($_.StartMode -eq "Auto") -and ($_.State -eq "Stopped")}

       foreach ($Service in $Services) {
              $row = New-Object -Type PSObject -Property @{
                     Name = $Service.Name
                     Status = $Service.State
                     StartMode = $Service.StartMode
              }
              
       $ServicesReport += $row
       
       }
       
       $ServicesReport = $ServicesReport | ConvertTo-Html -Fragment



#Region Security Logs Report
       $SecurityEventsReport = @()
       $a = Get-EventLog -LogName Security -EntryType FailureAudit,Warning,Error -After (Get-Date).AddDays(-1) | %{$_.'InstanceID'} | sort -Unique
       $RawSecurityEvents = Get-EventLog -LogName Security -EntryType FailureAudit,Error,Warning -After (Get-Date).AddDays(-1)
       $newarray = @()
       foreach ($item in $a) {
       $b = $RawSecurityEvents | where -Property "InstanceID" -EQ "$item" | select -First 1
       $newarray += $b
       }

       
       $SecurityEventsReport = $newarray | ConvertTo-Html -Fragment
       if ($newarray.Count-gt 0 ){
       #$SecurityEventsReport
       } else {
       $SecurityEventsReport = "<p style='color:white;background-color:green'>NO Security Audit Failures, Errors, or Warnings</p>"     
       }

       














#region Event Logs Report Get-EventLog Application -After (Get-Date).AddDays(-1)
       $SystemEventsReport = @()
       $a = Get-EventLog <#-ComputerName $computer#> -LogName System -EntryType Error,Warning -After (Get-Date).AddDays(-1) | %{$_.'InstanceID'} | sort -Unique
       $RawSystemEvents = Get-EventLog <#-ComputerName $computer#> -LogName System -EntryType Error,Warning -After (Get-Date).AddDays(-1)
       $newarray = @()
       foreach ($item in $a) {
       #$SystemEvents = $RawSystemEvents | where -Property "InstanceID" -EQ "$item"
       $b = $RawSystemEvents | where -Property "InstanceID" -EQ "$item" | select -First 1

       $newarray += $b
       }
           

       $SystemEventsReport = $newarray | ConvertTo-Html -Fragment
       





       $ApplicationEventsReport = @()
       $appevents_array = @()
       $c = Get-EventLog <#-ComputerName $computer#> -LogName Application -EntryType Error,Warning -After (Get-Date).AddDays(-1) | %{$_.'InstanceID'} | sort -Unique
       $appevents_raw = Get-EventLog <#-ComputerName $computer#> -LogName Application -EntryType Error,Warning -After (Get-Date).AddDays(-1)


        foreach ($item in $c) {
       $d = $appevents_raw | where -Property "InstanceID" -EQ "$item" | select -First 1
       $appevents_array += $d
       }
         

       $ApplicationEventsReport = $appevents_array | ConvertTo-Html -Fragment
#endregion

# Get uptime
Function Get-HostUptime {
      # param ([string]$ComputerName);
       $Uptime = Get-WmiObject -Class Win32_OperatingSystem <#-ComputerName $ComputerName#>;
       $LastBootUpTime = $Uptime.ConvertToDateTime($Uptime.LastBootUpTime);
       $Time = (Get-Date) - $LastBootUpTime;
       Return '{0:00} Days, {1:00} Hours, {2:00} Minutes, {3:00} Seconds' -f $Time.Days, $Time.Hours, $Time.Minutes, $Time.Seconds;
}


# Get Diskspace
Function Get-DiskSpace { 
Get-WMIObject WIN32_Logicaldisk | Where-Object{$_.DriveType -eq 3} | Where-Object{ ($_.freespace/$_.Size)*100 -lt $thresholdspace} | Select-Object SystemName, DriveType, VolumeName, Name, @{n='Size (GB)'
e={"{0:n2}" -f ($_.size/1gb)}}, @{n='FreeSpace (GB)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}} | ConvertTo-HTML -Fragment
}



       $SystemUptime = Get-HostUptime <#-ComputerName $computer#>
       $getdate= Get-Date
       
# Create HTML Report for the current System being looped through
       $CurrentSystemHTML = @"
       
       <hr noshade size=3 width="100%">
       <div id="report">
       <h2><b>System Status Check 2.0</b></h2>
       <b>$getdate</b>
       <p><h2>$env:computername Daily System Status Check Report</p></h2>
       <h3>System Info</h3>
       <table class="list">
       <tr>
       <td>System Uptime</td>
       <td>$SystemUptime</td>
       </tr>
       <tr>
       <td>OS</td>
       <td>$OS</td>
       </tr>
       <tr>
       <td>Total RAM (GB)</td>
       <td>$TotalRAM</td>
       </tr>
       <tr>
       <td>Free RAM (GB)</td>
       <td>$FreeRAM</td>
       </tr>
       <tr>
       <td>Percent free RAM</td>
       <td>$RAMPercentFree</td>
       </tr>
       <tr>
       <td> Load Average</td>
       <td>$cputime</td>
       </tr>
    <tr>
       <td> # Of Cores</td>
       <td>$cores</td>
       </tr>
       <tr>
       <td> # Of Logical Processors</td>
       <td>$processors</td>
       </tr>
       </table>
       
       <!--<IMG SRC="cpuChart.png" ALT="status Chart">-->
       <!--<IMG SRC="diskspaceChart.png" ALT="status Chart">-->
       
              
       <h3>Disk Info</h3>
       <p>Drive(s) listed below have less than $thresholdspace %15 free space. Drives above this threshold will not be listed.</p>
       <p>$diskinfo</p>
       <br></br>
       
       <div class="first column">
       <h3>System Processes - Top $ProccessNumToFetch Highest Memory Usage</h3>
       <p>The following $ProccessNumToFetch processes are those consuming the highest amount of Working Set (WS) Memory (bytes) on $env:computername</p>
       <table class="normal">$TopProcesses</table>
       </div>
       <div class="second column">
       
       <h3>System Services - Automatic Startup but not Running</h3>
       <p>The following services are those which are set to Automatic startup type, yet are currently not running on $env:computername</p>
       <table class="normal">
       $ServicesReport
       </table>
       </div>



       
       <h3>Events Report - The last $EventNum Security/System/Application Log Events that were Warnings or Errors</h3>

       <p>The following is a list unsuccessful <b style="font-size:2em">Security Attempts</b> on this system for the last 24 hours $EventNum <b style="font-size:2em"></b> on $env:computername</p>
       <table class="normal">$SecurityEventsReport</table>

       <p>The following is a list of the last $EventNum <b style="font-size:2em">System log</b> events that had an Event Type of either Warning or Error on $env:computername</p>
       <table class="normal">$SystemEventsReport</table>


       <p>The following is a list of the last $EventNum <b style="font-size:2em">Application log</b> events that had an Event Type of either Warning or Error on $env:computername</p>
       <table class="normal">$ApplicationEventsReport</table>By Miguel Tillis Jr. 2/12/2016
"@
       # Add the current System HTML Report into the final HTML Report body

       
       
# Assemble the closing HTML for our report.
$HTMLEnd = @"
</div>
<script>
var acc = document.getElementsByClassName("accordion");
var i;

for (i = 0; i < acc.length; i++) {
  acc[i].onclick = function() {
    this.classList.toggle("active");
    var panel = this.nextElementSibling;
    if (panel.style.maxHeight){
      panel.style.maxHeight = null;
    } else {
      panel.style.maxHeight = panel.scrollHeight + "px";
    } 
  }
}

</script>
</body>
</html>
"@

$HTMLmessage = $HTMLHeader + <#$HTMLMiddle#> $CurrentSystemHTML + $HTMLEnd

Echo $HTMLmessage | Out-file .\$env:computername.html

# Send email that contains report, chart, & attached report
<#
$PSEmailServer='smtp.sd.spawar.navy.mil'
Send-MailMessage -From youremail@email.com -Subject "$env:computername DSR" -To "youremail@email.com" -Attachments "$datapath\memoryChart.png", "$datapath\$env:computername.html" -BodyAsHtml "$HTMLmessage"
#>
# SIG # Begin signature block
# MIILzQYJKoZIhvcNAQcCoIILvjCCC7oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUSib93uWADYXLBul61KpV4qYf
# tX2ggglYMIIEoDCCA4igAwIBAgIBFTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQG
# EwJVUzEYMBYGA1UEChMPVS5TLiBHb3Zlcm5tZW50MQwwCgYDVQQLEwNEb0QxDDAK
# BgNVBAsTA1BLSTEWMBQGA1UEAxMNRG9EIFJvb3QgQ0EgMzAeFw0xNTExMDkxNjA5
# NDJaFw0yMTExMDkxNjA5NDJaMF0xCzAJBgNVBAYTAlVTMRgwFgYDVQQKEw9VLlMu
# IEdvdmVybm1lbnQxDDAKBgNVBAsTA0RvRDEMMAoGA1UECxMDUEtJMRgwFgYDVQQD
# Ew9ET0QgRU1BSUwgQ0EtNDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCmnSX1j25X0lrlxl7FTi65DxzSaXlUQwPPILHxQh4pWMbA7Rff4r+duETma3mr
# Pmaej45HKYPF+1jFiV+jLiPFXzQKcsrrImratXcABFus0lA8xBtvhjZTE/vmGSXZ
# pBPFAkybjof3OJBzzWwo+kPrK/je0Kbrlq4jekNcpXDeR4Qp2FXtwMgeS9RnMGUW
# bO7sv/iJceUkXD9WG6IY2GW3EMsx5MJtxe6M7ACsMb0J3eN+2BAxAZZGjMRjPa2C
# +2kc922jBsr4mfQ9hEbWEu5wWLwiJLBH+9NaTBxlqcGS8yyX0xQktvLHlrmnIUpQ
# ksH3x/6FUnzXQ1CKhaENi4lvAgMBAAGjggFrMIIBZzAfBgNVHSMEGDAWgBRsipSi
# d7GAch2Behaq8tzOZu5FwDAdBgNVHQ4EFgQUbwWkXaLEr5VbQZHfC3gLFu8cCW4w
# DgYDVR0PAQH/BAQDAgGGMEwGA1UdIARFMEMwCwYJYIZIAWUCAQskMAsGCWCGSAFl
# AgELJzALBglghkgBZQIBCyowDAYKYIZIAWUDAgEDDTAMBgpghkgBZQMCAQMRMBIG
# A1UdEwEB/wQIMAYBAf8CAQAwDAYDVR0kBAUwA4ABADA3BgNVHR8EMDAuMCygKqAo
# hiZodHRwOi8vY3JsLmRpc2EubWlsL2NybC9ET0RST09UQ0EzLmNybDBsBggrBgEF
# BQcBAQRgMF4wOgYIKwYBBQUHMAKGLmh0dHA6Ly9jcmwuZGlzYS5taWwvaXNzdWVk
# dG8vRE9EUk9PVENBM19JVC5wN2MwIAYIKwYBBQUHMAGGFGh0dHA6Ly9vY3NwLmRp
# c2EubWlsMA0GCSqGSIb3DQEBCwUAA4IBAQB+0vQGArx8bB3kLkQtlSq/JQdzYG9Z
# xTu1W+nveaBUzXyhUyBP1OEA0ZvyiAt7km95y3/H65mZqtBRQuz+jYf0Hxxd0fFw
# 2cXrU8oNpf9of8SIit3g7H/lPvCzQrixjBPJyIZiuF/1tGqS7OmQP/4jU3+R8uvV
# hUi3AX2DXAm4VTcBpCsG3ozOCpJykAQZJxaOgqSJHFLNdPByr1fMvpsFOkSWwlGz
# mWObh4Xwud0+naP4pbqKYjue/MeAGqgmxMJTn4hFXS5bHMViscJpnZtJz1J6XsA8
# aSiZO/uliO/vQx3CzdEWCMB1ZCGP0xdzfDipKEMDPRpA3ucPj3dgb3MrMIIEsDCC
# A5igAwIBAgIDGJesMA0GCSqGSIb3DQEBCwUAMF0xCzAJBgNVBAYTAlVTMRgwFgYD
# VQQKEw9VLlMuIEdvdmVybm1lbnQxDDAKBgNVBAsTA0RvRDEMMAoGA1UECxMDUEtJ
# MRgwFgYDVQQDEw9ET0QgRU1BSUwgQ0EtNDIwHhcNMTcxMjExMDAwMDAwWhcNMTgx
# MDAxMjM1OTU5WjB+MQswCQYDVQQGEwJVUzEYMBYGA1UEChMPVS5TLiBHb3Zlcm5t
# ZW50MQwwCgYDVQQLEwNEb0QxDDAKBgNVBAsTA1BLSTETMBEGA1UECxMKQ09OVFJB
# Q1RPUjEkMCIGA1UEAxMbVElMTElTLk1JR1VFTC5KUi4xNTE1NDMzNzU1MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv4U/FFGcnYOl1uFnRsIvNN/JgFLS
# E3e0RMJNQ2DMIKKsi36VfS1k+gLTZ6gEi9wXanLs1qXvW90LOaXXOFYWJTSIBuqC
# h+6NoSnygNlIPSocdybFIKRvqIMTF9B/QT30xwtFa2yyIV/9rjiTeNIs9BxQl2Qi
# c4lw4LnDCSD1080e5rzwcRqLYf3D9Q+jnHcVpcEzUZkI+vpKw42tv9j7+OtpSbgG
# t3dYDcsL07kMmuFbd/kGsKwgKa+QM1DOOw0/cK1iUG1lWd04y/6mjuIXNAoQQCY8
# pus+wRarx3iBgVYlPaLmikcl4kH7LJjD0mQMfznA2/tZOXI8QqAYzGqfVwIDAQAB
# o4IBVjCCAVIwHwYDVR0jBBgwFoAUbwWkXaLEr5VbQZHfC3gLFu8cCW4wOgYDVR0f
# BDMwMTAvoC2gK4YpaHR0cDovL2NybC5kaXNhLm1pbC9jcmwvRE9ERU1BSUxDQV80
# Mi5jcmwwDgYDVR0PAQH/BAQDAgUgMBYGA1UdIAQPMA0wCwYJYIZIAWUCAQsnMB0G
# A1UdDgQWBBS8whSSJLJn2LpIOCQuu1v1bE4k4zBoBggrBgEFBQcBAQRcMFowNgYI
# KwYBBQUHMAKGKmh0dHA6Ly9jcmwuZGlzYS5taWwvc2lnbi9ET0RFTUFJTENBXzQy
# LmNlcjAgBggrBgEFBQcwAYYUaHR0cDovL29jc3AuZGlzYS5taWwwJQYDVR0RBB4w
# HIEabWlndWVsLnRpbGxpcy5jdHJAbmF2eS5taWwwGwYDVR0JBBQwEjAQBggrBgEF
# BQcJBDEEEwJVUzANBgkqhkiG9w0BAQsFAAOCAQEAMxjrllaIYARQxTavspgVRZGx
# ehs5ktulX4fJbL3/zDBx3uAYQa99a1BGdCHw6CjaWjnx6Fru9n9lpMSOIVM79L5z
# 5dUVtjuZqAP1w7TdFrmtT6GOpY7VARhDnsEgq9jbRJ2iwNFIhWfdGcFBfzcIdH0c
# SgKDgf9HLdZY1LwfJgZSmmbfQwvoLxsECO1w3iLcK/YFSJUZ8PQCZbyJhySrExp9
# V3HWQHLWGbIHH2upmThy87H1x3scrZtOJkA5GIGTy+rhOxOXHl21h31gbX0TDzxw
# R+TQbx/t12EuKYlUwxqeOLGbUnmplw+zLTdJs6MDntAJ1RETOYze6cG+h0HdmjGC
# Ad8wggHbAgEBMGQwXTELMAkGA1UEBhMCVVMxGDAWBgNVBAoTD1UuUy4gR292ZXJu
# bWVudDEMMAoGA1UECxMDRG9EMQwwCgYDVQQLEwNQS0kxGDAWBgNVBAMTD0RPRCBF
# TUFJTCBDQS00MgIDGJesMAkGBSsOAwIaBQCgUjAQBgorBgEEAYI3AgEMMQIwADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAjBgkqhkiG9w0BCQQxFgQUPKgu443S
# ZDXpC1vVJ1JKxlPO+CwwDQYJKoZIhvcNAQEBBQAEggEAVdxzskHsgT6hraCSLaqI
# G46ph7UN2BgLTT9/hGcAC2DfTNPf8GvKsanebweKmv8meBcX8QE9OPopsXDcoD/h
# HQ2Mw7cJ4BZHTVODw2D35MGK4X1AiYkZuMSCdo2TqxEbYsCptyQrfvjgKOXNeE0l
# qUBEGvl4HXmGLjy2DXTMvxo8rmia9lVBnR5kwMyZAVXB47Elsb3T/ixbPRWPv0P5
# 8jsmOe9s5irmIYnhl3B/Ab/geHUYZLYIH+HnwtBcplfKwu5avtCX6gZ0YimTpsqy
# qRmMVtJDpdAcA0/vuwEU90EacJYG6FPEJenVWDljzQLwOs6r2ZbBcjP6ljehp389
# xg==
# SIG # End signature block
