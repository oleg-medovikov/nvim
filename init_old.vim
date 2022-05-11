""====================Плагины===================
call plug#begin('/home/userssh/.config/nvim/plugged')
Plug 'vim-airline/vim-airline' | Plug 'preservim/nerdtree' | Plug 'ap/vim-css-color' "| Plug 'ryanoasis/vim-devicons'
Plug 'tc50cal/vim-terminal' | Plug 'neoclide/coc.nvim'  | Plug 'rafi/awesome-vim-colorschemes'
Plug 'plasticboy/vim-markdown' |  Plug 'morhetz/gruvbox' | Plug 'iberianpig/ranger-explorer.vim'
call plug#end()
""===============================================

nnoremap <space><space> :RangerOpenCurrentDir<CR>




""=====================Горячие клавиши==========
imap ii <esc>:w<enter>
imap 33 #
imap -- —
nnoremap j gj
nnoremap k gk
nmap <pageup> <left>
nmap <pagedown> <right>
""==============================================



"" Автоматически перечитывать конфигурацию VIM после сохранения
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

"Проблема красного на красном при spellchecking-е решается такой строкой в .vimrc
highlight SpellBad ctermfg=Black ctermbg=Red
au BufWinLeave *.* silent mkview " при закрытии файла сохранить 'вид'
au BufWinEnter *.* silent loadview " при открытии - восстановить сохранённый

"" Русский язык
"===================================
set keymap=russian-jcukenwin " настраиваем переключение раскладок клавиатуры по <C-^>
set iminsert=0 " раскладка по умолчанию - английская
set imsearch=0 " аналогично для строки поиска и ввода команд
function! MyKeyMapHighlight()
   if &iminsert == 0 " при английской раскладке статусная строка текущего окна будет серого цвета
      hi StatusLine ctermfg=White guifg=White
   else " а при русской - зеленого.
      hi StatusLine ctermfg=DarkRed guifg=DarkRed
   endif
endfunction
call MyKeyMapHighlight() " при старте Vim устанавливать цвет статусной строки
autocmd WinEnter * :call MyKeyMapHighlight() " при смене окна обновлять информацию о раскладках
"======================================


" плагин NERDTree - дерево каталогов)
map <C-f> :NERDTreeToggle<cr>
vmap <C-f> <esc>:NERDTreeToggle<cr>i
imap <C-f> <esc>:NERDTreeToggle<cr>i

"" Переключение табов (вкладок) (rxvt-style)
map <C-h> :tabprevious<cr>
nmap <C-h> :tabprevious<cr>
imap <C-h> <ESC>:tabprevious<cr>i
map <C-l> :tabnext<cr>
nmap <C-l> :tabnext<cr>
imap <C-l> <ESC>:tabnext<cr>i
nmap <C-t> :tabnew<cr>
imap <C-t> <ESC>:tabnew<cr>

"""=======================

set background=dark
"source ~/.config/nvim/plugged/awesome-vim-colorschemes/colors/gruvbox.vim
source ~/.config/nvim/plugged/gruvbox/colors/gruvbox.vim


set number
set termguicolors
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE
"set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
"set mouse=a
set clipboard=unnamed


set completeopt-=preview

set encoding=UTF-8
set  spell spelllang=ru_yo,en_us


""============= Работа с маркдаун
filetype indent on
autocmd BufEnter *.txt,*.md set filetype=text
autocmd Filetype text setlocal tw=80 wrapmargin=0
autocmd Filetype text setlocal colorcolumn=81
autocmd Filetype text setlocal nolist noai
autocmd Filetype text setlocal expandtab ts=3 sw=3
" Эирлайн
let g:airline_section_b=''
let g:airline_skip_empty_sections=1

hi SpellBad cterm=bold,italic ctermfg=black ctermbg=None
hi SpellCap cterm=None ctermfg=black ctermbg=None
hi SpellRare cterm=None ctermfg=black ctermbg=None
hi SpellLocal cterm=None ctermfg=black ctermbg=None
""==================================


""==============COC

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
