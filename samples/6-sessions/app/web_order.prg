function web_order()

		local cHtml 	

	//	Security. System access
	
		if ! USessionReady()				
			URedirect( 'login' )
			retu nil	
		endif
		
	//	Go...
		
		cHtml := hb_memoread( 'html/order.html' )
		
		UWrite( cHtml )

retu nil 