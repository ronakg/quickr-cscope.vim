" quick-cscope.vim:   For superfast Cscope results navigation using quickfix window
" Maintainer:         Ronak Gandhi <https://github.com/ronakg>
" Version:            1.0
" Website:            https://github.com/ronakg/vim-quick-cscope

" Setup {{
if exists("g:quickr_cscope_loaded") || !has("cscope") || !has("quickfix")
  finish
endif
let g:quickr_cscope_loaded = 1
" }}

" Options {{
if !exists("g:quickr_cscope_keymaps")
  let g:quickr_cscope_keymaps = 1
endif

if !exists("g:quickr_cscope_autoload_db")
    let g:quickr_cscope_autoload_db = 1
endif
" }}

" s:autoload_db {{
function! s:autoload_db()
    if !empty($CSCOPE_DB)
        " Add database pointed to by enviorment variable
        let l:db = $CSCOPE_DB
    else
        " Add any database in current directory or any parent
        let l:db = findfile('cscope.out', '.;')
    endif
    if !empty(l:db)
        silent cs reset
        silent! execute 'cs add' l:db
    endif
endfunction
" }}

" s:quick_cscope {{
function! s:quick_cscope(str, query)
    " Close any open quickfix windows
    cclose

    " If the buffer that cscope jumped to is not same as current file, close the buffer
    let l:cur_file_name=@%
    echo "Searching for: ".a:str
    silent! execute "cs find ".a:query." ".a:str
    if l:cur_file_name != @%
        bd
    endif

    " Open quickfix window
    cwindow

    " Search for the query string for easy navigation using n and N in quickfix
    execute "normal /".a:str."\<CR>"
endfunction
" }}

if g:quickr_cscope_autoload_db
    call s:autoload_db()
endif

" s:get_visual_selection {{
" http://stackoverflow.com/a/6271254/777247
function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction
" }}

" Plug mappings {{
nnoremap <silent> <plug>quickr_cscope_global :cs find g <cword><CR>
nnoremap <silent> <plug>quickr_cscope_symbols :call <SID>quick_cscope(expand("<cword>"), "s")<CR>
nnoremap <silent> <plug>quickr_cscope_callers :call <SID>quick_cscope(expand("<cword>"), "c")<CR>
nnoremap <silent> <plug>quickr_cscope_files :call <SID>quick_cscope(expand("<cfile>:t"), "f")<CR>
nnoremap <silent> <plug>quickr_cscope_includes :call <SID>quick_cscope(expand("<cfile>:t"), "i")<CR>
nnoremap <silent> <plug>quickr_cscope_text :call <SID>quick_cscope(expand("<cword>"), "t")<CR>
vnoremap <silent> <plug>quickr_cscope_text :call <SID>quick_cscope(<SID>get_visual_selection(), "t")<CR>
nnoremap <silent> <plug>quickr_cscope_functions :call <SID>quick_cscope(expand("<cword>"), "d")<CR>
nnoremap <silent> <plug>quickr_cscope_egrep :call <SID>quick_cscope(input('Enter egrep pattern: '), "e")<CR>
" }}

if g:quickr_cscope_keymaps
    nmap <leader>g <plug>quickr_cscope_global
    nmap <leader>c <plug>quickr_cscope_callers
    nmap <leader>s <plug>quickr_cscope_symbols
    nmap <leader>f <plug>quickr_cscope_files
    nmap <leader>i <plug>quickr_cscope_includes
    nmap <leader>t <plug>quickr_cscope_text
    vmap <leader>t <plug>quickr_cscope_text
    nmap <leader>e <plug>quickr_cscope_egrep
    nmap <leader>d <plug>quickr_cscope_functions
endif

" Use quickfix window for cscope results. Clear previous results before the search.
set cscopequickfix=t-,c-,i-,s-,e-,f-,d-

" Modeline and Notes {{
" vim: set sw=4 ts=4 sts=4 et tw=99 foldmarker={{,}} foldlevel=10 foldlevelstart=10 foldmethod=marker:
" }}
