
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
#endregion

       <#
       $a = Get-EventLog -LogName System -EntryType Error,Warning -After (Get-Date).AddDays(-1) | %{$_.'InstanceID'} | sort -Unique
       $RawSystemEvents = Get-EventLog -LogName System -EntryType Error,Warning -After (Get-Date).AddDays(-1)
       $newarray = @()
       foreach ($item in $a) {
       $b = $RawSystemEvents | where -Property "InstanceID" -EQ "$item" | select -First 1

       $newarray += $b
       }

       #>


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


       foreach ($event in $SystemEvents) {
              $row = New-Object -Type PSObject -Property @{
                     TimeGenerated = $event.TimeGenerated
                     EntryType = $event.EntryType
                     Source = $event.Source
                     Message = $event.Message
              }
              $SystemEventsReport += $row
       }
               # $SystemEventsReport | %{$_.Message} | select -Unique             

       $SystemEventsReport = $newarray <#| %{$_.Message} | select -Unique  #>| ConvertTo-Html -Fragment
       





       $ApplicationEventsReport = @()
       $appevents_array = @()
       $c = Get-EventLog <#-ComputerName $computer#> -LogName Application -EntryType Error,Warning -After (Get-Date).AddDays(-1) | %{$_.'InstanceID'} | sort -Unique
       $appevents_raw = Get-EventLog <#-ComputerName $computer#> -LogName Application -EntryType Error,Warning -After (Get-Date).AddDays(-1)
       #$ApplicationEvents = Get-EventLog <#-ComputerName $computer#> -LogName Application -EntryType Error,Warning -After (Get-Date).AddDays(-1)

        foreach ($item in $c) {
       $d = $appevents_raw | where -Property "InstanceID" -EQ "$item" | select -First 1
       $appevents_array += $d
       }

       foreach ($event in $ApplicationEvents) {
              $row = New-Object -Type PSObject -Property @{
                     TimeGenerated = $event.TimeGenerated
                     EntryType = $event.EntryType
                     Source = $event.Source
                     Message = $event.Message
              }
              $ApplicationEventsReport += $row
       }
               # $ApplicationEvents | %{$_.Message} | select -Unique             

       $ApplicationEventsReport = $appevents_array <#| %{$_.Message} | select -Unique #>| ConvertTo-Html -Fragment
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
       <p><h2>$env:computername Daily System Report - DSR</p></h2>
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
       
       <h3>Events Report - The last $EventNum System/Application Log Events that were Warnings or Errors</h3>
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