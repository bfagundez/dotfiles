return {
	{
		"dgagn/diagflow.nvim",
		opts = {
			scope = "cursor",
			show_borders = true,
		},
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
	{ "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
	-- { "hrsh7th/cmp-nvim-lsp" },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					vim.lsp.config(server_name, {})
				end,
			})
		end,
	},
	-- {
	--   'neovim/nvim-lspconfig',
	--   dependencies = { 'saghen/blink.cmp' },
	--
	--   -- example using `opts` for defining servers
	--   opts = {
	--     servers = {
	--       lua_ls = {}
	--     }
	--   },
	--   config = function(_, opts)
	--     local lspconfig = require('lspconfig')
	--     for server, config in pairs(opts.servers) do
	--       -- passing config.capabilities to blink.cmp merges with the capabilities in your
	--       -- `opts[server].capabilities, if you've defined it
	--       config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
	--       lspconfig[server].setup(config)
	--     end
	--   end
	--
	--  -- example calling setup directly for each LSP
	--   config = function()
	--     local capabilities = require('blink.cmp').get_lsp_capabilities()
	--     local lspconfig = require('lspconfig')
	--
	--     lspconfig['lua_ls'].setup({ capabilities = capabilities })
	--   end
	-- },
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	enabled = false,
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	dependencies = {
	-- 		"hrsh7th/cmp-nvim-lsp",
	-- 		{ "antosha417/nvim-lsp-file-operations", config = true },
	-- 	},
	-- 	config = function()
	-- 		local cmp_nvim_lsp = require("cmp_nvim_lsp")
	--
	-- 		vim.opt.signcolumn = "yes"
	--
	-- 		-- Set default capabilities for all LSP servers
	-- 		vim.lsp.config("*", {
	-- 			capabilities = require("cmp_nvim_lsp").default_capabilities(),
	-- 		})
	--
	-- 		-- LSP keymaps
	-- 		vim.api.nvim_create_autocmd("LspAttach", {
	-- 			desc = "LSP actions",
	-- 			callback = function(event)
	-- 				local opts = { buffer = event.buf }
	-- 				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
	-- 				vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
	-- 				vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
	-- 				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
	-- 				vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
	-- 				vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
	-- 				vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
	-- 				vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	-- 				vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
	-- 				vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	-- 			end,
	-- 		})
	-- 	end,
	-- },
}
