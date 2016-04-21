" quick-cscope.vim:   For superfast Cscope results navigation using quickfix window
" Maintainer:         Ronak Gandhi <https://github.com/ronakg>
" Version:            0.5
" Website:            https://github.com/ronakg/vim-quick-cscope

" Autoload the cscope database
function! s:add_cscope_db()
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

" Fancy s:quick_cscope function {{
function! s:quick_cscope(str, query)
    " Close any open quickfix windows
    cclose

    let l:cur_file_name=@%
    execute "cs find ".a:query." ".a:str
    if l:cur_file_name != @%
        bd
    endif

    " Open quickfix window
    cwindow

    " Store the query string as search pattern for easy navigation
    " using n and N
    let @/ = a:str
endfunction
" }}

if has("cscope")
    set csto=0
    set cst
    set csverb
    set cscopetag       " Use both cscope and ctags as database
    call s:add_cscope_db()

    " Definition
    nnoremap <leader>g :cs find g <cword><CR>
    " Callers
    nnoremap <leader>c :call s:quick_cscope(expand("<cword>"), "c")<CR>
    " Symbols
    nnoremap <leader>s :call s:quick_cscope(expand("<cword>"), "s")<CR>
    " File
    nnoremap <leader>f :call s:quick_cscope(expand("<cfile>:t"), "f")<CR>
    " Files including this file
    nnoremap <leader>i :call s:quick_cscope(expand("<cfile>:t"), "i")<CR>
    nnoremap <leader>t :pop<CR>
    " Don't open the cscope result list of any of the following queries
    set cscopequickfix=s-,c-,i-,t-,e-,f-
endif

" Modeline and Notes {{
" vim: set sw=4 ts=4 sts=4 et tw=99 foldmarker={{,}} foldlevel=10 foldlevelstart=10 foldmethod=marker:
" }}
