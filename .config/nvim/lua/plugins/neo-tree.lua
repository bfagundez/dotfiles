return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			--"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		opts = {
			filesystem = {
				bind_to_cwd = false,
				-- hijack_netrw_behavior = "disabled",
				-- update_focused_file = {
				-- 	enable = true,
				-- 	update_cwd = false,
				-- },
			},
		},
		config = function()
			vim.cmd([[nnoremap \ :Neotree toggle<cr>]])
		end,
	},
}
