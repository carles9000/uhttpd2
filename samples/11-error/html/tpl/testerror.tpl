<body style="background-color:aliceblue;">
{{ time() }}

<div class="container-fluid">
	
	<div style="margin-top:" align="center">
{{ dtoc(date() ) }}		
		<img class="logo" src="files/images/mini-httpd2.png" >					
		
	</div>


<?prg	
	public n	:= 0
	
	_d( 'pass1', n )
		A()
	_d( 'pass2', n )
		B()
	_d( 'pass3', n )
		
		
		
		cHtml := 'n = ' + ltrim(str(n))				
	
	retu cHtml 	
		
	function A()
		n:= 5
	retu nil 
	
	function B()
		n := n * 2
	retu nil 	
?> 	

<br>

Valtype:{{ valtype(pvalue(1))  }}	
<br>	
{{ _w(pvalue(1))  }}		
{{ pvalue(1)[ 'margin-top' ]  }}	
<br>	
{{ pvalue(2) }}	
<br>
<!-- {*{ pvalue(1)[ 'fake' ]  }*} -->
	



</div>	
</body>