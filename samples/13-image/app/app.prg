#define VK_ESCAPE	27

function main()

	InitServer() 	
	
	while inkey(0) != VK_ESCAPE
	end

retu nil 
		
function InitServer()	

	hb_threadStart( @WebServer() )
		
retu nil 


function WebServer()

	local oServer 	:= UHttpd2New()
	
	oServer:SetPort( 81 )
	
	oServer:SetDirFiles( 'data' )
	
	//	Routing...		
				
		oServer:Route( '/'	, 'index.html') 			
	
	//	-----------------------------------------------------------------------//	
	
	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETU 1
	ENDIF
	
RETURN 0

//----------------------------------------------------------------------------//