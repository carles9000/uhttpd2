/*
 * Harbour 3.2.0dev (r2104281802)
 * Microsoft Visual C 19.27.29112 (64-bit)
 * Generated C source from "app\web_basic.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( WEB_BASIC );
HB_FUNC_STATIC( SEARCH );
HB_FUNC_EXTERN( VAL );
HB_FUNC_EXTERN( DBUSEAREA );
HB_FUNC_EXTERN( DBGOTO );


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_WEB_BASIC )
{ "WEB_BASIC", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( WEB_BASIC )}, NULL },
{ "GETPROC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SEARCH", {HB_FS_STATIC | HB_FS_LOCAL}, {HB_FUNCNAME( SEARCH )}, NULL },
{ "SET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SETERROR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "SEND", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "VAL", {HB_FS_PUBLIC}, {HB_FUNCNAME( VAL )}, NULL },
{ "GET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DBUSEAREA", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBUSEAREA )}, NULL },
{ "DBGOTO", {HB_FS_PUBLIC}, {HB_FUNCNAME( DBGOTO )}, NULL },
{ "FIRST", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "LAST", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_WEB_BASIC, "app\\web_basic.prg", 0x0, 0x0003 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_WEB_BASIC
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_WEB_BASIC )
   #include "hbiniseg.h"
#endif

HB_FUNC( WEB_BASIC )
{
	static const HB_BYTE pcode[] =
	{
		13,0,1,36,4,0,48,1,0,95,1,112,0,106,
		11,101,120,101,95,115,101,97,114,99,104,0,8,28,
		11,176,2,0,95,1,20,1,25,91,36,5,0,48,
		1,0,95,1,112,0,106,10,101,120,101,95,99,108,
		101,97,110,0,8,28,22,48,3,0,95,1,106,5,
		105,110,102,111,0,106,1,0,112,2,73,25,46,36,
		8,0,48,4,0,95,1,106,23,80,114,111,99,32,
		100,111,110,39,116,32,100,101,102,105,110,101,100,32,
		61,62,32,0,48,1,0,95,1,112,0,72,112,1,
		73,36,11,0,48,5,0,95,1,112,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_STATIC( SEARCH )
{
	static const HB_BYTE pcode[] =
	{
		13,2,1,36,17,0,176,6,0,48,7,0,95,1,
		106,9,114,101,103,105,115,116,101,114,0,112,1,12,
		1,80,2,36,18,0,106,1,0,80,3,36,20,0,
		176,8,0,120,100,106,14,100,97,116,97,92,116,101,
		115,116,46,100,98,102,0,100,120,9,20,6,36,22,
		0,176,9,0,95,2,20,1,36,24,0,91,10,0,
		106,5,60,98,114,62,0,72,91,11,0,72,80,3,
		36,26,0,48,3,0,95,1,106,5,105,110,102,111,
		0,95,3,112,2,73,36,28,0,100,110,7
	};

	hb_vmExecute( pcode, symbols );
}
