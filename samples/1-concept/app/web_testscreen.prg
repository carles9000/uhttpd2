function Web_TestScreen( oDom )

	do case
		case oDom:GetProc() == 'screen_panel'		; oDom:SetScreen( 'dialog'		, '_container', 'panel' )			
		case oDom:GetProc() == 'screen_dialog'		; oDom:SetScreen( 'dialog'		, '_dialog' )
		case oDom:GetProc() == 'screen_window'		; oDom:SetScreen( 'dialog_win'	, '_window', "width=400,height=200,menubar=no,titlebar=no" )			
				
		otherwise 				
				oDom:SetError( 'No existe Proc: ' + oDom:GetProc() )
	endcase

retu oDom:Send()	

//	------------------------------------------------------------------ //
