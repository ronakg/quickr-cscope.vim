" quick-cscope.vim:   For superfast Cscope results navigation using quickfix window
" Maintainer:         Ronak Gandhi <https://github.com/ronakg>
" Version:            1.0
" Website:            https://github.com/ronakg/quickr-cscope.vim

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

if !exists("g:quickr_cscope_use_qf_g")
    let g:quickr_cscope_use_qf_g = 0
endif

if !exists("g:quickr_cscope_prompt_length")
    let g:quickr_cscope_prompt_length = 3
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
        return 1
    else
        return 0
    endif
endfunction
" }}

" s:quickr_cscope {{
function! s:quickr_cscope(str, query)
    if g:quickr_cscope_prompt_length > 0
        if strlen(a:str) <= g:quickr_cscope_prompt_length
            let l:search_term = input("Enter search term: ")
        else
            let l:search_term = a:str
        endif
    endif

    " Mark this position
    execute "normal mc"
    " Close any open quickfix windows
    cclose

    call setqflist([])

    let l:cur_file_name=@%
    echo "Searching for: ".l:search_term
    silent! execute "cs find ".a:query." ".l:search_term

    let l:n_results = len(getqflist())
    echon " - Search returned ". l:n_results . " results."
    if l:n_results > 1
        " If the buffer that cscope jumped to is not same as current file, close the buffer
        if l:cur_file_name != @%
            bd
        else
            " Go back to where the command was issued
            execute "normal! `c"
        endif

        " Open quickfix window
        cwindow

        " Search for the query string for easy navigation using n and N in quickfix
        if a:query != "f"
            execute "normal /".l:search_term."\<CR>"
        endif
    endif
endfunction
" }}

if g:quickr_cscope_autoload_db
    if s:autoload_db() == 0
        finish
    endif
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
if g:quickr_cscope_use_qf_g
    nnoremap <silent> <plug>(quickr_cscope_global)    :call <SID>quickr_cscope(expand("<cword>"), "g")<CR>
else
    nnoremap <silent> <plug>(quickr_cscope_global)    :cs find g <cword><CR>
endif
nnoremap <silent> <plug>(quickr_cscope_symbols)   :call <SID>quickr_cscope(expand("<cword>"), "s")<CR>
nnoremap <silent> <plug>(quickr_cscope_callers)   :call <SID>quickr_cscope(expand("<cword>"), "c")<CR>
nnoremap <silent> <plug>(quickr_cscope_files)     :call <SID>quickr_cscope(expand("<cfile>:t"), "f")<CR>
nnoremap <silent> <plug>(quickr_cscope_includes)  :call <SID>quickr_cscope(expand("<cfile>:t"), "i")<CR>
nnoremap <silent> <plug>(quickr_cscope_text)      :call <SID>quickr_cscope(expand("<cword>"), "t")<CR>
vnoremap <silent> <plug>(quickr_cscope_text)      :call <SID>quickr_cscope(<SID>get_visual_selection(), "t")<CR>
nnoremap <silent> <plug>(quickr_cscope_functions) :call <SID>quickr_cscope(expand("<cword>"), "d")<CR>
nnoremap <silent> <plug>(quickr_cscope_egrep)     :call <SID>quickr_cscope(input('Enter egrep pattern: '), "e")<CR>
" }}

if g:quickr_cscope_keymaps
    nmap <leader>g <plug>(quickr_cscope_global)
    nmap <leader>s <plug>(quickr_cscope_symbols)
    nmap <leader>c <plug>(quickr_cscope_callers)
    nmap <leader>f <plug>(quickr_cscope_files)
    nmap <leader>i <plug>(quickr_cscope_includes)
    nmap <leader>t <plug>(quickr_cscope_text)
    vmap <leader>t <plug>(quickr_cscope_text)
    nmap <leader>d <plug>(quickr_cscope_functions)
    nmap <leader>e <plug>(quickr_cscope_egrep)
endif

" Use quickfix window for cscope results. Clear previous results before the search.
if g:quickr_cscope_use_qf_g
    set cscopequickfix=g-,s-,c-,f-,i-,t-,d-,e-
else
    set cscopequickfix=s-,c-,f-,i-,t-,d-,e-
endif

" Modeline and Notes {{
" vim: set sw=4 ts=4 sts=4 et tw=99 foldmarker={{,}} foldlevel=10 foldlevelstart=10 foldmethod=marker:
" }}
