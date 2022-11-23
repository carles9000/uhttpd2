// -------------------------------------------------- //

function TestError1()

	local A 
	
	a := a + 1		

retu nil

function TestError2()

    LOCAL cHtml 
	LOCAL cFile 	:= 'tpl\testerror.tpl'
	LOCAL hCfg   	:= { 'margin-top' => '50%' , 'background-color' => 'blue' }
	LOCAL cKey 		:= 'ABC-123'
	
	
	cHtml := ULoadHtml( cFile, hCfg, cKey )

	UWrite( cHtml )

retu nil 

function TestError3()

    LOCAL cHtml 
	LOCAL cFile 	:= 'tpl\testerrorprg.tpl'		
	
	cHtml := ULoadHtml( cFile )

	UWrite( cHtml )

retu nil 

function TestError4()

    LOCAL cHtml 
	LOCAL cFile 	:= 'tpl\xxx.tpl'		
	
	cHtml := ULoadHtml( cFile )

	UWrite( cHtml )

retu nil 
