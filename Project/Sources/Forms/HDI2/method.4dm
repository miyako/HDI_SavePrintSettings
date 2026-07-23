Case of 
	: (Form event code:C388=On Load:K2:1)
		
		If (Get menu bar reference:C979="")
			SET MENU BAR:C67(1)
		End if 
		
		DISABLE MENU ITEM:C150(Get menu bar reference:C979; 1; Current process:C322)
		
		If (Records in table:C83([PARAMETERS:3])<1)
			CREATE RECORD:C68([PARAMETERS:3])
			SAVE RECORD:C53([PARAMETERS:3])
		End if 
		
		ALL RECORDS:C47([PARAMETERS:3])
		
	: (Form event code:C388=On Unload:K2:2)
		
		ENABLE MENU ITEM:C149(Get menu bar reference:C979; 1; Current process:C322)
		
End case 