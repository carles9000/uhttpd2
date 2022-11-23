#define VK_ESCAPE	27



function main()

	hb_threadStart( @WebServer() )	
	
	while inkey(0) != VK_ESCAPE
	end

retu nil 

//----------------------------------------------------------------------------//

function WebServer()

	local oServer 	:= Httpd2()
	
	oServer:SetPort( 81 )
	
	//	Routing...	
				
		oServer:Route( '/'			, 'index.html' )  		
		oServer:Route( 'testerror0'	, 'error_xxx' ) 
		oServer:Route( 'testerror1'	, 'testerror1' ) 
		oServer:Route( 'testerror2'	, 'testerror2' ) 
		oServer:Route( 'testerror3'	, 'testerror3' )  		
		oServer:Route( 'testerror4'	, 'testerror4' ) 
 		
		oServer:Route( 'testajax'	, 'testajax.html' )  		
		
			
	//	-----------------------------------------------------------------------//	
	
	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETU 1
	ENDIF
	
RETURN 0


//----------------------------------------------------------------------------//