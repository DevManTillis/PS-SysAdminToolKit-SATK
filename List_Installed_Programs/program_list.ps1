$computername=$env:COMPUTERNAME

$UninstallKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"

$reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$computername)

$regkey=$reg.OpenSubKey($UninstallKey)

$subkeys=$regkey.GetSubKeyNames()

$Programs = @()
New-Item -ItemType File -Path .\$env:COMPUTERNAME.txt -Force
foreach($key in $subkeys){

    $thiskey=$UninstallKey+"\\"+$key
    $thisSubKey=$reg.OpenSubKey($thiskey)
    $DisplayName=$thisSubKey.GetValue("DisplayName")
    
    if ($DisplayName -ne $null){
    $Programs += "$computername : $DisplayName"
   #Add-Content .\$env:COMPUTERNAME.txt "$computername : $DisplayName"
    }
} 

for ($i=0; $i -le $Programs.Length; $i++){
$newdata = $Programs[$i] | where {$_ -inotmatch "Update for"} | where {$_ -inotmatch "Service Pack 1 for"}
Add-Content .\$env:computername.txt "$newdata"
}