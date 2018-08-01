" Vim Plug (this has to be the first thing on the init.vim)
call plug#begin()
Plug 'Chiel92/vim-autoformat'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'cloudhead/neovim-fuzzy'
Plug 'dyng/ctrlsf.vim'
Plug 'flazz/vim-colorschemes'
Plug 'junegunn/vim-github-dashboard'
Plug 'kchmck/vim-coffee-script'
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/syntastic'
Plug 'terryma/vim-multiple-cursors'
Plug 'thanethomson/vim-jenkinsfile'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tyru/open-browser.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'edkolev/tmuxline.vim'
call plug#end()

" final settings for color scheme
colorscheme spring-night

let g:airline_theme="papercolor"
let mapleader = " "
map <Leader>\ :NERDTreeToggle<CR>
map <C-S-f> :CtrlSF<space>
nnoremap <CR> :noh<CR><CR>

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" Markdown preview
let vim_markdown_preview_hotkey='<C-m>'

" Other conf
set termguicolors
set showcmd
set autoindent                    " set auto indent
set ts=2                          " set indent to 2 spaces
set expandtab                     " use spaces, not tab characters
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set cursorline                    " highlight current line
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set mouse=a                       " enable mouse support
set vb                            " enable visual bell (disable audio bell)
set ruler                         " show row and column in footer
set laststatus=2                  " always show status bar
set list listchars=tab:»·,trail:· " show extra space characters
"set nofoldenable                  " disable code folding
set foldlevel=1
set foldmethod=syntax
set foldclose=all
set nowrap                        " disable visible word wrap
"set clipboard=unnamed             " use the system clipboard
" Remove trailing whitespace automatically on save
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre :set expandtab<CR> :retab<CR>
" airline
let g:airline_powerline_fonts = 1
let g:airline_powerline_section_b = '%{strftime("%c")}'

set shiftwidth=2 softtabstop=2
set number

" syntax general settings
syntax on
syntax enable

" fuzzy search
nnoremap <C-p> :FuzzyOpen<CR>

" indent guides
let g:indentLine_enabled = 1
let g:indentLine_color_term = 254
let g:indentLine_char = '┆'

" Mouse Support
if has('mouse')
set mouse=a
endif

" split vertical with vv
nnoremap <silent> vv <C-w>v

" Reload files when changed
set autoread
au CursorHold * checktime

filetype plugin on
