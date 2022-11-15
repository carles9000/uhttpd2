#include 'lib\uhttpd2.ch'

function test()

	? 'Time is ' + time() 
	
	? TestDefault()
	? TestDefault( 'pepe', 'mary' )
	
		
	? TestTry()
	

retu nil 

function TestDefault( c, d )

	DEFAULT c := '?'
	DEFAULT d TO '?'

retu 'Hello ' + c + ' & ' + d 

function TestTry()

	local o
	local a
	local c

	TRY
		c := a + 1
	CATCH o 

		c := 'Error: ' + o:description		
	END	
	
retu c 