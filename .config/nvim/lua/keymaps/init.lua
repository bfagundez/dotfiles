-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.api.nvim_set_keymap('n', [[<CR>]],':noh<CR>',{noremap = true})
vim.api.nvim_set_keymap('n', [[<f1>]],':bprev<CR>',{noremap = true})
vim.api.nvim_set_keymap('n', [[<f2>]],':bnext<CR>',{noremap = true})

