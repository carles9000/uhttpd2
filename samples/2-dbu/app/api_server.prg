function api_Server( oDom, oServer )

	do case
		
		case oDom:GetProc() == 'info'			; Info( oDom, oServer )		

		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase	

retu oDom:Send()	


static function Info( oDom, oServer )
	
	
	local hStat	:= UGetServer():Statistics()			
	local hIp 		:= hStat[ 'ip' ]
	local hProc	:= hStat[ 'proc' ]
	local cHtml	:= ''
	local n, aPair 	
	
	cHtml	+= '<div style="width:500;padding:10px">'
	cHtml	+= '<h3><b>Ip access</b></h3>'
	cHtml	+= '<table border="1" width="100%">'
	cHtml 	+= '<tr style="background-color: gray;color: white;font-weight: bold;"><td>Ip</td><td>Times</td><td>Last</td></tr>'
	
	for n := 1 to len( hIp )
	
		aPair := HB_HPairAt( hIp, n )
	
		cHtml += '<tr>'
		cHtml += '<td>' + aPair[1] + '</td><td>' + str(aPair[2][ 'run' ]) + '</td><td>' + aPair[2][ 'last' ] + '</td>'
		cHtml += '</tr>'
	
	next 
	
	cHtml += '</table>'		

	//	PROC
	
	//_d( 'INFO PROC', hProc )
	
	cHtml	+= '<br><hr>'
	cHtml	+= '<h3><b>Proc statistic</b></h3>'
	cHtml	+= '<table border="1" width="100%">'
	cHtml 	+= '<tr style="background-color: gray;color: white;font-weight: bold;"><td>Proc</td><td>Run</td><td>Acum.</td><td>Min</td><td>Max</td></tr>'
	
	for n := 1 to len( hProc )
	
		aPair := HB_HPairAt( hProc, n )
	
		cHtml += '<tr>'
		cHtml += '<td>' + aPair[1] + '</td>' 
		cHtml += '<td style="text-align: center;">' + str(aPair[2][ 'run' ]) + '</td>' 
		cHtml += '<td style="text-align: center;">' + str(aPair[2][ 'time' ]) + '</td>'
		cHtml += '<td style="text-align: center;">' + str(aPair[2][ 'min' ] )  + '</td>'
		cHtml += '<td style="text-align: center;">' + str(aPair[2][ 'max' ])  + '</td>' 
		cHtml += '</tr>'
	
	next 
	
	cHtml += '</table>'			
	cHtml += '</div>'			
	

	oDom:Set( 'info', cHtml )		
	

retu nil

