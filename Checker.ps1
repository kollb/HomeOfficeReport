$ProcessName = "CDViewer"
$day = Get-Date -format dddd
$dateOutput = Get-Date -Format "dddd dd/MM/yyyy HH:mm"
$file=".\log.txt"

# Prüfen ob ein Programm ausgeführt wird
function Check()
{$CheckProcess = ""
$CheckProcess = Get-Process | Where-Object {$_.ProcessName -eq $ProcessName}
If(isWorkDay){
	If($CheckProcess -eq $null){
		Write-Host "Prozess wird aktuell NICHT ausgeführt"
		$var = hasWrittenToday
		If(hasWrittenToday){
			Break
		} 
		else
			{
				Add-Content -path $file -value $dateOutput
			}
		} 
	else 	{
	Write-Host "Prozess wird aktuell ausgeführt"
			}
	}
}

function hasWrittenToday{
	$out = Get-Content $file | select -Last 1
	If($out){
			$dateInFile = [datetime]::ParseExact($out,'dddd dd/MM/yyyy HH:mm',$null)
			If($dateInFile -lt 9 -or $hour -gt 15){
				
				return $false
				} 
				else 
				{
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
	If($day -notcontains ("Samstag" -or "Sonntag")){
		return $true
}else {
	return $false
	}
}

fileExists
Check
