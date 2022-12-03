function web_basic( oDom )

	do case
		case oDom:GetProc() == 'exe_search'	; Search( oDom )						
		case oDom:GetProc() == 'exe_clean' 	; oDom:Set( 'info', '' )		
				
		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase
	
return oDom:Send()	

//----------------------------------------------------------------------------//

static function Search( oDom )

	local nRow 	:= val( oDom:Get('register') )
	local cInfo	:= ''
	
	USE ( 'data\test.dbf' ) SHARED NEW

   if nRow > ordKeyCount()
      cInfo := [<div class="alert alert-warning">]
      cInfo += "Entrar registro menor de "+ str( ordKeyCount() )
      cInfo += [</div>]

   elseif nRow == 0
      cInfo := [<div class="alert alert-danger">]
      cInfo += "Entrar un numero de registro correcto"
      cInfo += [</div>]
      
   else
      DbGoto( nRow )
      cInfo := [<div class="alert alert-dark">]
      cInfo += field->first + '<br>' + field->last + '<br>' + field->street 
      cInfo += [</div>]

      oDom:Set( 'notes', field->notes )
      oDom:Set( 'age', field->age )
   endif

	oDom:Set( 'info', cInfo )
	
return NIL 

//----------------------------------------------------------------------------//

function LoadForm()

   local cData := hb_MemoRead( "files/rc/form.json" )

	UAddHeader("Content-Type", "application/json")

return UWrite( cData )

//----------------------------------------------------------------------------//

function SaveForm()

   local hData, cForm, error

   hData := UPost()
   cForm := hb_jsonEncode( hData )
   hb_MemoWrit( "files/rc/form.json", cForm )
   hData := {'status'=>200, 'form'=>hData, 'message'=>"Formulario guardado"}
      
	UAddHeader("Content-Type", "application/json")

return UWrite( hb_jsonEncode(hData) )

//----------------------------------------------------------------------------//