/*
	Quizas sea este el ejemplo mas completo con un browse en el que podemos experimentar
	los diferentes metodos para controlar el browse que tenemos en el cliente. Entiendo 
	que son los metodos minimos necesarios para tener un buen control. Cualquier otro 
	metodo necesario siempre se podra usar desde javascript, pero... el programador 
	necesitara en este caso conocer bien como funciona el pluggin que usamos aqui, que 
	en esta ocasion es el fantastico pluggin Tabulator 
	
	------------------------------------------------------------------------------------
	
	Perhaps this is the most complete example with a browser in which we can experiment
	the different methods to control the browse that we have in the client. I understand
	which are the minimum methods necessary to have a good control. Any other
	necessary method can always be used from javascript, but... the programmer
	In this case, you will need to know how the plugin we use here works, which
	this time it is the fantastic Tabulator	pluggin
	
	------------------------------------------------------------------------------------
	
	Tabulator -> https://tabulator.info/docs/5.4 	
*/

static nIndex  := 100

function api_DbfEdit( oDom, oServer )	

	do case
	
	//	Select Dbf table...
	
		case oDom:GetProc() == 'tables'		; oDom:SetScreen( 'dirtables', '_dialog', nil, 'Tables Directory' )					
		case oDom:GetProc() == 'tablesdir'		; TablesDir( oDom )
		case oDom:GetProc() == 'tableselect'	; TableSelect( oDom )
		
	//	Process actions from table
		
		case oDom:GetProc() == 'dbu_init'		; Dbu_Init( oDom )
		case oDom:GetProc() == 'top'			; Dbu_Top( oDom )
		case oDom:GetProc() == 'prev'			; Dbu_Prev( oDom )
		case oDom:GetProc() == 'next'			; Dbu_Next( oDom, oServer )
		case oDom:GetProc() == 'end'			; Dbu_End( oDom )
		case oDom:GetProc() == 'refresh'		; Dbu_Top( oDom )
		case oDom:GetProc() == 'update'		; Dbu_Update( oDom )
		case oDom:GetProc() == 'ins'			; Dbu_Insert( oDom )
		case oDom:GetProc() == 'del'			; Dbu_Delete( oDom )
		case oDom:GetProc() == 'info'			; Dbu_Info( oDom, oServer )
		case oDom:GetProc() == 'close'			; Dbu_Close( oDom )

		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase	

retu oDom:Send()	

//	-------------------------------------------------------------------	//

static function TablesDir( oDom )

	local aDir 		:= Directory( AppPathData() + '/*.dbf' )
	local nLen 		:= len( aDir )
	local aColumns 	:= {}
	local aData 		:= {}
	local hConfig		:= {=>}
	local n
	
	Aadd( aColumns,  { 'formatter' => "rowSelection", "align" => "center", "headerSort" => .f., "width" => 20 } )
	Aadd( aColumns,  { 'title' => "File", 'field'  => "file" , 'width' => 150 } )
	Aadd( aColumns,  { 'title' => "Size (Bytes)", 'field'  => "size", "hozAlign" => "center" } )

	for n := 1 to nLen 
		Aadd( aData, { 'file' => aDir[n][1], 'size' => aDir[n][2] } )
	next
	
	//	https://tabulator.info/docs/5.4/options 

	hConfig := { ;
			'columns' => aColumns, ;
			'data' => aData,;
			'selectable' => 1,;
			'selectableRollingSelection' => .T.;
		}			
	
	oDom:TableInit( 'tables', hConfig )		

retu nil

//	-------------------------------------------------------------------	//

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

//	------------------------------------------------------------------- //

static function Dbu_Init( oDom )

	local aColumns := {}
	local aRows		:= {}
	local aData 	:= {}
	local hConfig 	:= {=>}
	local aEvents 	:= {}
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
		
	//	Setup browse 
		
				//'selectableRollingSelection' => .T.,;
				//'selectable' => .t.,;
				//'selectableRangeMode' => "click";	
									
		hConfig := { ;
				'index' => '_recno',;
				'columns' => aColumns, ;
				'data' => aRows;					
			}
		
		aEvents := { { 'name' => 'cellEdited' , 'proc' => 'update'} }		

		oDom:TableInit( 'panel_brw', hConfig, aEvents )				

		oDom:Set( 'info', cInfo )		

retu nil 

//	------------------------------------------------------------------- //

static function Dbu_Top( oDom )

	local cAlias 
	local aRows , aHeader, nPos, cHtml, nREcno, cInfo, cFile
	local nRows := Val( oDom:Get( 'pages' ) )		

	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )		
		oDom:SetScreen( 'dbfselect', '_dialog' )
		retu nil	
	endif
	
	cFile 	:= USession( "dbu_table" ) 
	
	cAlias 	:= OpenDbf( cFile )			
	cInfo 	:= InfoPag( cAlias, 1, nRows )	
	aRows  	:= GetRows( cAlias, 1, nRows ) 	
	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", 1  )
	USession("recno_bottom", nRecno )		
	
	oDom:TableClean( 'panel_brw' )
	oDom:TableSetData( 'panel_brw', aRows )
	oDom:Set( 'info', cInfo )		
	
retu nil

//	------------------------------------------------------------------- //

static function Dbu_Prev( oDom )

	local cAlias 
	local aRows , aHeader, nPos, cHtml, nRecno, cInfo,  cFile
	local nRows := Val( oDom:Get( 'pages' ) )

	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )		
		oDom:SetScreen( 'dbfselect', '_dialog' )
		retu nil	
	endif
	
	cFile 	:= USession( "dbu_table" ) 
	cAlias 	:= OpenDbf( cFile )		
	nPos 	:= if( USession( 'recno_top' ) == nil, 1, USession( 'recno_top' ) )
	
	
	nPos 	:= if( nPos - nRows < 1, 1, nPos - nRows )	
	cInfo 	:= InfoPag( cAlias, nPos, nRows )	
	aRows  	:= GetRows( cAlias, nPos, nRows ) 

	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", nPos  )
	USession("recno_bottom", nRecno )	
	
	oDom:TableClean( 'panel_brw' )
	oDom:TableSetData( 'panel_brw', aRows )	
	oDom:Set( 'info', cInfo )			

retu nil 

//	------------------------------------------------------------------- //

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
	nPos 	:= if( USession( 'recno_bottom' ) == nil, 1, USession( 'recno_bottom' ) )	
	aRows  	:= GetRows( cAlias, nPos, nRows ) 	
	cInfo 	:= InfoPag( cAlias, nPos, nRows )				
	
	if len (aRows ) == 0
		Dbu_End( oDom )
		retu nil
	endif 
		
	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", nPos )
	USession("recno_bottom", nRecno )	
	
	oDom:TableClean( 'panel_brw' )
	oDom:TableSetData( 'panel_brw', aRows )	
	oDom:Set( 'info', cInfo )	
	
retu nil 

//	------------------------------------------------------------------- //

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
	
	cFile 	:= USession( "dbu_table" ) 

	cAlias 	:= OpenDbf( cFile )	
	
	(cAlias)->( dbgobottom() )
	
	
	nTotalPag := Int( (cAlias)->( RecCount() ) / nRows )  + if( (cAlias)->( RecCount() ) % nRows == 0, 0, 1 )     
	
	nPos 	:= ( (nTotalPag - 1 ) * nRows ) + 1 
	

	cInfo 	:= InfoPag( cAlias, nPos, nRows )		
	aRows  	:= GetRows( cAlias, nPos, nRows ) 
	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", nPos  )
	USession("recno_bottom", nRecno )	
	
	oDom:TableClean( 'panel_brw' )
	oDom:TableSetData( 'panel_brw', aRows )
	
	oDom:Set( 'info', cInfo )

retu nil

//	------------------------------------------------------------------- //
/*	Cuando usamos el metodo 'cellEdit' (ver Dbu_Init()), cada vez que editemos una celda 
	el sistema creara una petición a nuestra api, en este caso 'update'
	
	aEvents := { { 'name' => 'cellEdited' , 'proc' => 'update'} }	
	
	En este caso recibiremos un parametro cell, con diversa información de la celda editada.
	La mejor manera de conocerla es debugar este parametro para ver su contenido
	
	--------------------------------------------------------------------------------------
	
	When we use the 'cellEdit' method (see Dbu_Init()), every time we edit a cell
	the system will create a request to our api, in this case 'update'

	aEvents := { { 'name' => 'cellEdited' , 'proc' => 'update'} }

	In this case we will receive a cell parameter, with various information about the edited cell.
	The best way to know it is to debug this parameter to see its content.		
*/

static function Dbu_Update( oDom )
	
	local cAlias, cFile, nPos, aStr, nField 	
	local lOK  	:= .F.
	local cMsg 	:= ''	
	local oCell 	:= oDom:Get( 'cell' )
	local cField 	:= oCell[ 'field' ]
	local uValue 	:= oCell[ 'value' ]
	local nRecno 	:= oCell[ 'row' ][ '_recno' ]		
	
	//	You need to know parameteres received from client. The best solution is 
	//  checking to debug it, in special 'cell' parameter.		

		//_d( oDom:Get( 'cell' ) )
	
	//	Example of field validating.
	
		//	AGE value -> 1 between 99
	
		if oCell[ 'field' ] == 'AGE' .and. ( uValue < 0 .or. uValue > 99 )
		
			//	Recover index of row. We setted _nRecno because in this case
			//	is as unique id
		
				nIndex := oCell[ 'row' ][ oCell[ 'index' ] ]	//	_nrecno
				
			// 	Now, we're in backend and cell was edited. We need to reset to old value 
		
				oDom:TableUpdateRow( 'panel_brw', nIndex, { cField => oCell[ 'oldvalue' ] } )
				
			//	As always after edited and process data, we need to reset flag of client
			//	browse to clear edited
			
				oDom:TableClearEdited( 'panel_brw' )
				
			//	We'll show a message error
				
				oDom:TableMessage( 'panel_brw', 'Error field: ' + oCell[ 'title' ] + '. Age should between 1 and 99' )
				
			//	At the moment oDom:SetAlert() don't working because Tabulator look doom... be patient :-)
			
				retu nil
		endif
	
	//	Init parameters...
	
		if ! USessionStart(  'DBU' )		
			oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )		
			oDom:SetScreen( 'dbfselect', '_dialog' )		
			retu nil	
		endif

		cFile 	:= USession( "dbu_table" ) 	//	Recover info from session 
		cAlias 	:= OpenDbf( cFile )			//	Open Dbf
		aStr 	:= USession( "dbu_str" ) 		// Recover structure, the same aStr := (cAlias)->( DbStruct() )
		
	//	Valid edited field
	
		nField  := Ascan( aStr, {|a| a[ 1 ] == cField } )
		
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


	//	Save data field
	
		nPos := (cAlias)->( FieldPos( cField ) )

		(cAlias)->( DbGoTo( nRecno ) )

		if (cAlias)->( DbRLock() )
		
			(cAlias)->( FieldPut( nPos, uValue ) ) 
			(cAlias)->( DbUnlock() )		
			
			lOk := .t.			
		else		
			cMsg := 'Lock error...'			
		endif

	//	Control browse dom 
	
		oDom:SetData( { 'updated' => lOk , 'msg' => cMsg } )
		oDom:TableClearEdited( 'panel_brw' )
		

retu nil

//	------------------------------------------------------------------- //

static function Dbu_Insert( oDom )

	local cAlias, cInfo, cFile 
	
	if ! USessionStart(  'DBU' )		
		oDom:SetConfirm( 'Session Out - Reopen DBF table ?' )	
		oDom:SetData( { 'updated' => .f. , 'msg' => 'Session KO. Que fem ?' } )		
		retu nil	
	endif
	
	cFile 	:= USession( "dbu_table" ) 

	cAlias 	:= OpenDbf( cFile )	
	
	(cAlias)->( DbAppend() )
	
	Dbu_End( oDom )
		
retu nil

//	------------------------------------------------------------------- //

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
	
	
	oDom:TableClean( 'panel_brw' )
	oDom:TableSetData( 'panel_brw', aRows )	
	oDom:Set( 'info', cInfo )	
	
	oDom:SetData( { 'sel' => aSelected } ) 		
		
retu nil

//	------------------------------------------------------------------- //

static function Dbu_Info( oDom, oServer )

	local cHtml	:= ''
	local cAlias, cFile, nDel, aDir
	
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

//	------------------------------------------------------------------- //

static function Dbu_Close( oDom )

	if ! USessionStart(  'DBU' )
		oDom:SetScreen( 'dbfselect', '_dialog' )
		retu nil	
	endif
	
	USessionEnd()	
	
	oDom:SetScreen( nil, '_container', 'panel', '' )			
	
retu nil

//	------------------------------------------------------------------- //

static function OpenDbf( cFile )

	static n := 1

	local cPathFile 	:= AppPathData() + cFile	
	local cAlias 		:= 'ALIAS' + ltrim(str(++n))

	use ( cPathFile ) shared new alias (cAlias) VIA 'DBFCDX' 
	cAlias := alias()

retu cAlias

//	------------------------------------------------------------------- //

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
				
				cAlign 			:= "center"		
				aValidator 	:= { 'type' => 'UValidDate', 'parameters' => { 'inputFormat' => 'DD/MM/YYYY' } }

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

//	------------------------------------------------------------------- //

static function GetRows( cAlias, nRecno, nTotal )

	local aRows := {}
	local aReg 
	local n 	:= 0
	local aStr  
	local nFields	
	local j	

	aStr  	:= USession( "dbu_str" )
	
	nFields	:= len( aStr )	
	
	(cAlias)->( DbGoto( nRecno ) )	
	
	while n < nTotal .and. (cAlias)->( !eof() ) 

		aReg := {=>}
		
		//HB_HSet( aReg, 'id' 		, (cAlias)->( Recno() ) )
		HB_HSet( aReg, '_recno' 	, (cAlias)->( Recno() ) )
		HB_HSet( aReg, '_del' 		, (cAlias)->( Deleted() ) )
		
		for j := 1 to nFields

			do case
				case aStr[j][2] == 'C'							
					HB_HSet( aReg, (cAlias)->( FieldName( j ) ), Alltrim( (cAlias)->( FieldGet( j ))) ) 
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

//	------------------------------------------------------------------- //

static function InfoPag( cAlias, nPos, nRows )
	
	local cInfo 		:= 'Pag. '
	local nTotal_Page 	:= Int( (cAlias)->( RecCount() ) / nRows ) + if( (cAlias)->( RecCount() ) % nRows == 0, 0, 1 )     
	local nPage 		:= Int( nPos / nRows ) + 1 	
	
retu 'Pag. ' + ltrim(str( nPage ))	 + '/' + ltrim(str(nTotal_Page))

//	------------------------------------------------------------------- //