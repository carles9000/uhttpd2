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
	oServer:SetDirFiles( 'data' )
	
	//	Config status error... 
	//	oServer:SetErrorStatus( <nStatus>, <cPage>, <cAjax> )	
	//	If you specify a file, system will load, it othercase return message
	
		oServer:SetErrorStatus( 404, 'error\404.html', 'This page not found...' )
	//	oServer:SetErrorStatus( 404, '<h2>Mi error...</h2>', '' )
	//	----------------------
	
	//	Routing...			

		oServer:Route( '/'		, 'main.html' )  												
		oServer:Route( 'test'	, 'test.html' )  												
		
	//	-----------------------------------------------------------------------//	
	
	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETU 1
	ENDIF
	
RETURN 0

//----------------------------------------------------------------------------//