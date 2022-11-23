function Test()
	
	UWrite( 'Hello world at ' + time() )
	UWrite( '<br>' )
	UWrite( 'UIsAjax: ' + if( UIsAjax(), 'Yes', 'No' ) )

retu nil
