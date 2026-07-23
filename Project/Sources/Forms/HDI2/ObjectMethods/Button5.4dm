var $printSettings : Blob
var $error : Integer
var $Main : Pointer

If (Is macOS)
	$Main:=->[PARAMETERS:3]PrintSettingsMAC:2
Else 
	$Main:=->[PARAMETERS:3]PrintSettingsWIN:3
End if 

$printSettings:=$Main->

If (Shift down:C543)
	$error:=BLOB to print settings:C1434($printSettings; 1)  // resets the number of copies to "1" and range to "all"
Else 
	$error:=BLOB to print settings:C1434($printSettings)
End if 

If ($error=1)
	
	// everything is OK  ;o)
	ALERT:C41(Localized string:C991("Print settings have been reloaded!"))
	
Else 
	
	Case of 
		: ($error=2)
			ALERT:C41(Localized string:C991("Printer has been changed"))
			
		: ($error=0)
			ALERT:C41(Localized string:C991("There is no current printer!"))
			
		: ($error=-1)
			ALERT:C41(Localized string:C991("The settings are damaged"))  // this blob is damaged or does not contain print settings
			
	End case 
	
	PRINT SETTINGS:C106
	
End if 
