/*
 * Harbour 3.2.0dev (r2104281802)
 * Microsoft Visual C 19.27.29112 (64-bit)
 * Generated C source from "app\app.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( MAIN );
HB_FUNC_EXTERN( HB_THREADSTART );
HB_FUNC( WEBSERVER );
HB_FUNC_EXTERN( INKEY );
HB_FUNC_EXTERN( HTTPD2 );
HB_FUNC_EXTERN( QOUT );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_APP )
{ "MAIN", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( MAIN )}, NULL },
{ "HB_THREADSTART", {HB_FS_PUBLIC}, {HB_FUNCNAME( HB_THREADSTART )}, NULL },
{ "WEBSERVER", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( WEBSERVER )}, NULL },
{ "INKEY", {HB_FS_PUBLIC}, {HB_FUNCNAME( INKEY )}, NULL },
{ "HTTPD2", {HB_FS_PUBLIC}, {HB_FUNCNAME( HTTPD2 )}, NULL },
{ "SETPORT", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "ROUTE", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RUN", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "QOUT", {HB_FS_PUBLIC}, {HB_FUNCNAME( QOUT )}, NULL },
{ "CERROR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_APP, "app\\app.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_APP
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_APP )
   #include "hbiniseg.h"
#endif

HB_FUNC( MAIN )
{
	static const HB_BYTE pcode[] =
	{
		36,6,0,176,1,0,108,2,20,1,36,8,0,176,
		3,0,121,12,1,92,27,69,31,244,36,11,0,100,
		110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( WEBSERVER )
{
	static const HB_BYTE pcode[] =
	{
		13,1,0,36,17,0,176,4,0,12,0,80,1,36,
		19,0,48,5,0,95,1,92,81,112,1,73,36,23,
		0,48,6,0,95,1,106,2,47,0,106,11,98,97,
		115,105,99,46,104,116,109,108,0,112,2,73,36,27,
		0,48,7,0,95,1,112,0,31,42,36,29,0,176,
		8,0,106,17,61,62,32,83,101,114,118,101,114,32,
		101,114,114,111,114,58,0,48,9,0,95,1,112,0,
		20,2,36,31,0,122,110,7,36,34,0,121,110,7
	};

	hb_vmExecute( pcode, symbols );
}

