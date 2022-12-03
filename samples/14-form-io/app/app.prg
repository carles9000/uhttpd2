function main()

	InitServer() 	
	
	while inkey(0)	!= 27
	end

return nil 

//----------------------------------------------------------------------------//

function InitServer()		

	hb_threadStart( @WebServer() )
		
return nil 

//----------------------------------------------------------------------------//

function WebServer()

	local oServer 	:= UHttpd2New()		
	
	oServer:SetPort( 81 )
	
	//	Routing...		
   oServer:Route( '/'		,  'basic.html' ) 	    // Vista (app)
   oServer:Route( 'info',     'info.html' )         // Info acerca del diseñador
   oServer:Route( 'workshop', 'workshop.html' )     // Diseñador de formulario
   oServer:Route( 'getForm',  'LoadForm' )          // Cargar formulario
   oServer:Route( 'setForm',  'SaveForm' )          // Guardar formulario 

	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETURN 1
	ENDIF
	
RETURN 0

//----------------------------------------------------------------------------//
