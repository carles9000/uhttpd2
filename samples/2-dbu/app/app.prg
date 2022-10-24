REQUEST DBFCDX

function main()

	Config()
	InitServer() 	
	
	while inkey(0)	!= 27
	end

retu nil 

function Config()

	SET DATE FORMAT TO 'DD/MM/YYYY'
	SET DELETE OFF 
	RddSetDefault( 'DBFCDX' )
	
retu nil 
		
function InitServer()		

	hb_threadStart( @WebServer() )
		
retu nil 


function WebServer()

	local oServer 	:= UHttpd2New()
	
	oServer:SetPort( 81 )
	oServer:lDebug := .t.

	
	//	Routing...

		oServer:Route( 'files/*'	, {|hSrv| UProcFiles( HB_DIRBASE() + "/files/" + hSrv[ 'path' ], .F.)} ) 
				
		oServer:Route( '/'			, {|hSrv| ULoadPage( hSrv, 'splash.html' ) 	}) 

		oServer:Route( 'menu'		, {|hSrv| ULoadPage( hSrv, 'menu.html' ) 		}) 
		oServer:Route( 'dbfbuild'	, {|hSrv| ULoadPage( hSrv, 'dbfbuild.html' )	}) 
		oServer:Route( 'dbfselect'	, {|hSrv| ULoadPage( hSrv, 'dbfselect.html' )	}) 
		oServer:Route( 'dirtables'	, {|hSrv| ULoadPage( hSrv, 'dirtables.html' )	}) 
		oServer:Route( 'server'	, {|hSrv| ULoadPage( hSrv, 'server.html' )	}) 
		oServer:Route( 'dbu'		, {|hSrv| ULoadPage( hSrv, 'dbu.html' )		}) 
		
			
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
	? 'Version httpd2...: ' + hInfo[ 'version' ]
	? 'Start............: ' + hInfo[ 'start' ]
	? 'Port.............: ' + ltrim(str(hInfo[ 'port' ]))
	? 'OS...............: ' + UHtmlEncode(OS())
	? 'Harbour..........: ' + UHtmlEncode(VERSION())
	? 'Build date.......: ' + UHtmlEncode(HB_BUILDDATE())
	? 'Compiler.........: ' + UHtmlEncode(HB_COMPILER())
	? 'SSL..............: ' + if( hInfo[ 'ssl' ], 'Yes', 'No' )
	? 'Trace............: ' + if( hInfo[ 'debug' ], 'Yes', 'No' )
	? '---------------------------------'
	? 'Escape for exit...' 	
	
retu nil 

//----------------------------------------------------------------------------//

function AppPathData() ; retu  HB_DIRBASE() + 'data\' 

