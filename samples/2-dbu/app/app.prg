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
				
		oServer:Route( '/'			, 'splash.html' ) 

		oServer:Route( 'menu'		, 'menu.html' 	) 
		oServer:Route( 'dbfbuild'	, 'dbfbuild.html'  ) 
		oServer:Route( 'dbfselect'	, 'dbfselect.html' ) 
		oServer:Route( 'dirtables'	, 'dirtables.html' ) 
		oServer:Route( 'server'	, 'server.html' ) 
		oServer:Route( 'dbu'		, 'dbu.html' 	) 
		
			
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
	? 'OS...............: ' + OS()
	? 'Harbour..........: ' + VERSION()
	? 'Build date.......: ' + HB_BUILDDATE()
	? 'Compiler.........: ' + HB_COMPILER()
	? 'SSL..............: ' + if( hInfo[ 'ssl' ], 'Yes', 'No' )
	? 'Trace............: ' + if( hInfo[ 'debug' ], 'Yes', 'No' )
	? '---------------------------------'
	? 'Escape for exit...' 	
	
retu nil 

//----------------------------------------------------------------------------//

function AppPathData() ; retu  HB_DIRBASE() + 'data\' 

