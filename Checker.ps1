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
	$test = Get-Content $file | select -Last 3
	# TODO NullString
	If($out){
		$var  = [datetime]::ParseExact($dateOutput,'dddd dd/MM/yyyy HH:mm',$null)
		$dateInFile = [datetime]::ParseExact($out,'dddd dd/MM/yyyy HH:mm',$null)
		$testDateInFile = @()
		foreach($i in $test){
			$testDateInFile += [datetime]::ParseExact($i,'dddd dd/MM/yyyy HH:mm',$null)
		}
		$temp = 0
		foreach($i in $testDateInFile){
		if($i.Day -eq $var.Day){$temp +=1}
		}
		Write-Host "Temp:"
		Write-Host $temp
		Write-Host "$var.hour -gt 14:"
		$1 =$var.hour -gt 14
		Write-Host $1
		
		if($temp -eq 3){return $true}
		If($var.hour -gt 14){
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
