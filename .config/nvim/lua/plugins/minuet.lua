return {
	{
		"milanglacier/minuet-ai.nvim",
		config = function()
			require("minuet").setup({
				-- Your configuration options here
				provider_options = {
					openai = {
						model = "gpt-5.3-codex-spark",
						end_point = "https://api.openai.com/v1/chat/completions",
						--system = "see [Prompt] section for the default value",
						--few_shots = "see [Prompt] section for the default value",
						--chat_input = "See [Prompt Section for default value]",
						stream = true,
						api_key = "OPENAI_API_KEY",
						optional = {
							-- pass any additional parameters you want to send to OpenAI request,
							-- e.g.
							-- stop = { 'end' },
							-- max_completion_tokens = 256,
							-- top_p = 0.9,
							-- reasoning_effort = 'minimal'
							-- reasoning_effort = 'none'
						},
						-- a list of functions to transform the endpoint, header, and request body
						transform = {},
					},
				},
			})

			require("blink-cmp").setup({
				keymap = {
					-- Manually invoke minuet completion.
					["<A-y>"] = require("minuet").make_blink_map(),
				},
				sources = {
					-- Enable minuet for autocomplete
					default = { "lsp", "path", "buffer", "snippets", "minuet" },
					-- For manual completion only, remove 'minuet' from default
					providers = {
						minuet = {
							name = "minuet",
							module = "minuet.blink",
							async = true,
							-- Should match minuet.config.request_timeout * 1000,
							-- since minuet.config.request_timeout is in seconds
							timeout_ms = 3000,
							score_offset = 50, -- Gives minuet higher priority among suggestions
						},
					},
				},
				-- Recommended to avoid unnecessary request
				completion = { trigger = { prefetch_on_insert = false } },
			})
		end,
	},
	{ "nvim-lua/plenary.nvim" },
	-- optional, if you are using virtual-text frontend, nvim-cmp is not
	-- required.
	-- { "hrsh7th/nvim-cmp" },
	-- optional, if you are using virtual-text frontend, blink is not required.
	{ "Saghen/blink.cmp" },
}
