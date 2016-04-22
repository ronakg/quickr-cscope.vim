# quickr-cscope.vim
Vim plugin for super fast Cscope results navigation using quickfix window.

## Features
* Quickly search for symbol, function name, file name under the cursor
* Quickly search for visualy selected text
* Search results are shown in quickfix window, which is way more flexible for navigation compared to Cscope's fixed list
* Find the Cscope database and load automatically on startup

## Installation
* Unpack all files into `~/.vim/` and you're done.

    or

* Use a plugin manager like `vim-plug`, `pathogen` or `vundle` for easier installation and management. 

## Default Keymaps

* `<leader> s`: Search for all symbol occurances of word under the cursor
* `<leader> g`: Search for global definition of the word under the cursor
* `<leader> c`: Search for all callers of the function name under the cursor
* `<leader> f`: Search for all files matching filename under the cursor
* `<leader> i`: Search for all files including filename under the cursor
* `<leader> t`: Search for text matching word under the cursor/visualy selected text
* `<leader> e`: Enter an egrep patter for searching
* `<leader> d`: Search all the functions called by funtion name under the cursor

## Customization

### Disable default keymaps explained above

`let g:quickr_cscope_keymaps=0`

Use following `<plug>`s to your own liking. For example,

`nmap <C-s> <plug>quickr_cscope_symbols`

Other `<plug>`s are:

`
<plug>quickr_cscope_global
<plug>quickr_cscope_callers
<plug>quickr_cscope_symbols
<plug>quickr_cscope_files
<plug>quickr_cscope_includes
<plug>quickr_cscope_text
<plug>quickr_cscope_text
<plug>quickr_cscope_egrep
<plug>quickr_cscope_functions
`

### Disable automatic search and load of cscope database

`let g:quickr_cscope_autoload_db=0`

## License
Copyright (c) Ronak Gandhi. Distributed under the same terms as Vim itself. See
`:help license`
