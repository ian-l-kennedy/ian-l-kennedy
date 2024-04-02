" tabs / spaces / the tab key
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

autocmd FileType make set noexpandtab|set tabstop=4|set softtabstop=4|set shiftwidth=4

set guicursor=
set relativenumber
set scrolloff=15

set list listchars=tab:>\ ,trail:-,eol:«

set colorcolumn=80,100
set number

call plug#begin('~/.vim/plugged')
Plug 'pprovost/vim-ps1'
Plug 'nvim-lua/plenary.nvim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
call plug#end()

if executable('svls')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'svls',
    \ 'cmd': {server_info->['svls']},
    \ 'whitelist': ['systemverilog'],
    \ })
endif