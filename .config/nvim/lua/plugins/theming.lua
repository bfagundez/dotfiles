return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					aerial = true,
					beacon = true,
					mason = true,
					neotree = true,
					noice = true,
					flash = true,
					treesitter = true,
					notify = true,
					lsp_trouble = true,
					telescope = {
						enabled = true,
						-- style = "nvchad"
					},
					gitgutter = true,
					illuminate = {
						enabled = false,
						lsp = false,
					},
					colorful_winsep = {
						enabled = false,
						color = "red",
					},
					mini = {
						enabled = true,
						indentscope_color = "",
					},
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
							ok = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
							ok = { "underline" },
						},
						inlay_hints = {
							background = true,
						},
					},
				},
			})
		end,
	},
}
