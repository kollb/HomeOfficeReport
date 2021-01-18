$ProcessName = 'CDViewer'
$day = Get-Date -format dddd
$dateOutput = Get-Date -Format 'dddd dd/MM/yyyy HH:mm'
$file='.\log.txt'

# Prüfen ob ein Programm ausgeführt wird
function Check()
{$CheckProcess = ""
$CheckProcess = Get-Process | Where-Object {$_.ProcessName -eq $ProcessName}
If(isWorkDay){
	If($CheckProcess -eq $null){
		Write-Host 'Prozess wird aktuell NICHT ausgeführt'
		If(hasWrittenToday){
			Break
		} 
		else
			{
				Add-Content -path $file -value $dateOutput
			}
		} 
	else 	{
	Write-Host 'Prozess wird aktuell ausgeführt'
			}
	}
}

# Prüfen ob heute schon ein valider Eintrag vorgenommen wurde. Wenn 
function hasWrittenToday{
	$out = Get-Content $file | select -Last 1
	# TODO NullString
	If($out){
		$var  = [datetime]::ParseExact($dateOutput,'dddd dd/MM/yyyy HH:mm',$null)
		$dateInFile = [datetime]::ParseExact($out,'dddd dd/MM/yyyy HH:mm',$null)
			If($var.hour -gt 14 -and $var.Day -ne $dateInFile.Day){
					Write-Host 'Return hasWrittenToday #1 false'
					return $false
					} 
					else
					{
					Write-Host 'Return hasWrittenToday True'
					return $true
				}
		}
}


function fileExists(){
	If (Test-Path $file)
	{} else
	{
    out-file $file
	}
}

# Überprüfe ob Werktag
function isWorkDay{
	If($dateOutput.Day -ne ("Samstag" -or "Sonntag")){
		return $true
}else {
	return $false
	}
}

fileExists
Check
