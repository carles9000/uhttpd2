#include "../lib/tweb/tweb.ch"


function Order()

	local o, oWeb, oType, oNav
	
	DEFINE WEB oWeb TITLE 'Order'
	
		NAV oNav ID 'nav' TITLE '&nbsp;Order' LOGO 'files/images/mercury.png' OF oWeb 
	
			MENUITEM 'Home' ROUTE '/' 		OF oNav
			MENUITEM 'List' ROUTE 'list' 	OF oNav
	
	DEFINE FORM o ID 'order'  API "api_order" OF oWeb 
		o:lDessign := .F.		
		
		/*
		HTML o
			<div class="alert alert-info">
			  <strong>Order</strong> (butano)
			</div>						
		ENDTEXT 
		*/
		
	INIT FORM o 
	
		
	
		ROWGROUP o
			GET ID 'dni' LABEL 'DNI' VALUE '' GRID 6 ;
				BUTTON 'Search' ACTION 'search' OF o 
				
			SMALL ID 'info' LABEL '...' GRID 6 OF o
		ENDROW 	o	

		ROWGROUP o
			GET ID 'qty' LABEL 'QTY' VALUE '' GRID 6 OF o 
			SELECT oType ID 'type' LABEL 'Type' PROMPT 'Big', 'Normal', 'Small' ;
				VALUES 'B', 'N', 'S' GRID 6 OF o
		ENDROW 	o	


		ROWGROUP o
			GET ID 'notes' LABEL 'Notes' VALUE '' GRID 12 OF o 		
		ENDROW 	o	

		ROWGROUP o
			BUTTON LABEL 'Send' ACTION 'send' WIDTH '100%' GRID 12 OF o 		
		ENDROW 	o	
	
	ENDFORM o 
	
	
	INIT WEB oWeb RETURN		

retu nil 


function Api_Order( oDom )

	do case
		case oDom:GetProc() == 'search'; DoSearch( oDom )
		case oDom:GetProc() == 'send' 	; DoSend( oDom )
		otherwise
			oDom:SetError( 'Proc no existe: ' + oDom:GetProc() )
	endcase


retu oDom:Send()

function DoSearch( oDom )

	local nRecno :=  Val( oDom:Get( 'dni' )  )
	local cInfo
	
	
	if nRecno == 0 	
		oDom:SetAlert( 'Error DNI ')
		retu nil
	endif
	
	USE ( 'data\test.dbf' ) SHARED NEW VIA 'DBFCDX'
		
	dbgoto( nRecno )
	
	cInfo := 	'<b>Nombre</b>: ' + FIELD->first + '<br>' + ;
				'<b>Last: </b>: ' + FIELD->last + '<br>' + ;
				'<b>City: </b>: ' + FIELD->city 
				
	oDom:Set( 'info', cInfo )


retu nil 

function DoSend( oDom )

	local nRecno :=  Val( oDom:Get( 'dni' )  )
	local cInfo
	local nQty 	:= Val( oDom:Get( 'qty' )  )
	
	//	Chequear los parametros
	
		if nRecno == 0 	
			oDom:SetAlert( 'Error DNI ')
			retu nil
		endif	

		if nQty == 0 	
			oDom:SetAlert( 'Qty KO ')
			retu nil
		endif

	//	Salvamos datos 
	
	USE ( 'data\order.dbf' ) SHARED NEW VIA 'DBFCDX'
		
	DbAppend()
	
	FIELD->date    	:= date()
	FIELD->time    	:= time()
	//FIELD->ip    		:= UGetIp()
	FIELD->id_custo   	:= nRecno
	FIELD->qty		    := nQty
	FIELD->type	    := oDom:Get( 'type' )
	FIELD->notes 		:= oDom:Get( 'notes' )
	
	oDom:Set('dni', '' )
	oDom:Set('info', '' )
	oDom:Set('qty', '' )
	oDom:Set('type', '' )
	oDom:Set('notes', '' )
	oDom:Focus( 'dni' )
	
	
	oDom:SetAlert( 'Datos salvados' )

retu nil 



