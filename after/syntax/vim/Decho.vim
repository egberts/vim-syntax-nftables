" Decho.vim
"   Author: Charles E. Campbell
"   Date:   Apr 18, 2012 - Sep 28, 2018
"   Version: 1a	ASTRO-ONLY
" ---------------------------------------------------------------------
let s:keepcpo      = &cpo
set cpo&vim

if has("conceal")
 syn match	vimTodo contained	'^\s*".*\<D\%(func\|ret\|echo\|redir\|echoBuf\)\s*(.*$' conceal
else
 syn match	vimTodo contained	'^\s*".*\<D\%(func\|ret\|echo\|redir\|echoBuf\)\s*(.*$'
endif

syn keyword vimDbgName		Dfunc Dret Decho DechoFuncName DechoWF DechoOn DechoOff DechoMsgOn DechoMsgOff DechoRemOn DechoRemOff DechoVarOn DechoVarOff DechoTabOn DechoTabOff Dredir DechoBuf containedin=vimFuncBody
syn keyword vimDbgName		Rfunc Rret Recho RechoFuncName RechoWF RechoOn RechoOff RechoMsgOn RechoMsgOff RechoRemOn RechoRemOff RechoVarOn RechoVarOff RechoTabOn RechoTabOff Rredir RechoBuf containedin=vimFuncBody

hi def link vimDbgName	Debug

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
