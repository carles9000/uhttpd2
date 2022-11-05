#xcommand HTML TO <var> => #pragma __stream|<var> += %s

function web_menu()
	
	//	Security. System access
	
		if ! USessionReady( 'SO' )				
			URedirect( 'login' )
			retu nil	
		endif
		
	//	Go...

		UWrite( DoMenu() )

retu nil 


static function DoMenu()

	local cHtml := ''

	HTML TO cHtml 
	
		<html>	
		<head>
		
			<!--<meta charset="utf-8">--> 
			<meta charset="ISO-8859-1">
			<meta name="viewport" content="width=device-width, initial-scale=1">
			<link rel="shortcut icon" type="image/png" href="files/uhttpd2/images/favicon.ico"/>
			<title>UHttpd2</title>		
		</head>
		
		<body>
		
			<h2>Menu</h2>
				<a href="logout">Logout</a>
			<hr>
			
			<ul>
				<li><a href="order">Order</a></li>
				<li><a href="list">List</a></li>
			</ul>					
		
		</body>
		</html>				
		
	ENDTEXT 


retu cHtml



