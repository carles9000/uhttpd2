function web_order()

		local cHtml 	

	//	Security. System access
	
		if ! USessionReady( 'SO' )				
			URedirect( 'login' )
			retu nil	
		endif
		
	//	Go...
		
		cHtml := hb_memoread( 'html/order.html' )
		
		UWrite( cHtml )

retu nil 