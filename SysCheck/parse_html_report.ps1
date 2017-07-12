$data = gci -Filter "*.html" -Path .\
function writedata {
$s = (Get-Content $data.FullName -Encoding UTF8)
$regex = [regex] '(?<=\<script\>).+(?=\</script\>)'
$s = $regex.replace($s, '${1}')
$s`
| %{$_ -replace '<hr noshade size=3 width="100%">',''}`
| %{$_ -replace 'DSR</p></h2>','DSR</h2></p>'}`
| %{$_ -replace '<br>',''}`
| %{$_ -replace '<br></br>',''}`
| %{$_ -replace '</br>',''}`
| %{$_ -replace '(?<=\<script\>).+(?=\</script\>)',''}
} 

writedata | Out-File .\file.html -Encoding utf8


[xml]$Content = Get-Content .\file.html

$Content.HTML
$body = $Content.HTML | %{$_.'body'} | %{$_.'div'}

$date = $body | %{$_.'b'}



<# PULL OUT DATA

- DATE
- 

#>
