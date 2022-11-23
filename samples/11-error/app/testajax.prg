#xcommand HTML TO <var> => #pragma __stream|<var> += %s

function TestAjax()

	local cInfo 
	
	cInfo := 'Version: ' + UVersion()
	cInfo += '<br>Hello world at ' + time() + '<br>IsAjax: ' + if( UIsAjax(), 'Yes', 'No' )
	
	if UIsAjax()
		retu cInfo 
	else
		UWrite( cInfo )	
	endif
	

retu nil
