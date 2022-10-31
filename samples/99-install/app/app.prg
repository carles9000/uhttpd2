#define VK_ESCAPE	27


function main()

	hb_threadStart( @WebServer() )	
	
	while inkey(0) != VK_ESCAPE
	end

retu nil 

//----------------------------------------------------------------------------//

function WebServer()

	local oServer 	:= UHttpd2New()
	
	oServer:SetPort( 81 )
	
	//	Routing...		
				
		oServer:Route( '/'	, 'hello.html' )  		
			
	//	-----------------------------------------------------------------------//	
	
	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETU 1
	ENDIF
	
RETURN 0

//----------------------------------------------------------------------------//