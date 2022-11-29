function web_images( oDom )

	do case
		case oDom:GetProc() == 'prev' 	; DoPrev( oDom )						
		case oDom:GetProc() == 'next' 	; DoNext( oDom )						
		
		otherwise 				
			oDom:SetError( "Proc don't defined => " + oDom:GetProc() )
	endcase
	

retu oDom:Send()	

//	----------------------------------------------------------- //

static function DoPrev( oDom )

	local nId := Val( oDom:Get( 'id' ) )
	local cImage, cFile
	
	nId--
	
	if nId < 1 
		nId := 15
	endif		
	
	cFile	:= 'cara' + ltrim(str(nId)) + '.png'
	cImage	:= 'data/images/' + cFile 
	
	oDom:Set( 'id', nId  )
	oDom:Set( 'filename', cFile  )
	oDom:Set( 'photo', cImage )

retu nil 

//	----------------------------------------------------------- //

static function DoNext( oDom )

	local nId := Val( oDom:Get( 'id' ) )
	local cImage, cFile
	
	nId++
	
	if nId > 15 
		nId := 1
	endif		
	
	cFile	:= 'cara' + ltrim(str(nId)) + '.png'
	cImage	:= 'data/images/' + cFile 
	
	oDom:Set( 'id', nId  )
	oDom:Set( 'filename', cFile  )	
	oDom:Set( 'photo', cImage  )

retu nil 
