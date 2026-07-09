return {
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
	},
	{ "alvan/vim-closetag" },
	{
		"dyng/ctrlsf.vim",
		config = function()
			vim.api.nvim_set_keymap("n", "<C-S-f>", ":CtrlSF<space>", { noremap = true })
		end,
	},
	{ "edkolev/tmuxline.vim" },
	{ "kshenoy/vim-signature" },
	{ "prettier/vim-prettier" },
	{ "mattn/vim-gist" },
	{ "mattn/webapi-vim" },
	{ "ryanoasis/vim-devicons" },
	{ "tpope/vim-fugitive" },
	{ "tpope/vim-rhubarb" },
	{ "tpope/vim-sensible" },
	{ "vim-airline/vim-airline-themes" },
	{ "xolox/vim-misc" },
	{ "tpope/vim-abolish" },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({})
		end,
	},
	{
		"APZelos/blamer.nvim",
		config = function()
			vim.g.blamer_enabled = 1
			vim.g.blamer_show_in_visual_modes = 0
			vim.g.blamer_relative_time = 1
		end,
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {
			-- add any custom options here
		},
	},
}
