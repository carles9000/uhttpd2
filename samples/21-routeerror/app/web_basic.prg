function web_basic( oDom )

	do case
		case oDom:GetProc() == 'exe_search' 	; Search( oDom )						
		case oDom:GetProc() == 'exe_clean' 	; oDom:Set( 'info', '' )		
				
		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase
	

retu oDom:Send()	

static function Search( oDom )

	local cSearch 	:= Val( oDom:Get( 'register' ) )
	local cInfo	:= ''
	
	USE ( 'data\test.dbf' ) shared new 
	
	DbGoto( cSearch )
	
		cInfo := field->first + '<br>' + field->last + '<br>' + field->street 

	oDom:Set( 'info', cInfo )
		
	
retu nil 
