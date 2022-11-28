function MyUpload()
	
	local hPost 	:= UPost()
	local aFiles 	:= UFiles()
	
	//	-----------------------------------------------------------------------
	//	Una vez tenemos los ficheros cargados, conseguiremos un array con 
	//	todas esta información usando la funcion UFiles()
	//	Cada elemento del array corresponde a un fichero que se ha subido y 
	//	esta en la carpeta temporal de nuestra app, por defecto /.tmp 
	//	El registro de cada elemento es un hash con la siguiente informacion:
	//	'Content-type': MIME del fichero
	//	'success'		: File upload .t./.f.
	//	'error'		: message error 
	//	'filename'		: Nombre del fichero
	//	'ext'			: Extension del fichero
	//	'size'			: Tamaño del fichero
	//	'tmp_name'		: Nombre del fichero temporal ubicado en /.tmp
	//
	//	La operación a hacer ahora seria mover, copiar, importar... el fichero
	//	que esta en 'tmp_name' donde quieras ubicarlo
	//
	//	Si creamos una salida a consola -> _d( aFiles ) veremos el contenido
	//	-----------------------------------------------------------------------	
	// 	Once we have the files loaded, we'll get an array with
	// 	all this information using the UFiles() function
	// 	Each element of the array corresponds to a file that has been uploaded and
	// 	is in the temporary folder of our app, by default /.tmp
	// 	The record of each element is a hash with the following information:
	// 	'Content-type': MIME of the file
	//	'success'		: File upload .t./.f.
	//	'error'		: message error 	
	// 	'filename' 	: Name of the file
	// 	'ext' 			: File extension
	// 	'size' 		: Size of the file
	// 	'tmp_name' 	: Name of the temporary file located in /.tmp
	//	
	// 	The operation to do now would be to move, copy, import... the file
	// 	which is in 'tmp_name' where you want to place it
	//	
	// 	If we create a console output -> _d( aFiles ) we will see the content	
	//	-----------------------------------------------------------------------	
	

		//	Procesa ficheros... / Process files...
	
	
	//	-----------------------------------------------------------------------	
	//	A efectos didacticos, devolvemos un hash, con la misma información recibida 
	//	para comprobar que es lo que recibimos en el servidor...
	//	-----------------------------------------------------------------------	
	//	For didactic purposes, we return a hash, with the same information received
	//	to check what we received on the server..	
	//	-----------------------------------------------------------------------	
	
		UAddHeader("Content-Type", "application/json")		
		
		UWrite(  hb_jsonEncode( { 'post' => hPost, 'files' => aFiles } ) )				

retu nil 
