function web_basic( oDom )

	do case
		case oDom:GetProc() == 'exe_test' 	; Test( oDom )								
		
		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase
	

retu oDom:Send()	

static function Test( oDom )

	local cRegister	:= oDom:Get( 'register' ) 
	local hData 		:= { 'recno' => cRegister }
	

	oDom:SetJS( 'MyConsole', hData )			
	oDom:Set( 'info', hb_jsonEncode( hData ) )		
	
retu nil 

function MyFunc() 

	local hPost := UPost()
	local cData := hb_jsonEncode( hPost )	
	
	do case
		case hPost[ 'test' ] == 'text' 					
		case hPost[ 'test' ] == 'json' ; UAddHeader("Content-Type", "application/json")		
	endcase
	
	//	Siempre se devuelve en formato texto. La diferencia entre los dos es que para json 
	//	definimos una cabecera de tipo json. Cuando llegue al navegador, en el caso 2  
	//	automaticamente transformará el texto a json
	//
	//  It is always returned in text format. The difference between the two is that for 
	//	json we define a header of type json. When the string reaches the browser, in 
	//	case 2 it will automatically transform the text to json.
	
	
	UWrite( cData )	
	
retu nil
