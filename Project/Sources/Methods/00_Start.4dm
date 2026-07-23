//%attributes = {}
SET MENU BAR:C67(1)

C_TEXT:C284($1)
C_LONGINT:C283($window)

Case of 
	: (Count parameters:C259=0)
		
		CALL WORKER:C1389("HDI"; Current method name:C684; "Title")
		
	Else 
		
		Case of 
			: ($1="Title")
				
				$window:=Open form window:C675("HDI"; \
					Plain form window:K39:10; \
					Horizontally centered:K39:1; Vertically centered:K39:4)
				
				DIALOG:C40("HDI")
				
				If (OK=1)
					CALL WORKER:C1389("HDI"; Current method name:C684; "HDI")
				End if 
				
				CLOSE WINDOW:C154($window)
				
			: ($1="HDI")
				
				$window:=Open form window:C675("HDI2"; \
					Plain form window:K39:10; \
					Horizontally centered:K39:1; Vertically centered:K39:4)
				
				DIALOG:C40("HDI2")
				CLOSE WINDOW:C154($window)
				KILL WORKER:C1390(Current process name:C1392)
				
		End case 
		
End case 