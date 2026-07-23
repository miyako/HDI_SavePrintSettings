//the button already has "accept" standard action
If (FORM Event.code=On Clicked)
	
	If (Form.quit)
		INVOKE ACTION(ak return to design mode)
	Else 
		
		var $window : Integer
		$window:=Open form window("HDI2"; Plain form window; Horizontally centered; Vertically centered)
		SET WINDOW TITLE(Get window title(Current form window); $window)
		DIALOG("HDI2"; Form; *)
		
	End if 
	
End if 
