function main()

	InitServer() 	
	
	while inkey(0)	!= 27
	end

retu nil 

function InitServer()		

	hb_threadStart( @WebServer() )
		
retu nil 


function WebServer()

	local oServer 	:= UHttpd2New()
	
	oServer:SetPort( 81 )
	oServer:lDebug := .t.
	
	//	Routing...		

		oServer:Route( '/'				, 'splash.html' ) 
		
		oServer:Route( 'basic'			, 'basic.html' ) 
		oServer:Route( 'basic_dom'		, 'basic_dom.html' ) 
		
		oServer:Route( 'menu'			, 'main.html' ) 
		oServer:Route( 'dialog'		, 'dialog.html' ) 
		oServer:Route( 'dialog_win'	, 'dialog_win.html' ) 
		oServer:Route( 'brw1'			, 'brw1.html' ) 
		oServer:Route( 'brw_header'	, 'brw_header.html' ) 	 
		oServer:Route( 'controls'		, 'testcontrol.html' )  
		oServer:Route( 'screens'		, 'testscreen.html' ) 	 
		oServer:Route( 'session'		, 'session.html' ) 		 
					
	//	-----------------------------------------------------------------------//
	
	oServer:bInit := {|hInfo| ShowInfo( hInfo ) }

	IF ! oServer:Run()
	
		? "=> Server error:", oServer:cError

		RETU 1
	ENDIF
	
RETURN 0

function ShowInfo( hInfo ) 

	HB_HCaseMatch( hInfo, .f. ) 

	? '---------------------------------'
	? 'Server Harbour9000 was started...'
	? '---------------------------------'
	? 'Start......: ' + hInfo[ 'start' ]
	? 'Port.......: ' + ltrim(str(hInfo[ 'port' ]))
	? 'OS.........: ' + UHtmlEncode(OS())
	? 'Harbour....: ' + UHtmlEncode(VERSION())
	? 'Build date.: ' + UHtmlEncode(HB_BUILDDATE())
	? 'Compiler...: ' + UHtmlEncode(HB_COMPILER())
	? 'SSL........: ' + if( hInfo[ 'ssl' ], 'Yes', 'No' )
	? 'Trace......: ' + if( hInfo[ 'debug' ], 'Yes', 'No' )
	? '---------------------------------'
	? 'Escape for exit...' 	
	
retu nil 
