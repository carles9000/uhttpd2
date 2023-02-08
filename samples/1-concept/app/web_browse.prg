#define ROWS_PAGE 20

function web_browse( oTDom )	

	do case
		
		case oTDom:GetProc() == 'top' 		;	DoTop( oTDom )
		case oTDom:GetProc() == 'prev' 	;	DoPrev( oTDom )
		case oTDom:GetProc() == 'next' 	;	DoNext( oTDom )
		case oTDom:GetProc() == 'end' 		;	DoEnd( oTDom )
		case oTDom:GetProc() == 'refresh'	;	DoTop( oTDom )
		
		otherwise 				
				oTDom:SetError( 'No existe Proc: ' + oTDom:GetProc() )
	endcase

retu oTDom:Send()	

static function DoTop( oTDom )

	local cAlias := OpenDbf()
	local aRows , aHeader, nPos, cHtml, nREcno, cInfo
	local nRows := Val( oTDom:Get( 'pages' ) )		

	USessionStart(  'TABLE' )
	
	cInfo 	:= InfoPag( 1, cAlias, nRows )

	aHeader	:= GetHeader()	
	aRows  	:= GetRows( cAlias, 1, nRows ) 
	cHtml 	:= DoTable( aHeader, aRows )

	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", 1  )
	USession("recno_bottom", nRecno )		
	
	oTDom:Set( 'panel_brw', cHtml )
	oTDom:Set( 'info', cInfo )	
	
	
retu nil

static function DoPrev( oTDom )

	local cAlias := OpenDbf()
	local aRows , aHeader, nPos, cHtml, nRecno, cInfo
	local nRows := Val( oTDom:Get( 'pages' ) )


	USessionStart()
	
	
	nPos := if( USession( 'recno_top' ) == nil, 1, USession( 'recno_top' ) )
	
	
	nPos := if( nPos - nRows < 1, 1, nPos - nRows )
	
	cInfo 	:= InfoPag( nPos, cAlias, nRows )
	
	aHeader	:= GetHeader()	
	aRows  	:= GetRows( cAlias, nPos, nRows ) 
	cHtml 	:= DoTable( aHeader, aRows )

	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", nPos  )
	USession("recno_bottom", nRecno )
	
	
	
	
	oTDom:Set( 'panel_brw', cHtml )
	oTDom:Set( 'info', cInfo )	
	
	
retu nil

static function DoNext( oTDom )

	local cAlias := OpenDbf()
	local aRows , aHeader, nPos, cHtml, nRecno, cInfo
	local nRows := Val( oTDom:Get( 'pages' ) )


	USessionStart()		
	
	nPos := if( USession( 'recno_bottom' ) == nil, 1, USession( 'recno_bottom' ) )
	
	aHeader	:= GetHeader()
	aRows  	:= GetRows( cAlias, nPos, nRows ) 	
	cInfo 	:= InfoPag( nPos, cAlias, nRows )				


	if len (aRows ) == 0
		DoEnd( oTDom )
		retu nil
	endif 
	

	cHtml 	:= DoTable( aHeader, aRows )

	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", nPos )
	USession("recno_bottom", nRecno )
	

	oTDom:Set( 'panel_brw', cHtml )
	oTDom:Set( 'info', cInfo )	

	
retu nil 

static function DoEnd( oTDom )

	local cAlias := OpenDbf()
	local aRows , aHeader, nPos, cHtml, nRecno, cInfo
	local nTotalPag
	local nRows := Val( oTDom:Get( 'pages' ) )

	USessionStart()		
	(cAlias)->( dbgobottom() )
	
	nTotalPag := Int( (cAlias)->( RecCount() ) / nRows ) + 1 
	
	nPos 	:= ( (nTotalPag - 1 ) * nRows ) + 1 
	
	cInfo 	:= InfoPag( nPos, cAlias, nRows )	
	
	aHeader	:= GetHeader()	
	aRows  	:= GetRows( cAlias, nPos, nRows ) 
	cHtml 	:= DoTable( aHeader, aRows )

	nRecno 	:= (cAlias)->( recno() )
	
	USession("recno_top", nPos  )
	USession("recno_bottom", nRecno )	
	
	oTDom:Set( 'panel_brw', cHtml )
	oTDom:Set( 'info', cInfo )	
	
retu nil


static function OpenDbf

	static n := 1

	local cPath 	:= HB_DIRBASE() + "/data/"
	local cAlias 	:= 'ALIAS' + ltrim(str(++n))

	use ( cPath + 'test.dbf' ) shared new alias (cAlias)
	cAlias := alias()

retu cAlias

static function GetHeader( cAlias )

	local aHeader := {}
	
	aHeader := { 'Recno', 'First', 'Last', 'Street', 'City', 'State' }
	
retu aHeader 

static function GetRows( cAlias, nRecno, nTotal )

	local aRows := {}
	local aReg 
	local n 	:= 0
	
	(cAlias)->( DbGoto( nRecno ) )	
	
		while n < nTotal .and. (cAlias)->( !eof() ) 
		
			aReg := { '_recno' => str((cAlias)->( Recno() )),;
						'first' => (cAlias)->first, ;
						'last' => (cAlias)->last,;
						'street' => (cAlias)->street,;
						'city' => (cAlias)->city,;
						'state' => (cAlias)->state ;
						}
			
			Aadd( aRows, aReg ) 
		
			(cAlias)->( DbSkip() )
			n++
		end 
		
	
	
	
retu aRows 

static function DoTable( aHeader, aRows ) 

	local nLen 		:= len( aRows )
	local nFields 	:= if( empty( aHeader ), 0, len( aHeader[1] ) )
	local cHtml 	:= ''
	local n, j, hReg 

	
	cHtml := '<table class="TBrowse">'	
	
		cHtml += '<thead>'
		cHtml += '<tr>'		
		
		for j :=  1 to nFields 
			cHtml += '<th>' + aHeader[j] + '</th>'
		next
		
		cHtml += '</tr>'
		cHtml += '</thead>'
		cHtml += '<tbody>'
	
		for n := 1 to nLen  
		
			hReg := aRows[n]			
			
			cHtml += '<tr>'			
			
			for j :=  1 to nFields 
				cHtml += '<td>'
				cHtml += HB_HValueAt( hReg, j )
				cHtml += '</td>'
			next
			
			cHtml += '</tr>'
			
		next
		
		cHtml += '</tbody>'

	cHtml += '</table>'

retu cHtml 

static function InfoPag( nPos, cAlias, nRows )

	
	local cInfo 		:= 'Pag. '
	local nTotal_Page 	:= Int( (cAlias)->( RecCount() ) / nRows ) + 1
	local nPage 		:= Int( nPos / nRows ) + 1 	
	
retu 'Pag. ' + ltrim(str( nPage ))	 + '/' + ltrim(str(nTotal_Page))
