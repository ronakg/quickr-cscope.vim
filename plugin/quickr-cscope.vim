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

" s:debug_echo {{
function! s:debug_echo(str)
    if g:quickr_cscope_debug_mode
        echom a:str
    endif
endfunction
" }}

" Options {{
if !exists("g:quickr_cscope_debug_mode")
    let g:quickr_cscope_debug_mode = 0
endif

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

if !exists("g:quickr_cscope_program")
    let g:quickr_cscope_program = "cscope"
endif

if !exists("g:quickr_cscope_db_file")
    let g:quickr_cscope_db_file = "cscope.out"
endif
" }}

" s:autoload_db {{
function! s:autoload_db()
    " Add any database in current directory or any parent
    call s:debug_echo('Looking for the database file: ' . g:quickr_cscope_db_file)
    let db = findfile(g:quickr_cscope_db_file, '.;')

    if !empty(db)
        call s:debug_echo('Database file found at: ' . db)
        let &csprg=g:quickr_cscope_program
        call s:debug_echo('Trying to add the database file for program: ' . g:quickr_cscope_program)
        let root_path = trim(system("git rev-parse --show-toplevel"))
        execute "cs add " . db  . " " . root_path
        return 1
    else
        call s:debug_echo('Database file not found.')
        return 0
    endif
endfunction
" }}

" s:quickr_cscope {{
function! s:quickr_cscope(str, query, vert, cmd)
    echom a:str . a:query . a:vert . a:cmd
    echohl Question

    " Mark this position
    execute "normal! mY"
    " Close any open quickfix windows
    cclose

    if g:quickr_cscope_prompt_length > 0
        if strlen(a:str) <= g:quickr_cscope_prompt_length
            let search_term = input("Enter search term: ", a:str)
        else
            let search_term = a:str
        endif
    endif

    " Clear existing quickfix list
    call setqflist([])

    let cur_file_name=@%
    let view = winsaveview()

    let search_query = a:vert . " " . a:cmd . " find " . a:query . " " . search_term
    silent! keepjumps execute search_query

    let n_results = len(getqflist())

    " Clear previously echoed messages
    echon "\r\r"
    echon "Search complete. Command: '" . search_query . "' returned " . n_results . " results."

    if n_results > 1
        " If the buffer that cscope jumped to is not same as current file, close the buffer
        if cur_file_name != @%
            " Go back to where the command was issued
            execute "normal! `Y"
            " We just jumped back to where the command was issued from. So delete the previous
            " buffer, which will be the buffer quickfix jumped to
            bdelete #
        endif
        call winrestview(view)

        " Open quickfix window
        botright cwindow

        " Search for the query string for easy navigation using n and N in quickfix
        if a:query != "f"
            let @/ = search_term
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
    nnoremap <silent> <plug>(quickr_cscope_global) :call <SID>quickr_cscope(expand("<cword>"), "g", "", "cs")<CR>
    vnoremap <silent> <plug>(quickr_cscope_global) :call <SID>quickr_cscope(<SID>get_visual_selection(), "g", "", "cs")<CR>
    nnoremap <silent> <plug>(quickr_cscope_global_split) :call <SID>quickr_cscope(expand("<cword>"), "g", "", "scs")<CR>
    vnoremap <silent> <plug>(quickr_cscope_global_split) :call <SID>quickr_cscope(<SID>get_visual_selection(), "g", "", "scs")<CR>
    nnoremap <silent> <plug>(quickr_cscope_global_vert_split) :call <SID>quickr_cscope(expand("<cword>"), "g", "vert", "scs")<CR>
    vnoremap <silent> <plug>(quickr_cscope_global_vert_split) :call <SID>quickr_cscope(<SID>get_visual_selection(), "g", "vert", "scs")<CR>
else
    nnoremap <silent> <plug>(quickr_cscope_global) :cs find g <C-R>=expand("<cword>")<CR><CR>
    vnoremap <silent> <plug>(quickr_cscope_global) :<C-U>cs find g <C-R>=<SID>get_visual_selection()<CR><CR>
    nnoremap <silent> <plug>(quickr_cscope_global_split) :scs find g <C-R>=expand("<cword>")<CR><CR>
    vnoremap <silent> <plug>(quickr_cscope_global_split) :<C-U>scs find g <C-R>=<SID>get_visual_selection()<CR><CR>
    nnoremap <silent> <plug>(quickr_cscope_global_vert_split) :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    vnoremap <silent> <plug>(quickr_cscope_global_vert_split) :<C-U>vert scs find g <C-R>=<SID>get_visual_selection()<CR><CR>
endif

nnoremap <silent> <plug>(quickr_cscope_symbols)         :call <SID>quickr_cscope(expand("<cword>"), "s", "", "cs")<CR>
nnoremap <silent> <plug>(quickr_cscope_callers)         :call <SID>quickr_cscope(expand("<cword>"), "c", "", "cs")<CR>
nnoremap <silent> <plug>(quickr_cscope_files)           :call <SID>quickr_cscope(expand("<cfile>:t"), "f", "", "cs")<CR>
nnoremap <silent> <plug>(quickr_cscope_includes)        :call <SID>quickr_cscope(expand("<cfile>:t"), "i", "", "cs")<CR>
nnoremap <silent> <plug>(quickr_cscope_text)            :call <SID>quickr_cscope(expand("<cword>"), "t", "", "cs")<CR>
nnoremap <silent> <plug>(quickr_cscope_functions)       :call <SID>quickr_cscope(expand("<cword>"), "d", "", "cs")<CR>
nnoremap <silent> <plug>(quickr_cscope_egrep)           :call <SID>quickr_cscope(input('Enter egrep pattern: '), "e", "", "cs")<CR>
nnoremap <silent> <plug>(quickr_cscope_assignments)     :call <SID>quickr_cscope(expand("<cword>"), "a", "", "cs")<CR>

vnoremap <silent> <plug>(quickr_cscope_symbols)         :call <SID>quickr_cscope(<SID>get_visual_selection(), "s", "", "cs")<CR>
vnoremap <silent> <plug>(quickr_cscope_callers)         :call <SID>quickr_cscope(<SID>get_visual_selection(), "c", "", "cs")<CR>
vnoremap <silent> <plug>(quickr_cscope_files)           :call <SID>quickr_cscope(<SID>get_visual_selection(), "f", "", "cs")<CR>
vnoremap <silent> <plug>(quickr_cscope_includes)        :call <SID>quickr_cscope(<SID>get_visual_selection(), "i", "", "cs")<CR>
vnoremap <silent> <plug>(quickr_cscope_text)            :call <SID>quickr_cscope(<SID>get_visual_selection(), "t", "", "cs")<CR>
vnoremap <silent> <plug>(quickr_cscope_functions)       :call <SID>quickr_cscope(<SID>get_visual_selection(), "d", "", "cs")<CR>
vnoremap <silent> <plug>(quickr_cscope_egrep)           :call <SID>quickr_cscope(<SID>get_visual_selection(), "e", "", "cs")<CR>
vnoremap <silent> <plug>(quickr_cscope_assignments)     :call <SID>quickr_cscope(<SID>get_visual_selection(), "a", "", "cs")<CR>
" }}

if g:quickr_cscope_keymaps
    nmap <leader>g <plug>(quickr_cscope_global)
    nmap <leader>s <plug>(quickr_cscope_symbols)
    nmap <leader>c <plug>(quickr_cscope_callers)
    nmap <leader>f <plug>(quickr_cscope_files)
    nmap <leader>i <plug>(quickr_cscope_includes)
    nmap <leader>t <plug>(quickr_cscope_text)
    nmap <leader>d <plug>(quickr_cscope_functions)
    nmap <leader>e <plug>(quickr_cscope_egrep)
    nmap <leader>e <plug>(quickr_cscope_assignments)

    vmap <leader>g <plug>(quickr_cscope_global)
    vmap <leader>s <plug>(quickr_cscope_symbols)
    vmap <leader>c <plug>(quickr_cscope_callers)
    vmap <leader>f <plug>(quickr_cscope_files)
    vmap <leader>i <plug>(quickr_cscope_includes)
    vmap <leader>t <plug>(quickr_cscope_text)
    vmap <leader>d <plug>(quickr_cscope_functions)
    vmap <leader>e <plug>(quickr_cscope_egrep)
    vmap <leader>e <plug>(quickr_cscope_assignments)
endif

" Use quickfix window for cscope results. Clear previous results before the search.
if empty(&cscopequickfix)
    if g:quickr_cscope_use_qf_g
        set cscopequickfix=g-,s-,c-,f-,i-,t-,d-,e-,a-
    else
        set cscopequickfix=s-,c-,f-,i-,t-,d-,e-,a-
    endif
endif

" Modeline and Notes {{
" vim: set sw=4 ts=4 sts=4 et tw=99 foldmarker={{,}} foldlevel=10 foldlevelstart=10 foldmethod=marker:
" }}
