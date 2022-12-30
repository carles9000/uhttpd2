static nIndex  := 100

function api_DbfBuilder( oDom )

	do case
		case oDom:GetProc() == 'add' 			; Add( oDom )						
		case oDom:GetProc() == 'del' 			; Del( oDom )						
		case oDom:GetProc() == 'create'		; CreateDbf( oDom )						
		case oDom:GetProc() == 'changetype' 	; ChangeType( oDom )
		
		case oDom:GetProc() == 'tables'		; oDom:SetScreen( 'dirtables', '_dialog', nil, 'Tables Directory' )					
		case oDom:GetProc() == 'tablesdir'		; TablesDir( oDom )
		case oDom:GetProc() == 'inittable' 	; InitTable( oDom )

		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase	

retu oDom:Send()	

//	------------------------------------------------------------------- //

static function InitTable( oDom )

	local hConfig	:= {}
	local aColumns := {}
	local aData 	:= {}	
	local aItems 	:= { 'values' => { "C" => "Character", 'N' => "Numeric", "L" => "Logic", "D" => "Date", "M" => "Memo"} }
			
	Aadd( aColumns,  { 'formatter' => "rowSelection",  "align" => "center", "headerSort" => .f., "width" => 20 } )
	Aadd( aColumns,  { 'title' => "Field", 'field'  => "field", 'editor' => "input", 'width' => 100 } )
	Aadd( aColumns,  { 'title' => "Type", 'field'  => "type", "hozAlign" => "center", 'width' => 85, 'editor' => "list", 'editorParams' => aItems } )
	Aadd( aColumns,  { 'title' => "Len", 'field'  => "len", "hozAlign" => "center", 'editor' => "number" } )
	Aadd( aColumns,  { 'title' => "Dec", 'field'  => "dec", "hozAlign" => "center", 'editor' => "number" } )

	
	
	hConfig := { ;
			'columns' => aColumns, ;
			'data' => aData,;
			'selectable' => .t.;
		}			
	
	oDom:TableInit( 'structure', hConfig )	
	
retu nil

//	------------------------------------------------------------------- //

static function Add( oDom )

	local hInfo 	:= {=>}
	local aRows 	:= {}
	local cType    := ''
	local hStr, hData, nPos

	//	Recover data info 
	
		hInfo[ 'field' ] 	:= lower( oDom:Get( 'field' ) )
		hInfo[ 'type' ] 	:= oDom:Get( 'type' ) 
		hInfo[ 'len' ] 		:= Val( oDom:Get( 'len' ) )
		hInfo[ 'dec' ] 		:= Val( oDom:Get( 'dec' ) )
	
		//	TGrid Data
	
		hStr 				:= oDom:Get( 'structure' )
		hData 				:= hStr[ 'data' ]
		
	//	Validating info 
	
		if empty( hInfo[ 'field' ] )
			oDom:SetAlert( 'Field: Empty field' )
			oDom:Focus( 'field' )
			retu nil
		endif
		
		if hInfo[ 'len' ] <= 0
			oDom:SetAlert( 'Len: Value must be > 0' )
			oDom:Focus( 'len' )
			retu nil
		endif	
		
		if hInfo[ 'dec' ] < 0 .or.  hInfo[ 'dec' ] > 4
			oDom:SetAlert( 'Dec: Len must between [0..4]' )
			oDom:Focus( 'dec' )
			retu nil
		endif			

		//	Grid...
		
		nPos := HB_HScan( hData, {|key,value,pos| value['field'] == hInfo[ 'field' ] } )
		
		if nPos > 0
			oDom:SetAlert( 'Field was repeat in row ' + ltrim(str(nPos)) )
			oDom:Focus( 'field' )
			retu nil
		endif							

	
	//	Finally we can send comands to dom...		
		
		nIndex++
								
		Aadd( aRows, {  'id' => nIndex ,;
						'field' => hInfo[ 'field' ] ,;
						'type' => hInfo[ 'type' ] ,;
						'len' => ltrim(str(hInfo[ 'len' ])) ,;
						'dec' => ltrim(str(hInfo[ 'dec' ])) ;
					})
		
		oDom:TableData( 'structure', aRows )		
	
retu nil 

//	------------------------------------------------------------------- //

static function Del( oDom )

	local hStr	:= oDom:Get( 'structure' )
	local hRow	:= hStr[ 'selected' ]
		
	if len( hRow) == 1	
		oDom:SetTable( 'structure', 'deleteRow', { 'ids' => hRow[1][ 'id' ] }, 'Delete row?' )				
	endif		
	
retu nil 

//	------------------------------------------------------------------- //

static function ChangeType( oDom )
		
	local cType := oDom:Get( 'type' ) 	
	
	do case
		case cType == 'L'
			oDom:Set( 'len', '1' )
			oDom:Set( 'dec', '0' )
			oDom:Disable( 'len' )
			oDom:Disable( 'dec' )
			
		case cType == 'D'
			oDom:Set( 'len', '8' )
			oDom:Set( 'dec', '0' )
			oDom:Disable( 'len' )
			oDom:Disable( 'dec' )
			
		case cType == 'M'
			oDom:Set( 'len', '10' )
			oDom:Set( 'dec', '0' )
			oDom:Disable( 'len' )
			oDom:Disable( 'dec' )
			
		otherwise
			oDom:Enable( 'len' )
			oDom:Enable( 'dec' )
	endcase

retu nil 

//	------------------------------------------------------------------- //

static function CreateDbf( oDom )

	local hStr, hData, nPos, cFile, hField
	local cPath, cPathFile, n, nLen, nDec
	local aStructure := {}
	
	//	Recover data info 
	
		cFile 			:= oDom:Get( 'file' ) 
	
		//	TGrid Data
	
		hStr 			:= oDom:Get( 'structure' )
		hData 			:= hStr[ 'data' ]
		
	//	Verify data
	
		if empty( cFile )
			oDom:SetAlert( 'Empty file' )
			oDom:Focus( 'file' )
			retu nil
		endif
		
		if len( hData ) == 0
			oDom:SetAlert( 'Structure is empty' )
			oDom:Focus( 'field' )
			retu nil
		endif		
		
		if at( '.', cFile ) > 0
			oDom:SetAlert( 'File extension not allowed' )
			oDom:Focus( 'field' )
			retu nil
		endif	
		
		//	Check Path data 
			
		if ! hb_DirExists( AppPathData() )
			hb_DirBuild( AppPathData() )
		endif
	
		cPathFile := AppPathData() + '/' + cFile + '.dbf'
		
		if file( cPathFile )
			oDom:SetAlert( 'File exist!' )
			oDom:Focus( 'field' )
			retu nil		
		endif 
		
	//	Prepare structure

		for n := 1 to len( hData )
		
			hField := HB_HValueAt( hData, n )
			
			nLen := if( valtype( hField[ 'len' ] ) == 'N', hField[ 'len' ] , Val( hField[ 'len' ]) )
			nDec := if( valtype( hField[ 'dec' ] ) == 'N', hField[ 'dec' ] , Val( hField[ 'dec' ]) )
			
			Aadd( aStructure, { hField[ 'field' ], hField[ 'type' ], nLen, nDec  } )					
		
		next		
		
		dbCreate( cPathFile, aStructure, 'DBFCDX' )				
		
		if file( cPathFile )
		
			oDom:SetAlert( cFile + ' was created !' )
			
			oDom:Set( 'file', '' )
			oDom:Set( 'field', '' )
			oDom:Set( 'type', 'C' )
			oDom:Set( 'len', '10' )
			oDom:Set( 'dec', '0' )	

			oDom:Enable( 'len' )
			oDom:Enable( 'dec' )			
			
			oDom:SetTable( 'structure', 'resetData' )			
			
			oDom:Focus( 'field' )						
			
		else
			oDom:SetAlert( 'Error building file ' + cFile )
		endif

retu nil

//	------------------------------------------------------------------- //

static function TablesDir( oDom )

	local aDir 		:= Directory( AppPathData() + '/*.dbf' )
	local nLen 		:= len( aDir )
	local aColumns := {}
	local aData 	:= {}
	local hConfig 	:= {=>}
	local n
	
	Aadd( aColumns,  { 'title' => "File", 'field'  => "file" } )
	Aadd( aColumns,  { 'title' => "Size", 'field'  => "size", "hozAlign" => "center" } )
	Aadd( aColumns,  { 'title' => "Date", 'field'  => "date" } )
	Aadd( aColumns,  { 'title' => "Time", 'field'  => "time" } )
		
	for n := 1 to nLen 
		Aadd( aData, { 'file' => aDir[n][1], 'size' => aDir[n][2], 'date' => DTOC(aDir[n][3]), 'time' =>  aDir[n][4] } )
	next
	
	hConfig := { ;
			'columns' => aColumns, ;
			'data' => aData;			
		}			
	
	oDom:TableInit( 'tablesdir', hConfig )		

retu nil

//	------------------------------------------------------------------- //