var $printSettings : Blob
var $err : Integer
var $Main; $Sub : Pointer

$err:=Print settings to BLOB:C1433($printSettings)

If (Is macOS)
	
	$Main:=->[PARAMETERS:3]PrintSettingsMAC:2
	$Sub:=->[PARAMETERS:3]PrintSettingsWIN:3
	
Else 
	
	$Main:=->[PARAMETERS:3]PrintSettingsWIN:3
	$Sub:=->[PARAMETERS:3]PrintSettingsMAC:2
	
End if 

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
