function web_basic( oDom )

do case
	case oDom:GetProc() == 'info'; DoInfo( oDom )
	
	otherwise 				
		oDom:SetError( "Proc don't defined => " + oDom:GetProc())
endcase
	
retu oDom:Send()	

// -------------------------------------------------- //

function DoInfo( oDom )

	local cInfo := '<b>Dummy:</b> ' + oDom:Get( 'dummy' )
	
	cInfo += '<br><b>Register</b> ' + oDom:Get( 'register' )

	oDom:Set( 'info', cInfo )
	
	//	Y de paso, actualizo la hidden 
	
	oDom:Set( 'dummy', 'Osvaldo' )

retu nil 

// -------------------------------------------------- //
