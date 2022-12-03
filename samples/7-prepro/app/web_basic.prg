function TestLoadHtml()

	local hData := { 'name' => 'Charly', 'age' => 55 }
	local cHtml 

	cHtml := ULoadHtml( 'test5.html', hData, time(), date() )
	
	UWrite( cHtml )
	
retu nil 

//	--------------------------------------------------------------------
//	lo mas importante de este proceso, es que lo dividimos en 2 partes
//	1.- Manipulacion y proceso de datos
//	2.- Carga de pagina y le pasamos los datos para que los pinte
//	
//	Es decir, toda la logica la tendremos dentro del ejecutable, NO en 
//	el html
//	
//	--------------------------------------------------------------------
	
function MyProcess()

	local aRows 	:= {}
	local nAge 	:= 	int(hb_Random( 10, 90 ))
	local cHtml 	:= ''
	
	//	Process Data...

		USE ( 'data\test.dbf' ) SHARED NEW 
		
		DbGoTop()
		
		//	We'll select age == nAge 
		
		WHILE !Eof()
		
			if FIELD->age == nAge
			
				Aadd( aRows, { 'first' => FIELD->first, 'last' => FIELD->last, 'street' => FIELD->street  } )
				
			endif

			DbSkip()
		
		END 
	
	//	Load & Process View
	
		cHtml := ULoadHtml( 'test8.html', nAge, aRows )
		
		UWrite( cHtml )					

retu nil 