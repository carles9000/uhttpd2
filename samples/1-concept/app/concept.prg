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

		oServer:Route( 'files/*'	,{|hSrv| UProcFiles(HB_DIRBASE() + "/files/" + hSrv[ 'path' ], .F.)} ) 
				
		oServer:Route( '/'			, {|hSrv| ULoadPage( hSrv, 'splash.html' ) 		}) 
		
		oServer:Route( 'basic'		, {|hSrv| ULoadPage( hSrv, 'basic.html' ) 		}) 
		oServer:Route( 'basic_dom'	, {|hSrv| ULoadPage( hSrv, 'basic_dom.html' ) 	}) 
		
		oServer:Route( 'menu'		, {|hSrv| ULoadPage( hSrv, 'main.html' ) 		}) 
		oServer:Route( 'dialog'		, {|hSrv| ULoadPage( hSrv, 'dialog.html' ) 		}) 
		oServer:Route( 'dialog_win'	, {|hSrv| ULoadPage( hSrv, 'dialog_win.html' )	}) 
		oServer:Route( 'brw1'		, {|hSrv| ULoadPage( hSrv, 'brw1.html' ) 		}) 
		oServer:Route( 'brw_header'	, {|hSrv| ULoadPage( hSrv, 'brw_header.html' ) 	}) 
		oServer:Route( 'controls'	, {|hSrv| ULoadPage( hSrv, 'testcontrol.html' ) }) 
		oServer:Route( 'screens'	, {|hSrv| ULoadPage( hSrv, 'testscreen.html' ) 	}) 
		oServer:Route( 'session'	, {|hSrv| ULoadPage( hSrv, 'session.html' )		}) 
					
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
