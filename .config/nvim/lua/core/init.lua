-- Theming
vim.opt.termguicolors = true
--vim.opt.background = 'light'
vim.g.airline_theme = "papercolor"
vim.g.quantum_italics = true
vim.cmd([[ colorscheme catppuccin-frappe ]])
-- General config
vim.opt.showcmd = true
vim.opt.autoindent = true -- set auto indent
vim.opt.ts = 2 -- set indent to 2 spaces
vim.opt.expandtab = true -- use spaces, not tab characters
vim.opt.showmatch = true -- show bracket matches
vim.opt.ignorecase = true -- ignore case in search
vim.opt.hlsearch = true -- highlight all search matches
vim.opt.smartcase = true -- pay attention to case when caps are used
vim.opt.incsearch = true -- show search results as I type
vim.opt.mouse = "a" -- enable mouse support
vim.opt.vb = true -- enable visual bell (disable audio bell)
vim.opt.ruler = true -- show row and column in footer
vim.opt.laststatus = 2 -- always show status bar
vim.opt.foldlevel = 2
vim.opt.foldnestmax = 10
vim.opt.foldmethod = "indent"
vim.opt.backupcopy = "yes"
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.syntax = "enable"
vim.opt.autoread = true
vim.opt.laststatus = 3
vim.g.root_spec = { "cwd" }
vim.g.neo_tree_change_cwd = 0

-- undotree --
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undolevels = 500
vim.opt.undoreload = 10000

-- indent guides
vim.g.indentLine_enabled = 1
vim.g.indentLine_color_term = 254
vim.g.indentLine_char = "┆"

-- lua does not recognize these:
vim.cmd([[ 
  set nofoldenable
  set nowrap
  set list listchars=tab:»·,trail:·
  highlight Comment cterm=italic
  highlight WinSeparator guibg=none
  set t_ZH=^[[3m
  set t_ZR=^[[23m
  command PrettyJson :%!python -m json.tool
  hi LspDiagnosticsVirtualTextError guifg=red gui=bold,italic,underline
  hi LspDiagnosticsVirtualTextWarning guifg=orange gui=bold,italic,underline
  hi LspDiagnosticsVirtualTextInformation guifg=yellow gui=bold,italic,underline
  hi LspDiagnosticsVirtualTextHint guifg=green gui=bold,italic,underline
]])
