#xcommand HTML TO <var> => #pragma __stream|<var> += %s

function web_list()

	//	Security. System access
	
		if ! USessionReady( 'SO' )				
			URedirect( 'login' )
			retu nil	
		endif
		
	//	Go...

		UWrite( DoList() )

retu nil 


static function DoList()

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
		
			<h2>List</h2>
				<a href="menu">Menu</a>
				<a href="logout">Logout</a>
			<hr>												
		
		</body>
		</html>				
		
	ENDTEXT 


retu cHtml



