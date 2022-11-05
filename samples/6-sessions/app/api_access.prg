function api_access( oDom )

	do case
		
		case oDom:GetProc() == 'login'			; Login( oDom )		

		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase	

retu oDom:Send()	


static function Login( oDom, oServer )
	
	local cUser 	:= oDom:Get( 'user' )
	local cPsw 	:= oDom:Get( 'psw' )

	if empty( cUser ) .or. empty( cPsw )
		oDom:SetAlert( 'Enter data' )
		retu nil
	endif
	
	if lower( cUser ) == 'demo' .and. cPsw == '1234'
	
		USessionStart( 'SO' )
		USession( 'user', cUser )
		USession( 'name', 'Mr. ' + cUser )
		USession( 'psw', cPsw )
		USession( 'in', time() )
		
		
		oDom:SetUrl( 'menu' )
		
	else 
		oDom:SetAlert( 'Wrong credentials. Try again' )
		retu nil
	endif
	

retu nil

function logout()

	if ! USessionReady( 'SO' )				
		URedirect( 'login' )
		retu nil	
	endif
	
	USessionEnd()
	
	URedirect( '/' )
	
retu nil 

