function api_list( oDom )	

	do case		
		
		case oDom:GetProc() == 'load'		; DoTable( oDom )

		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase	

retu oDom:Send()	

// ----------------------------------------------------------------------- //

static function DoTable( oDom )

	local aColumns := {}
	local aRows    := {}
	

	Aadd( aColumns,  { 'title' => "Date", 'field'  => "date" } )
	Aadd( aColumns,  { 'title' => "Alias", 'field'  => "alias" } )
	Aadd( aColumns,  { 'title' => "Note", 'field'  => "note" } )

	use ( 'data\notes.dbf' ) shared new via 'DBFCDX'
	
	DbGoTop()
	
	while ! eof()
	
		Aadd( aRows, { 'date' => field->date, 'alias' => field->alias, 'note' => field->note } )
	
		dbskip()
	end
	
	oDom:SetAlert( 'Do list ready...' )		

	oDom:TableInit( 'brw', aColumns, aRows )
	

retu nil

// ----------------------------------------------------------------------- //