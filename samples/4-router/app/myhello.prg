#xcommand HTML TO <var> => #pragma __stream|<var> += %s

function MyHello()

	local aRows := {}
	local cHtml

	//	Process data
	
		use ( 'data\test.dbf' ) shared new 
		
		while !eof()
		
			if field->age > 90
		
				Aadd( aRows, { 'first' => field->first, 'last' => field->last, 'age' => field->age } )
				
			endif
			
			dbskip()
		
		end 
		
	//	Prepare Web View
	
		cHtml := DoWeb( aRows )
		
	
	//	Output Web !

		UWrite( cHtml )

retu nil 


static function DoWeb( aRows )

	local cHtml 	:= ''
	local nLen 	:= len( aRows )
	local n
	
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
			<table>
	ENDTEXT 
	
	for n := 1 to nLen 
		
		cHtml += '<tr>'
		cHtml += '<td>' + aRows[n]['first'] + '</td>'
		cHtml += '<td>' + aRows[n]['last'] + '</td>'
		cHtml += '<td>' + str(aRows[n]['age']) + '</td>'
		cHtml += '</tr>'
	
	next 
	
	HTML TO cHtml 		
			</table>
		</body>
	</html>
	ENDTEXT 								
	
RETU cHtml 