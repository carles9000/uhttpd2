static nIndex  := 100

function api_DbfEdit( oDom, oServer )	

	do case
	
		case oDom:GetProc() == 'tables'			; oDom:SetScreen( 'dirtables', '_dialog', nil, 'Tables Directory' )					
		case oDom:GetProc() == 'tablesdir'		; TablesDir( oDom )
		case oDom:GetProc() == 'tableselect'	; TableSelect( oDom )
		
		case oDom:GetProc() == 'dbu_init'		; Dbu_Init( oDom )
		case oDom:GetProc() == 'top'			; Dbu_Top( oDom )
		case oDom:GetProc() == 'prev'			; Dbu_Prev( oDom )
		case oDom:GetProc() == 'next'			; Dbu_Next( oDom, oServer )
		case oDom:GetProc() == 'end'			; Dbu_End( oDom )
		case oDom:GetProc() == 'refresh'		; Dbu_Top( oDom )
		case oDom:GetProc() == 'update'			; Dbu_Update( oDom )
		case oDom:GetProc() == 'ins'			; Dbu_Insert( oDom )
		case oDom:GetProc() == 'del'			; Dbu_Delete( oDom )
		case oDom:GetProc() == 'info'			; Dbu_Info( oDom, oServer )
		case oDom:GetProc() == 'close'			; Dbu_Close( oDom )

		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase	

retu oDom:Send()	


static function TablesDir( oDom )

	local aDir 		:= Directory( AppPathData() + '/*.dbf' )
	local nLen 		:= len( aDir )
	local aColumns := {}
	local aData 	:= {}
	local aConfig	:= {}
	local n
	
	Aadd( aColumns,  { 'formatter' => "rowSelection", "titleFormatter" => "rowSelection", "align" => "center", "headerSort" => .f., "width" => 20 } )
	Aadd( aColumns,  { 'title' => "File", 'field'  => "file" , 'width' => 150 } )
	Aadd( aColumns,  { 'title' => "Size (Bytes)", 'field'  => "size", "hozAlign" => "center" } )

		
	for n := 1 to nLen 
		Aadd( aData, { 'file' => aDir[n][1], 'size' => aDir[n][2] } )
	next

	//aConfig := { 'selectable' => .t. }
	
	aConfig := { 'selectable' => 1, 'selectableRollingSelection' => .T. }
	
	oDom:TableInit( 'tables', aColumns, aData, aConfig )		

retu nil

function TableSelect( oDom )	
	
	local hStr 			:= oDom:Get( 'tables' )
	local aSelected		:= hStr[ 'selected' ]
	local nLen 			:= len( aSelected )
	local cFile, cPathFile, o


	if nLen != 1 
		oDom:SetAlert( 'Select 1 table' )
		retu nil
	endif	


	cFile 		:= aSelected[1][ 'file' ]


	cPathFile 	:= AppPathData() + cFile	

	

	if !file( cPathFile )
		oDom:SetAlert( "File doesn't exist: " + cPathFile )
		return nil
	endif 

	
	USessionStart( "DBU" )	
	USession( "dbu_table", cFile )	

	oDom:DialogClose()

	oDom:SetScreen( 'dbu', '_container', 'panel' )


retu nil 

static function Dbu_Init( oDom )

	local aColumns := {}
	local aRows		:= {}
	local aData 	:= {}
	local aConfig 	:= {}
	local nRows 	:= Val( oDom:Get( 'pages' ) )
	local cFile, cPathFile, cAlias, aStr, nRecno, cInfo, hPerformance	

	
	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )		
		oDom:SetScreen( 'dbfselect', '_dialog' )
		retu nil	
	endif
	
	cFile := USession( "dbu_table" ) 


	
	//	Check file...
	
	cPathFile 	:= AppPathData() + cFile	
	
	if !file( cPathFile )
		oDom:SetAlert( "File doesn't exist...: " + cPathFile )
		return nil
	endif 
	
	//	Open Dbf
	
		cAlias := OpenDbf( cFile )

	//		
	//	Recover Info 
	
		aStr := (cAlias)->( DbStruct() )

		
		USession( "dbu_str", aStr )
		
		
	//	Build Header Browse
	
		aColumns := Str2Header( cAlias, aStr )
	
	
	//	Load row data...
	
		aRows 	:= GetRows( cAlias, 1, nRows )
		cInfo 	:= InfoPag( cAlias, 1, nRows )	
	
		
	//	Save state
		
		nRecno 	:= (cAlias)->( recno() )
	
		USession("recno_top", 1  )
		USession("recno_bottom", nRecno )	
		
	//	Prepare output...
	
		hPerformance := { 	'type' => 'direct',;
							'id' => 'panel_brw',;
							'id_key' => '_recno',;
							'api' => 'api_dbfedit',;
							'proc' => 'update',;
							'file' => cFile }
							
		aConfig := { 'selectable' => .t. }

		oDom:TableInit( 'panel_brw', aColumns, aRows, aConfig, hPerformance )
		oDom:Set( 'info', cInfo )		

retu nil 


static function Dbu_Top( oDom )

	local cAlias 
	local aRows , aHeader, nPos, cHtml, nREcno, cInfo, cFile
	local nRows := Val( oDom:Get( 'pages' ) )		

	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )		
		oDom:SetScreen( 'dbfselect', '_dialog' )
		retu nil	
	endif
	
	cFile := USession( "dbu_table" ) 

	cAlias := OpenDbf( cFile )	
	
	
	cInfo 	:= InfoPag( cAlias, 1, nRows )	


	aRows  	:= GetRows( cAlias, 1, nRows ) 
	
	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", 1  )
	USession("recno_bottom", nRecno )		
	
	oDom:TableReset( 'panel_brw' )
	oDom:TableData( 'panel_brw', aRows )
	oDom:Set( 'info', cInfo )	
	
	
retu nil

static function Dbu_Prev( oDom )


	local cAlias 
	local aRows , aHeader, nPos, cHtml, nRecno, cInfo,  cFile
	local nRows := Val( oDom:Get( 'pages' ) )

	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )		
		oDom:SetScreen( 'dbfselect', '_dialog' )
		retu nil	
	endif
	
	cFile := USession( "dbu_table" ) 

	cAlias := OpenDbf( cFile )
	
	
	nPos := if( USession( 'recno_top' ) == nil, 1, USession( 'recno_top' ) )
	
	
	nPos := if( nPos - nRows < 1, 1, nPos - nRows )
	
	cInfo 	:= InfoPag( cAlias, nPos, nRows )	

	aRows  	:= GetRows( cAlias, nPos, nRows ) 


	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", nPos  )
	USession("recno_bottom", nRecno )
	
	
	oDom:TableReset( 'panel_brw' )
	oDom:TableData( 'panel_brw', aRows )	
	oDom:Set( 'info', cInfo )	
	
	

retu nil 

static function Dbu_Next( oDom, oServer )

	local cAlias 
	local aRows , aHeader, nPos, cHtml, nRecno, cInfo, cFile
	local nRows := Val( oDom:Get( 'pages' ) )
		
	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )		
		oDom:SetScreen( 'dbfselect', '_dialog' )
		retu nil	
	endif

	
	cFile 	:= USession( "dbu_table" ) 	

	cAlias 	:= OpenDbf( cFile )	
	
	nPos := if( USession( 'recno_bottom' ) == nil, 1, USession( 'recno_bottom' ) )

	//aHeader	:= GetHeader()
	aRows  	:= GetRows( cAlias, nPos, nRows ) 
	
	cInfo 	:= InfoPag( cAlias, nPos, nRows )				
	
	
	if len (aRows ) == 0
		Dbu_End( oDom )
		retu nil
	endif 
	
	

	//cHtml 	:= DoTable( aHeader, aRows )

	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", nPos )
	USession("recno_bottom", nRecno )
	

	
	oDom:TableReset( 'panel_brw' )
	oDom:TableData( 'panel_brw', aRows )
	
	oDom:Set( 'info', cInfo )	

	
retu nil 

static function Dbu_End( oDom )

	local cAlias 
	local aRows , aHeader, nPos, cHtml, nRecno, cInfo, cFile
	local nTotalPag
	local nRows := Val( oDom:Get( 'pages' ) )

	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )		
		oDom:SetScreen( 'dbfselect', '_dialog' )
		retu nil	
	endif
	
	cFile := USession( "dbu_table" ) 

	cAlias := OpenDbf( cFile )	
	
	(cAlias)->( dbgobottom() )
	
	nTotalPag := Int( (cAlias)->( RecCount() ) / nRows ) + 1 
	
	nPos 	:= ( (nTotalPag - 1 ) * nRows ) + 1 
	

	cInfo 	:= InfoPag( cAlias, nPos, nRows )		
	aRows  	:= GetRows( cAlias, nPos, nRows ) 


	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", nPos  )
	USession("recno_bottom", nRecno )	
	
	oDom:TableReset( 'panel_brw' )
	oDom:TableData( 'panel_brw', aRows )
	
	oDom:Set( 'info', cInfo )

retu nil


static function Dbu_Update( oDom )

	local cAlias 
	local cFile 	:= oDom:Get( 'file'  ) 
	local nRecno 	:= oDom:Get( '_recno'  ) 
	local cField 	:= oDom:Get( 'field'  ) 
	local uValue 	:= oDom:Get( 'value'  ) 
	local lOK  	  	:= .F.
	local cMsg 	  	:= ''
	local nPos, aStr, nField		

	
	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )		
		oDom:SetScreen( 'dbfselect', '_dialog' )		
		retu nil	
	endif

	
	cAlias := OpenDbf( cFile )	
	
	aStr := USession( "dbu_str" ) 		// aStr := (cAlias)->( DbStruct() )
	
	nField := Ascan( aStr, {|a| a[ 1 ] == cField } )
	
	if nField == 0 
		oDom:SetAlert( 'Field not exist: ' + cField )
		retu nil	
	endif
	
	if valtype( uValue ) != aStr[nField][2]

	
		do case
			case aStr[nField][2] == 'D' ; uValue := CToD( uValue )
			case aStr[nField][2] == 'M' ; uValue := Alltrim( uValue )
			otherwise
				oDom:SetAlert( 'Type field error: ' + cField + ' => ' + valtype( uValue ) )
				retu nil	
		endcase
	endif

	if valtype( uValue ) == 'C' .and. uValue == 'x'
		oDom:SetData( { 'updated' => .f., 'msg' => 'Error value ' + cField } )
		retu nil
	endif
	
	
	nPos := (cAlias)->( FieldPos( cField ) )

	(cAlias)->( DbGoTo( nRecno ) )

	if (cAlias)->( DbRLock() )
	
		(cAlias)->( FieldPut( nPos, uValue ) ) 
		(cAlias)->( DbUnlock() )		
		
		lOk := .t.
		
	else
	
		cMsg := 'Lock error...'	
	
	endif

	
	oDom:SetData( { 'updated' => lOk , 'msg' => cMsg} )
	

retu nil


static function Dbu_Insert( oDom )

	local cAlias, cInfo, cFile 
	
	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )	
		oDom:SetData( { 'updated' => .f. , 'msg' => 'Session KO. Que fem ?' } )		
		retu nil	
	endif
	
	cFile := USession( "dbu_table" ) 

	cAlias := OpenDbf( cFile )	
	
	(cAlias)->( DbAppend() )
	
	Dbu_End( oDom )
		
retu nil


static function Dbu_Delete( oDom )

	local cAlias, cInfo, cFile
	local hStr 			:= oDom:Get( 'panel_brw' )
	local aSelected	:= hStr[ 'selected' ]
	local nRows := Val( oDom:Get( 'pages' ) )
	local n, nPos, aRows, nRecno
	
	if Len( aSelected ) == 0
		retu nil
	endif
	
	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )	
		oDom:SetData( { 'updated' => .f. , 'msg' => 'Session KO. Que fem ?' } )		
		retu nil	
	endif
	
	cFile := USession( "dbu_table" ) 

	cAlias := OpenDbf( cFile )	
	
	for n := 1 to len( aSelected )
	
		(cAlias)->( DbGoto(  aSelected[n][ '_recno' ] ) )
		
		if (cAlias)->( Rlock() )
			if (cAlias)->( Deleted() )
				(cAlias)->( DbRecall() )
			else
				(cAlias)->( DbDelete() )
			endif
			
			(cAlias)->( DbUnlock() )
		endif
	
	next 
	
	nPos 	:= if( USession( 'recno_top' ) == nil, 1, USession( 'recno_top' ) )
	
	cInfo 	:= InfoPag( cAlias, nPos, nRows )		
	aRows  	:= GetRows( cAlias, nPos, nRows )
	
	
	
	nRecno 	:= (cAlias)->( recno() )
	
	
	
	USession("recno_top", nPos  )
	USession("recno_bottom", nRecno )
	
	
	oDom:TableReset( 'panel_brw' )
	oDom:TableData( 'panel_brw', aRows )	
	oDom:Set( 'info', cInfo )
	
	
	oDom:SetData( { 'sel' => aSelected })
	
	//Dbu_End( oDom )
		
retu nil


static function Dbu_Info( oDom, oServer )

	local cHtml	:= ''
	local cAlias 
	local cFile
	local nDel
	local aDir
	
	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )	
		oDom:SetAlert( 'Session Out - Redirect a Select DBF ?' )		
		retu nil	
	endif
	
	cFile := USession( "dbu_table" ) 
	
	if !file ( AppPathData() + cFile  )
		oDom:SetAlert( "File dont exist: " + AppPathData() + cFile )
		retu nil
	endif
	
	
	aDir := Directory( AppPathData() + cFile )
	
	cAlias := OpenDbf( cFile )	
	
	COUNT TO nDel FOR Deleted()	
	
	cHtml	+= '<style>#dbu_info td {padding:5px}</style>'
	cHtml	+= '<h3 style="text-align:center;"><b>Table Information</b></h3>'
	
	cHtml	+= '<table id="dbu_info" border="1" width="100%">'
	cHtml 	+= '<tr style="background-color: gray;color: white;font-weight: bold;"><td>Info</td><td>Value</td></tr>'
	

	cHtml += '<tr><td>Data path</td><td>' + AppPathData()  + '</td></tr>'
	cHtml += '<tr><td>File</td><td>' + USession( "dbu_table" )  + '</td></tr>'
	cHtml += '<tr><td>Size</td><td>' + str(aDir[1][2])  + ' Kb.</td></tr>'
	cHtml += '<tr><td>Rdd name</td><td>' + (cAlias)->( RddName() )  + '</td></tr>'
	cHtml += '<tr><td>Registers</td><td>' + str((cAlias)->(RecCount() ))  + '</td></tr>'
	cHtml += '<tr><td>Deleted</td><td>' + str(nDel)  + '</td></tr>'
	
	cHtml += '</table>'		
		
		
	oDom:SetDialog(  'ID_DBU', cHtml, 'Information' )		

retu nil 


static function Dbu_Close( oDom )


	if ! USessionStart(  'DBU' )
		oDom:SetScreen( 'dbfselect', '_dialog' )
		retu nil	
	endif
	
	USessionEnd()	
	
	oDom:SetScreen( nil, '_container', 'panel', '' )		
	
	
retu nil

static function OpenDbf( cFile )

	static n := 1

	local cPathFile 	:= AppPathData() + cFile	
	local cAlias 		:= 'ALIAS' + ltrim(str(++n))

	use ( cPathFile ) shared new alias (cAlias) VIA 'DBFCDX' 
	cAlias := alias()

retu cAlias

static function Str2Header( cAlias, aStr )

	local aCols := {}
	local nLen 		:= len( aStr )
	local n, cType, cEditor, cFormatter, cAlign, aValidator, hEditorParams
	local hDel := {=>}
	
	
	hDel := { 'height' => '16', 'width' => '16', 'yes' => 'files/images/trash.png' }


	Aadd( aCols, { 'formatter' => "rowSelection", "titleFormatter" => "rowSelection", "align" => "center", "headerSort" => .f., "width" => 20 } )
	Aadd( aCols, { 'title' => 'Recno',	'field' => '_recno'	, 'hozAlign' => 'center' })		
	Aadd( aCols, { 'title' => 'Del',	'field' => '_del'	, 'hozAlign' => 'center', 'formatter' => "UFormatLogic", 'formatterParams' => hDel })	
		
		//http://tabulator.info/docs/5.3/validate#func-custom 
		
	for n := 1 to nLen 
	
		cType := aStr[n][2]
		
		
		//hozAlign:"center", editor:true, formatter:"tickCross"
		cFormatter 	:= nil
		cEditor 	:= nil
		cAlign 		:= nil
		aValidator  := nil
		hEditorParams := nil 

		
		//aValidator[1] := { 'type' => 'noDivide', 'parameters' => { 'dummy' => 1 } } 
		
		
		
		do case
			case cType == 'C' ;	cEditor := 'input'
			
			case cType == 'N' 
				cEditor 	:= 'number'
				cAlign 		:= "center"
				
			case cType == 'D' 
				cEditor 		:= 'input'
				heditorParams 	:= { 'mask' => "99/99/9999",;
									 'inputFormat' => "DD/MM/YYYY";
									}				
				cFormatter		:= 'UFormatDate'
				cAlign 			:= "center"								

			case cType == 'L' 
				cEditor 	:= .T. 
				cFormatter 	:= "tickCross"
				cAlign 		:= "center"
				
			case cType == 'M' ;	cEditor := 'textarea'
		endcase
	
		Aadd( aCols, { 'title' => upper( aStr[n][1] ),;
						'field' => aStr[n][1] ,;
						'editor' => cEditor ,;
						'formatter' => cFormatter ,;
						'hozAlign' => cAlign ,;
						'validator' => aValidator,;
						'editorParams' => hEditorParams;
					})	
	next 
	
retu aCols

static function GetRows( cAlias, nRecno, nTotal )

	local aRows := {}
	local aReg 
	local n 	:= 0
	local aStr  
	local nFields
	//local nFields := (cAlias)->( FCount() )
	local j
	



	

	aStr  	:= USession( "dbu_str" )


	
	nFields	:= len( aStr )	
	
	(cAlias)->( DbGoto( nRecno ) )	
	
		while n < nTotal .and. (cAlias)->( !eof() ) 

				
			aReg := {=>}
			
			HB_HSet( aReg, '_recno' 	, (cAlias)->( Recno() ) )
			HB_HSet( aReg, '_del' 		, (cAlias)->( Deleted() ) )
			
			for j := 1 to nFields

				do case
					case aStr[j][2] == 'D'							
						HB_HSet( aReg, (cAlias)->( FieldName( j ) ), DTOC( (cAlias)->( FieldGet( j ) ) ) ) 
					otherwise				
						HB_HSet( aReg, (cAlias)->( FieldName( j ) ), (cAlias)->( FieldGet( j ) ) ) 
				endcase
			
			next
			
			Aadd( aRows, aReg ) 
		
			(cAlias)->( DbSkip() )
			n++
		end 			
	
retu aRows 


static function InfoPag( cAlias, nPos, nRows )

	
	local cInfo 		:= 'Pag. '
	local nTotal_Page 	:= Int( (cAlias)->( RecCount() ) / nRows ) + 1
	local nPage 		:= Int( nPos / nRows ) + 1 	
	
retu 'Pag. ' + ltrim(str( nPage ))	 + '/' + ltrim(str(nTotal_Page))

