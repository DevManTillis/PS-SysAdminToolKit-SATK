<#
[] Create winrm activation script
[] Create activity log
[] Check if credentials are verified before running the script

#>



$credential = Get-Credential | Out-Null
$computers = cat .\computer_list.txt


foreach ($computer in $computers){

if (Test-Connection -ComputerName $computer -ErrorAction SilentlyContinue){

Write-Host -BackgroundColor Cyan "[PROCESSING] $computer syscheck"
echo " "

New-PSDrive -Name "F" -PSProvider FileSystem -Root "\\$computer\c$" -Credential $credential | Out-Null
mkdir F:\syscheck | Out-Null
Copy-Item .\syscheck_1.2.ps1 F:\syscheck | Out-Null

Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock {cd C:\syscheck\; .\syscheck_1.2.ps1}

Copy-Item F:\syscheck\*.html .\
Remove-Item -Recurse F:\syscheck\

Remove-PSDrive -Name "F"

echo " "
Write-Host -BackgroundColor Green "[SUCCESS] $computer syscheck complete"

}
else {
echo " "
Write-Host -BackgroundColor Red "[ERROR] $computer does not have network connectivity. Please check network connectivity."
}

}