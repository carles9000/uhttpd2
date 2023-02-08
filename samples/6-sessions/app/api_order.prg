function api_order( oDom )


	if ! USessionReady()	
		URedirect( 'login' )	
		retu nil	
	endif

	do case
		
		case oDom:GetProc() == 'search'	; DoSearch( oDom )
		case oDom:GetProc() == 'save'		; DoSave( oDom )
		case oDom:GetProc() == 'clean'		; DoClean( oDom )

		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase	

retu oDom:Send()

function DoSearch( oDom )

	local nId 		:= val(oDom:Get( 'id' ))
	local cInfo	:= ''
	
	use ( 'data\test.dbf' ) shared new via 'DBFCDX'
	
	DbGoto( nId )
	
	if bof()
		oDom:Focus( 'id' )
		oDom:SetAlert( 'Reg not exist' )
		
	else
	
		oDom:Set( 'first', FIELD->first )
		oDom:Set( 'last', FIELD->last )
		oDom:Set( 'street', FIELD->street )
		oDom:Set( 'age', FIELD->age )
		
		oDom:Active( 'id', .f. ) 
		oDom:Active( 'search', .f. ) 		
		
		oDom:Active( 'first', .t. ) 
		oDom:Active( 'last', .t. ) 
		oDom:Active( 'street', .t. ) 
		oDom:Active( 'age', .t. ) 
		oDom:visibility( 'save', .t. ) 
		
	endif			

retu nil	

function DoSave( oDom )

	local nId 		:= val(oDom:Get( 'id' ))
	
	use ( 'data\test.dbf' ) shared new via 'DBFCDX'
	
	DbGoto( nId )
	
	if ( DbRlock() )
	
		field->first	:= oDom:Get( 'first' )
		field->last	:= oDom:Get( 'last' )
		field->street	:= oDom:Get( 'street' )
		field->age		:= Val( oDom:Get( 'age' ) )
	
		DbCommit()
		
		DoClean( oDom )
		oDom:SetAlert( 'Register ' + ltrim(str(nId)) + ' was updated!' )
	
	else	
		oDom:SetAlert( 'Lock. Try again...' )
	endif

retu nil

static function DoClean( oDom )

	oDom:active( 'id', .t. )
	oDom:active( 'search', .t. )
	
	oDom:Set( 'id', '' )
	oDom:Set( 'first', '' )
	oDom:Set( 'last', '' )
	oDom:Set( 'street', '' )
	oDom:Set( 'age', '' )
	
	oDom:active( 'first', .f. )
	oDom:active( 'last', .f. )
	oDom:active( 'street', .f. )
	oDom:active( 'age', .f. )
	oDom:visibility( 'save', .f. ) 
	
	oDom:focus( 'id' )
	
retu nil 