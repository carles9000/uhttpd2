function api_table( oDom )	

	do case		
		
		case oDom:GetProc() == 'load_dat'	; DoLoad( oDom )

		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase	

retu oDom:Send()

static function DoLoad( oDom )
	
	local aRows    := {}

	use ( 'data\test.dbf' ) shared new via 'DBFCDX'
	
	DbGoTop()
	
	while ! eof()
	
		if field->age > 90	
			Aadd( aRows, { 'first' => field->first, 'last' => field->last, 'age' => field->age } )		
		endif
	
		dbskip()
	end

	oDom:SetJs( 'MyLoad', aRows )
	
retu nil