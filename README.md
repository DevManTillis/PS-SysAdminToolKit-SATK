# PowerShell-SysAdminTools
PowerShell System Administration Tools

## SysCheck
This program within the SysAdminToolkit gives system administrators the capability to grab all necessary data about the health of thier systems. This script can be ran in an enterprise environment due the the capability to run SysCheck scans on remote windows hosts. The report for each remote host is extracted and placed on the host that initiated the script in the SysCheck directory.

#### Usage
syscheck_2.0.ps1


## OfflineUpdate
This program is useful for updating machines that are on a segrated network of which may not have access to WSUS or an internet connection. 

####  Usage
1. Run updates on reference machine.
2. Copy updates to .\download directory in same directory as OfflineUpdate.ps1.
3. Run OfflineUpdate.ps1 on the machine that is on the segregated network.

## IsoMaker


####  Usage
New-IsoFile -source .\sourcedirectory -path .\destinationdirectory.iso

## List_Installed_Programs
This description of this program is essentially in the name. Use this in order to efficiently get a list of installed programs. This is vary useful when coupled with winrm in an enterprise environemnt.
