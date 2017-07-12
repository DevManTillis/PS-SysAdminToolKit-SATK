<#

# replace everything between the script tags

$s = (Get-Content $data.FullName -Encoding UTF8)
$regex = [regex] '(?<=\<script\>).+(?=\</script\>)'
$s = $regex.replace($s, '${1}')
$s


# replace everything before the backslash

 %{$_ -replace "^[^\\]*\\",""}


#replace entire line that contains --

| %{$_ -replace "\-\-.*$",""}


# .trim() remove empty lines

|? {$_.trim() -ne "" }


 #>
