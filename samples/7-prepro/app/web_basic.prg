function TestLoadHtml()

	local hData := { 'name' => 'Charly', 'age' => 55 }
	local cHtml 

	cHtml := ULoadHtml( 'test5.html', hData, time(), date() )
	
	UWrite( cHtml )
	
retu nil 
