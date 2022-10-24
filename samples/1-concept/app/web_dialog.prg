function web_dialog( oDom )	

	do case
		case oDom:GetProc() == 'exe_something' 	; Exe_Something( oDom )						
				
		otherwise 				
			oDom:SetError( "Proc don't exist: " + oDom:GetProc() )
	endcase

retu oDom:Send()	

static function Exe_Something( oDom )

	//	Execute my process...

	
	//	Finally we can send comands to dom...
	
		oDom:Set( 'oC1', time() )
		
	
retu nil 
