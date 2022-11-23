
function web_ajax( oDom )

do case
	case oDom:GetProc() == 'test1'		; Test_1( oDom )						
	case oDom:GetProc() == 'test2'		; Test_2( oDom )						
	case oDom:GetProc() == 'exe_clean'	; oDom:Set( 'info', '' )
	
	otherwise 				
		oDom:SetError( "Proc don't defined => " + oDom:GetProc())
endcase
	
retu oDom:Send()	

// -------------------------------------------------- //

static function Test_1( oDom )
	
	oDom:Set( 'info', TestAjax() )

retu nil

// -------------------------------------------------- //

static function Test_2( oDom )

	local a
	
	a := A + 1

retu nil
