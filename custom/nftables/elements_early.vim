
if exists('g:nft_did_elements_early')
  finish
endif
let g:nft_did_elements_early = v:true

if exists('b:current_syntax') && b:current_syntax ==# 'nftables'
  finish
endif

let s:filepath_this_script = resolve(expand('<sfile>:p'))
let s:script_dir = expand('<sfile>:p:h')
call nftables#syntax#debug('elements_early.vim: Loading elements_early.vim ...' )

" === For map entries like 1 : 'value' ===
hi link   nft_MapEntry nftHL_Identifier
syn match nft_MapEntry '\v[0-9]{1,10}\s{1,32}:\s{1,32}\".{1,64}\"' contained

" === Clustered list elements ===
syn cluster nft_c_Setelements
\ contains=
\    nft_Number,
\    nft_IP,
\    nft_String,
\    nft_Comma

syn cluster nft_c_Mapelements
\ contains=
\    nft_MapEntry,
\    nft_Comma

syn cluster nft_c_Genericelements
\ contains=
\    nft_Number,
\    nft_String,
\    nft_Comma

" === For map entries like '1 : "value"' ===
syn match nft_MapEntry /\d\+\s*:\s*".*"/ contained

" === Clustered list elements ===
syntax cluster nft_c_Setelements
\ contains=
\    nft_Number,
\    nft_IP,
\    nft_String,
\    nft_Comma

syntax cluster nft_c_Mapelements
\ contains=
\    nft_MapEntry,
\    nft_Comma

syntax cluster nft_c_Genericelements
\ contains=
\    nft_Number,
\    nft_String,
\    nft_Comma

" === Curly blocks for set/map/elements (each with own elements cluster) ===
syn region nft_SetBlock start=/{/ end=/}/ contained
\ contains=
\    @nft_c_Setelements

syn region nft_MapBlock start=/{/ end=/}/ contained
\ contains=
\    @nft_c_Mapelements

syn region nft_elementsBlock start=/{/ end=/}/ contained
\ contains=
\    @nft_c_Genericelements

if exists('nft_debug') && nft_debug == 1
syntax keyword nftKeyword accept drop jump update quota ct
