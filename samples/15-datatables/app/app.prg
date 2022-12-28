//	Autor: Quim

#include 'lib/uhttpd2.ch'

#define VK_ESCAPE	27

REQUEST DBFCDX

function main()

	InitServer() 	
	
	while inkey(0) != VK_ESCAPE
	end

retu nil 

//----------------------------------------------------------------------------//

function InitServer()	
	
	SET DATE TO ITALIAN
	SET DATE FORMAT TO 'DD/MM/YYYY'

	hb_threadStart( @WebServer() )
		
retu nil 

//----------------------------------------------------------------------------//

function WebServer()

	local oServer 	:= UHttpd2New()
	
	oServer:SetPort( 81 )
	oServer:lDebug := .T.
	
	oServer:Route( '/',           'index.html')
	oServer:Route( 'apirest',     'ApiRest' ) 
	oServer:Route( 'collections', 'Collections')
			
	if ! oServer:Run()
		? "=> Server error:", oServer:cError
		return 1
	endif
	
RETURN 0

//----------------------------------------------------------------------------//

function ApiRest()
	
   local hResponse := {=>}
   local cMethod   := UServer('REQUEST_METHOD')

	switch cMethod
		case 'GET' 		; hResponse := DoGet() 		; EXIT
		case 'POST' 	; hResponse := DoPost() 	; EXIT
		case 'PUT' 		; hResponse := DoPut() 		; EXIT
		case 'DELETE' 	; hResponse := DoDelete() 	; EXIT
		otherwise      
         hResponse['error']  := "No se admite : "+ cMethod
         hResponse['status'] := 404
	end

	UAddHeader("Content-Type", "application/json")

return UWrite( hb_jsonencode(hResponse) )

//----------------------------------------------------------------------------//

static function OpenData()

   if !file( 'data\test.cdx' )
      USE ( 'data\test.dbf' ) SHARED NEW VIA 'DBFCDX'
      INDEX ON field->first TAG "first" TO 'data\test'
      INDEX ON field->last TAG "last" TO 'data\test'
      INDEX ON field->age TAG "age" TO 'data\test'
   else 
      USE ( 'data\test.dbf' ) ;
      INDEX ( 'data\test' ) ;
      SHARED NEW VIA 'DBFCDX'
   endif

return NIL 

//----------------------------------------------------------------------------//

static function DoGet()

   local error
   local nCount, nStart, nLimit, nOrder
   local cOrder, cSearch
   local aData     := {}
   local hGet      := UGet()
   local hResponse := { ;
      'status' => 200,  ;
      'data'   => []    ;
   }
   
   TRY
      // Valores que nos envia el plugin datatable y que hay que analizar
      nStart  := val( hGet['start'] )
      nStart  := If( nStart == 0, 1, nStart +1 )
      nLimit  := val( hGet['length'] )
      nOrder  := hb_hGetDef( hGet, "order[0][column]", "0" )  // DT empieza en 0
      nOrder  := val( nOrder ) +1
      cSearch := hb_hGetDef( hGet, "search[value]", "" )

      // Abrir BD, DBF o modelo de datos
      OpenData()
      ordsetfocus(nOrder)

      if empty( cSearch )
         dbgoto( nStart )
      else 
         dbseek( cSearch )
      endif
      
      nCount := 1
      while  ! eof()
      
         if nCount > nLimit
            EXIT 
         endif 

         aadd( aData, { 'first' => field->first, 'last' => field->last, 'age' => field->age } )		
      
         dbskip()
         nCount++
      end

      // Preparar modelo de datos para DataTable
      hResponse['draw']             := hGet['draw']
      hResponse['recordsTotal']     := OrdKeyCount()
      hResponse['recordsFiltered']  := OrdKeyCount()  // de momento
      hResponse['data']             := aData

      // Para debug (saber qué se pide)
      hResponse['get']    := hGet

   CATCH error
      hResponse['error']  := error:description
      hResponse['status'] := 500
   END

return hResponse

//----------------------------------------------------------------------------//
// Reto : a ver quien sabe implementar esto ;)
//----------------------------------------------------------------------------//

static function DoPost()   ; return NIL
static function DoPut()    ; return NIL
static function DoDelete() ; return NIL

//----------------------------------------------------------------------------//
