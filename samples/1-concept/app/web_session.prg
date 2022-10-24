function api_Session( oDom )

	do case

		//	Sessions
	
		case oDom:GetProc() == 't1'		; T1( oDom )		
		case oDom:GetProc() == 't2'		; T2( oDom )		
		case oDom:GetProc() == 't3'		; T3( oDom )		
		
		//	Cookies
		
		case oDom:GetProc() == 't10'		; T10( oDom )		
		case oDom:GetProc() == 't10b'		; T10B( oDom )		
		case oDom:GetProc() == 't10c'		; T10C( oDom )		

		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase	

retu oDom:Send()	


//	-------------------------------------------------------------	//

static function T1( oDom )		

	local a := { 'James', 789, .t., date(), { 'name' => 'Mary', 'id' => 777, 'married' => .t., 'date' => date()-1 } }

	USessionStart( 'TEST'  )
	
	USession( 'time', time() )
	USession( 'date', date() )
	USession( 'logic', .t. )
	USession( 'num', 123 )
	USession( 'hash', { 'a'=> hb_milliseconds()} )
	USession( 'complex', a )

	oDom:Set( 'say', 'Session created' + ' ' + str(hb_milliseconds())  )	

retu nil

//	-------------------------------------------------------------	//

static function T2( oDom )		

	if ! USessionStart( 'TEST'  )
		oDom:Set( 'say', 'NO Session!' )
		retu nil	
	endif
	
	USession( 'time', time() )	//	Update var.	
	
	_d( USession( 'time' ) )
	_d( USession( 'date' ) )	
	_d( USession( 'logic' ) )	
	_d( USession( 'num' ) )	
	_d( USession( 'hash' ) )	
	_d( USession( 'complex' ) )	
		
	oDom:Set( 'say', 'Recover data '  + ' ' + str(hb_milliseconds()) + '<hr><pre>' + _w(  USessionAll() ) + '</pre>' )				

retu nil

//	-------------------------------------------------------------	//

static function T3( oDom )	

	if ! USessionStart( 'TEST'  )
		oDom:Set( 'say', 'NO Session!' )
		retu nil	
	endif	

	USessionEnd()	

	oDom:Set( 'say', 'CLOSE!!!' )	

retu nil

//	-------------------------------------------------------------	//

static function T5( oDom )		

	local lOk :=	USessionStart( 'DBU' )
	
	_d( 'T5', lOk )
	
	if USessionEmpty() 
		oDom:SetAlert( 'Session Empty()' )
		retu nil	
	endif

	
	oDom:SetAlert( _w( USessionAll() ) )
	
	

retu nil

//	-------------------------------------------------------------	//

static function T10( oDom )		


	USetCookie( 'TEST10', time() )	
	
	oDom:Set( 'say', 'Cookie was created !'  )	


retu nil


//	-------------------------------------------------------------	//

static function T10B( oDom )		

	local u := UGetCookie( 'TEST10' ) 	

	if empty(u)		
		USetCookie( 'TEST10', '', -1 )	
		oDom:Set( 'say', 'Empty!'  )	
	else
		oDom:Set( 'say', 'Recover cookie value: ' + u + '<br>Milliseconds: ' + str(hb_milliseconds()) )	
	endif	

retu nil

//	-------------------------------------------------------------	//

static function T10C( oDom )		

	USetCookie( 'TEST10', '', -1 )	
	oDom:Set( 'say', 'Deleted Cookie!'  )					

retu nil
