#define VK_ESCAPE	27

REQUEST DBUSEAREA, DBSKIP
REQUEST DBFCDX


function main()

	InitServer() 	
	
	while inkey(0) != VK_ESCAPE
	end

retu nil 
		
function InitServer()			
	
	SET DATE TO ITALIAN
	SET DATE FORMAT TO 'DD/MM/YYYY'

	hb_threadStart( @WebServer() )
		
retu nil 


function WebServer()

	local oServer 	:= UHttpd2New()
	
	oServer:SetPort( 81 )
	
	//	Routing...		
				
		oServer:Route( '/'		, 'index.html') 		
		oServer:Route( 'test1'	, 'test1.html') 		
		oServer:Route( 'test2'	, 'test2.html') 		
		oServer:Route( 'test3'	, 'test3.html') 		
		oServer:Route( 'test4'	, 'test4.html') 						
		
		oServer:Route( 'test5'	, 'testloadhtml') 				
		
		oServer:Route( 'test6'	, 'test6.html') 				
		oServer:Route( 'test7'	, 'test7.html') 				
		
		oServer:Route( 'test8'	, 'myprocess') 				
			
	//	-----------------------------------------------------------------------//	
	
	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETU 1
	ENDIF
	
RETURN 0

//----------------------------------------------------------------------------//