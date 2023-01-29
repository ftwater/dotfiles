"" ### base config ###
set number
set relativenumber
set hlsearch
set ignorecase
set smartcase

"" ### Plugs ###
call plug#begin()
  Plug 'tpope/vim-surround'
  Plug 'vim-airline/vim-airline'
  Plug 'jiangmiao/auto-pairs' 
  Plug 'easymotion/vim-easymotion' 
call plug#end()

"" === base key map ===
"" === no leader key map ===
"" --- nmap ---
"" ;映射为: 进入命令模式
nnoremap ; :
nnoremap nl :nohlsearch<CR>

"" ---imap---
inoremap jk <ESC>


"" ---vmap---
vnoremap jk <ESC> 

"" === leader key map ===
let mapleader=" "
map <Leader> <Plug>(easymotion-prefix)
