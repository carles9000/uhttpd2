#define VK_ESCAPE	27


function main()

	hb_threadStart( @WebServer() )	
	
	while inkey(0) != VK_ESCAPE
	end

retu nil 

//----------------------------------------------------------------------------//
function WebServer()

	local oServer 	:= Httpd2()
	
	oServer:lDbfAutoClose 	:= .f.		//	Default .t.
	oServer:nSession_TimeOut 	:= 10		//	Default 30
	oServer:lDebug 			:= .t.		// 	Default .f.  (DbgView)
	
	oServer:SetPort( 81 )
	oServer:SetDirFiles( 'data' )
	
	//	Routing...			

		oServer:Route( '/'		, 'test' )  												
		
	//	-----------------------------------------------------------------------//	
	
	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETU 1
	ENDIF
	
RETURN 0

//----------------------------------------------------------------------------//

function Test()

	thread static cAlias := ''
	
	//	----------------------------------------------------------------------
	//	Una vez abierta la tabla tendremos almacenado su puntero en cAlias
	//	mientras dure la conexion "keep alive" que se ha establecido
	//	Para este ejercicio es bueno tener abierto el DbView.exe para ver 
	//	lo que ocurre... Espera n segundos (oServer:nSession_TimeOut) antes de 
	//	refrescar la pagina para ver como se cierra el hilo y se abre otro en 
	//	la nueva peticion. Cuando se crea un nuevo hilo, es cuando se abrira 
	//	la tabla.
	//	Esta técnica merece conocer como funciona bien el servidor.
	//	Se puede aplicar a otro tipo de conexiones...
	//	----------------------------------------------------------------------
	
	if select(cAlias) == 0	
		UWrite( 'Open table...')		
		use '.\data\test.dbf' shared new 
		cAlias := Alias()	
	endif 						
	
	UWrite( '<br>Alias: ' + cAlias  )
	UWrite( '<hr>' )				
	
	(cAlias)->( DbSkip() )
	
	UWrite( '<br>=> ' + str((cAlias)->( Recno() )) + ' ' + (cAlias)->first )
	
retu nil 

//----------------------------------------------------------------------------//