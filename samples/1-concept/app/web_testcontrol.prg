/*
	
	Supported responses:
	
	setter 		: array of hash -> { { 'id' => 'x', 'value' => 1234 } }
	focus 		: id
	active		: array of hash -> { { 'id' => 'x', 'value' => .F. } }
	visibility	: array of hash -> { { 'id' => 'x', 'action' => .T. } }
				  array of hash -> { { 'id' => 'x', 'action' => 'toggle' } }
	class 		: array of hash -> { { 'id' => 'x', 'class' => 'border_green' } 
				  array of hash -> { { 'id' => 'x', 'class' => 'border_green', 'action' => 'toggle' } 
	js 			: hash -> { 'func' => 'MyTestJS', 'data' => hData }
	cargo		: hash -> { 'message' => 'OnInit OK' } 
*/


function Web_TestControl( oDom )

	do case
		case oDom:GetProc() == 'myinit' 			; Test_MyInit( oDom )
		case oDom:GetProc() == 'calc_total' 		; Test_CalcTotal( oDom )
		case oDom:GetProc() == 'calc_saco' 			; Test_CalcSaco( oDom )
		case oDom:GetProc() == 'max_100' 			; Test_Max_100( oDom )
		case oDom:GetProc() == 'married'			; Test_Married( oDom )
		case oDom:GetProc() == 'disable_enable'		; Test_Disable_Enable( oDom )
		case oDom:GetProc() == 'exe_check_lang'		; Test_Check_Lang( oDom )
		case oDom:GetProc() == 'exe_js'				; Test_JS( oDom )
		case oDom:GetProc() == 'exe_setclass'		; Test_Class( oDom )
		case oDom:GetProc() == 'exe_focus'			; Test_Focus( oDom )
		case oDom:GetProc() == 'exe_visibility'		; Test_Visibility( oDom )
		case oDom:GetProc() == 'exe_cliente'		; Test_Cliente( oDom )
		case oDom:GetProc() == 'exe_cliente_clean'	; oDom:Set( 'cliente_info', '' )
		case oDom:GetProc() == 'exe_alert'			; oDom:SetAlert( 'Error at ' + time() )		
		case oDom:GetProc() == 'exe_error'			; Test_Error( oDom )		
		case oDom:GetProc() == 'web_lang'			; Test_Web_Lang( oDom )
				
		otherwise 				
				oDom:SetError( 'No existe Proc: ' + oDom:GetProc() )
	endcase

retu oDom:Send()	

//	------------------------------------------------------------------ //

static function Test_MyInit( oDom )

	oDom:SetAlert( 'oninit event: Hello !' )
	
retu nil 

//	------------------------------------------------------------------ //

static function Test_CalcTotal( oDom )
	local nCantidad 	:= Val( oDom:Get( 'cantidad' ) )
	local nPrecio		:= Val( oDom:Get( 'precio' ) )
	local nTotal 		:= nCantidad * nPrecio 

	oDom:Set( 'total', nTotal )
	
retu nil 

//	------------------------------------------------------------------ //

static function Test_CalcSaco( oDom )
	local nSaco_1 	:= Val( oDom:Get( 'saco_1' ) )
	local nSaco_2 	:= Val( oDom:Get( 'saco_2' ) )
	local nSaco_3 	:= Val( oDom:Get( 'saco_3' ) )	
	local nTotal 	:= nSaco_1 + nSaco_2 + nSaco_3

	oDom:Set( 'total_saco', nTotal )
	
retu nil 

//	------------------------------------------------------------------ //

static function Test_Max_100( oDom )
	local nMyNum 	:= Val( oDom:Get( 'mynum' ) )

	if nMyNum < 0 .or. nMyNum > 100 	
	
		oDom:Set( 'mynum', 0 )
		oDom:Focus( 'mynum' )
		oDom:SetAlert( 'Range 0-100 ' )		
		
	endif		
	
retu nil 


//	------------------------------------------------------------------ //

static function Test_Married( oDom )
	local lMarried	:= oDom:Get( 'married' ) 

	oDom:Visibility( 'married-info', lMarried )	
	
retu nil 

//	------------------------------------------------------------------ //

static function Test_Check_Lang( oDom )
	local cLang	:= oDom:Get( 'lang' ) 

	do case
		case cLang == 'harbour'	; oDom:SetUrl( 'https://harbour.github.io/' )	
		case cLang == 'php' 	; oDom:SetUrl( 'https://www.php.net/manual/es/intro-whatis.php', '_self' )	
		case cLang == 'phyton' 	; oDom:SetUrl( 'https://www.python.org/', 'MyWindow', "width=800,height=400" )

		otherwise
			//	Nothing to do...
	endcase

	
retu nil 

//	------------------------------------------------------------------ //

static function Test_Disable_Enable( oDom )
	
	local lChecked  := oDom:Get( 'mycheck' )
	local hControls := oDom:GetAll()
	local n, cId


	for n = 1 to len( hControls )		
	
		cId := HB_HKeyAt( hControls, n )		

		if cId != 'mycheck'
		
			oDom:Active( cId, ! lChecked )
			
		endif
		
	next	
	
	
retu nil 

//	------------------------------------------------------------------ //

static function Test_JS( oDom )

	local hData := {=>}

	
	hData[ 'name' ] 	:= 'John Smith'
	hData[ 'time' ] 	:= time()
	hData[ 'date' ] 	:= date()
	hData[ 'id' ] 		:= 1234
	hData[ 'active' ] 	:= .t.

	oDom:SetJS( 'MyTestJS', hData )							
	
retu nil 

//	------------------------------------------------------------------ //

static function Test_Class( oDom )

	local hData := {=>}

	oDom:SetClass(  'saco_1'  , 'border_green', 'toggle' )
	oDom:SetClass(  'saco_2'  , 'border_green', 'toggle' )
	oDom:SetClass(  'saco_3'  , 'border_green', 'toggle' )
	
	oDom:SetClass(  'cantidad', 'border_blue' , 'toggle' )
	oDom:SetClass(  'precio'  , 'border_blue' , 'toggle' )	
	
retu nil 

//	------------------------------------------------------------------ //


static function Test_Focus( oDom )	

	oDom:Focus( 'mynum' )
	
retu nil 

//	------------------------------------------------------------------ //

static function Test_Visibility( oDom )	

	oDom:Visibility( 'group_saco', 'toggle' )
	
retu nil 

//	------------------------------------------------------------------ //

static function Test_Cliente( oDom )	

	local nCliente		:= Val( oDom:Get( 'cliente' ) )
	local aClientes	:= { { 'name'=> 'John Kocinski', 'contact' => 'johtn@gmail.com' },;
						 { 'name'=> 'Billy Murray', 'contact' => 'billy@hotmail.com' },;
						 { 'name'=> 'Jack Sparrow', 'contact' => 'jack@microsoft.com' };
						}	
	local cInfo
	
	//	ABRIMOS DBF Y BUSCAMOS CLIENTE	
	
	if nCliente == 1 .or. nCliente == 2 .or. nCliente == 3 
	
		cInfo := '<table border="1">'
		cInfo += '<tr>'		
		cInfo += '<tr><td>Hora peticion</td><td>' +  time() + '</td></tr>'
		cInfo += '<tr><td>Cliente</td><td>' +  aClientes[nCliente]['name'] + '</td></tr>'
		cInfo += '<tr><td>Contact</td><td>' +  aClientes[nCliente]['contact'] + '</td></tr>'
		cInfo += '</table>'

		oDom:Set( 'cliente_info', cInfo )
		
	else 	

		oDom:Set( 'cliente_info', '<b><span style="color:red;">Cliente no existe</span></b>' )		
		
	endif 			
	
retu nil 

//	------------------------------------------------------------------ //

function Test_Error( oDom ) 

	local uValue := 10 / 'A'

retu nil 

//	------------------------------------------------------------------ //

function Test_Web_Lang( oDom ) 

	local cLang := oDom:Get( 'fav_language' )

	oDom:SetAlert( 'You are selected: ' + cLang )

retu nil 


//	------------------------------------------------------------------ //