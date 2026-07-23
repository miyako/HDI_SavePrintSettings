C_BLOB:C604($printSettings)
C_LONGINT:C283($err)
C_LONGINT:C283($platform)
C_POINTER:C301($Main; $Sub)

$err:=Print settings to BLOB:C1433($printSettings)

_O_PLATFORM PROPERTIES:C365($platform)

Case of 
		
	: ($platform=Mac OS:K25:2)
		
		$Main:=->[PARAMETERS:3]PrintSettingsMAC:2
		$Sub:=->[PARAMETERS:3]PrintSettingsWIN:3
		
	: ($platform=Windows:K25:3)
		
		$Main:=->[PARAMETERS:3]PrintSettingsWIN:3
		$Sub:=->[PARAMETERS:3]PrintSettingsMAC:2
		
End case 

// the main parameters, matching the current platform are memorized (created OR replaced)

ALL RECORDS:C47([PARAMETERS:3])
$Main->:=$printSettings

// if the parameters, matching the OTHER platform have not been set yet
// (better than nothing even if some info may not be readable from the other platform) 

If (BLOB size:C605($Sub->)=0)
	$Sub->:=$printSettings
End if 

SAVE RECORD:C53([PARAMETERS:3])


ALERT:C41(Localized string:C991("Print settings have been saved!"))
