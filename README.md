# quickr-cscope.vim
Vim plugin for super fast Cscope results navigation using quickfix window.

## Features
* Quickly search for symbol, function name, file name under the cursor
* Quickly search for visualy selected text
* Search results are shown in quickfix window, which is way more flexible for navigation compared to Cscope's fixed list
* Find the Cscope database and load automatically on startup

## Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

*  [Pathogen](https://github.com/tpope/vim-pathogen)
  *  `git clone https://github.com/ronakg/quickr-cscope ~/.vim/bundle/quickr-cscope`
*  [NeoBundle](https://github.com/Shougo/neobundle.vim)
  *  `NeoBundle 'ronakg/quickr-cscope'`
*  [Vundle](https://github.com/gmarik/vundle)
  *  `Plugin 'ronakg/quickr-cscope'`
*  [Plug](https://github.com/junegunn/vim-plug)
  *  `Plug 'ronakg/quickr-cscope'`
*  Manual
  *  copy all of the files into your `~/.vim` directory

## Default Keymaps

* **`<leader> s`**: Search for all symbol occurances of word under the cursor
* **`<leader> g`**: Search for global definition of the word under the cursor
* **`<leader> c`**: Search for all callers of the function name under the cursor
* **`<leader> f`**: Search for all files matching filename under the cursor
* **`<leader> i`**: Search for all files including filename under the cursor
* **`<leader> t`**: Search for text matching word under the cursor/visualy selected text
* **`<leader> e`**: Enter an egrep patter for searching
* **`<leader> d`**: Search all the functions called by funtion name under the cursor

## Customization

### Disable default key mappings
If you want to use your own key mappings, you can disable the default key mappings by adding follwing to your `~/.vimrc` file.

**`let g:quickr_cscope_keymaps=0`**

### Define custom key mappings

Use following `<plug>`s to your own liking:

**`<plug>quickr_cscope_symbols`**

**`<plug>quickr_cscope_global`**

**`<plug>quickr_cscope_callers`**

**`<plug>quickr_cscope_symbols`**

**`<plug>quickr_cscope_files`**

**`<plug>quickr_cscope_includes`**

**`<plug>quickr_cscope_text`**

**`<plug>quickr_cscope_egrep`**

**`<plug>quickr_cscope_functions`**

For example:

**`nmap <C-s> <plug>quickr_cscope_symbols`**

### Disable automatic search and load of cscope database
If you're already using another Cscope plugin that loads the database, you can disable this feature of the plugin by adding following to your `~/.vimrc`.

**`let g:quickr_cscope_autoload_db=0`**

## License
Copyright (c) Ronak Gandhi. Distributed under the same terms as Vim itself. See
`:help license`
