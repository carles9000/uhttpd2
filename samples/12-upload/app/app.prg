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
	
	//	Optional parameteres
	
	oServer:nfiles_size_garbage_inspector 	:= 100000									//	Default 2000000 Kb.
	oServer:nFile_max_size 					:= 10000									//	Default 100000 Kb.
	oServer:aFilesAllowed 					:= { 'jpg', 'jpeg', 'pdf', 'png', 'txt' } 	// 	Default all
	
	
	//	Routing...		
				
		oServer:Route( '/'			, 'index.html') 
		oServer:Route( 'upl_api'	, 'via_api.html' ) 
		oServer:Route( 'upl_js'		, 'via_js.html' ) 
		oServer:Route( 'upl'		, 'myupload') 
		

		oServer:Route( 'testpro', 'testpro.html' ) 
		
			
	//	-----------------------------------------------------------------------//	
	
	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETU 1
	ENDIF
	
RETURN 0

//----------------------------------------------------------------------------//