" Vim Plug (this has to be the first thing on the init.vim)
call plug#begin()
Plug 'Chiel92/vim-autoformat'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'bling/vim-airline'
Plug 'pangloss/vim-javascript'
Plug 'cloudhead/neovim-fuzzy'
Plug 'craigemery/vim-autotag'
Plug 'dyng/ctrlsf.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'flazz/vim-colorschemes'
Plug 'ggvgc/vim-fuzzysearch'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'terryma/vim-multiple-cursors'
Plug 'thanethomson/vim-jenkinsfile'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-haml'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'kshenoy/vim-signature'
Plug 'justinmk/vim-sneak'
Plug 'jparise/vim-graphql'
Plug 'leafOfTree/vim-vue-plugin'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mattn/emmet-vim'
call plug#end()

" final settings for color scheme
"colorscheme spring-night
colorscheme palenight
set background=dark
let g:airline_theme="luna"
let mapleader = " "
set ttimeoutlen=20
map <Leader>\ :NERDTreeToggle<CR>
map <C-S-f> :CtrlSF<space>
nnoremap <CR> :noh<CR><CR>
"Sorround maps
nnoremap cs ysiw
nnoremap ds ysiy

" closetag extensions
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.vue,*.jsx'
" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'
" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetsDir = '/Users/geekymartian/.codeSnippets/'
let g:UltiSnipsSnippetDirectories = ['/Users/geekymartian/.codeSnippets']

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" Other conf
set termguicolors
set showcmd
set autoindent                    " set auto indent
set ts=2                          " set indent to 2 spaces
set expandtab                     " use spaces, not tab characters
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set mouse=a                       " enable mouse support
set vb                            " enable visual bell (disable audio bell)
set ruler                         " show row and column in footer
set laststatus=2                  " always show status bar
set list listchars=tab:»·,trail:· " show extra space characters
set foldlevel=1
set foldmethod=syntax
set foldclose=all
set nowrap                        " disable visible word wrap
set backupcopy=yes
" Remove trailing whitespace automatically on save
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre :set expandtab<CR> :retab<CR>

" airline
let g:airline_powerline_fonts = 1
let g:airline_powerline_section_b = '%strftime("%c")}'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#ale#enabled = 0
set shiftwidth=2 softtabstop=2
set number

" syntax general settings
syntax on
syntax enable
syntax sync minlines=200

" fuzzy search
nnoremap <C-p> :FuzzyOpen<CR>

" fuzzy search in file
map <Leader>f :FuzzySearch<CR>
let g:fuzzysearch_prompt = '/'

" indent guides
let g:indentLine_enabled = 1
let g:indentLine_color_term = 254
let g:indentLine_char = '┆'

" Ale linting
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 1

" NerdTree
let NERDTreeShowHidden=1

" Mouse Support
if has('mouse')
set mouse=a
endif

" split vertical with vv
nnoremap <silent> vv <C-w>v

" Reload files when changed
set autoread
au CursorHold * checktime

" Custom commands
command PrettyJson :%!python -m json.tool
noremap <f1> :bprev<CR>
noremap <f2> :bnext<CR>
filetype plugin on
