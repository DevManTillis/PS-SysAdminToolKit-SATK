$CabUpdateFiles = gci -Recurse -Path .\download\* -Filter *.cab | select FullName -ExpandProperty FullName
$ExeUpdateFiles = gci -Recurse -Path .\download\* -Filter *.exe | select FullName -ExpandProperty FullName

foreach ($item in $CabUpdateFiles) {
dism /online /add-package /NoRestart /packagepath:$item
}

foreach ($item in $ExeUpdateFiles) {
dism /online /add-package /NoRestart /packagepath:$item
}