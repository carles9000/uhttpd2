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
		
		oServer:Route( '/'		, 'main.html' )  																	
		oServer:Route( 'proc1'	, 'proc1.html' )  																	
		oServer:Route( 'proc2'	, 'proc2.html' )  																	
		oServer:Route( 'proc3'	, 'proc3.html' )  																	
		
	//	-----------------------------------------------------------------------//	
	
	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETU 1
	ENDIF
	
RETURN 0

//----------------------------------------------------------------------------//