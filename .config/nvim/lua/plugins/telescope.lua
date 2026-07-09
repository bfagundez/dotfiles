return {
  {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      vim.api.nvim_set_keymap(
        'n',
        '<C-p>',
        ':Telescope find_files<CR>',
        {noremap = true})

      require('telescope').setup {
        defaults = {
          file_ignore_patterns = { "node_modules" }
        },
        pickers = {
          find_files = {
            theme = "dropdown",
          }
        },
        extensions = {
          aerial = {
            -- Set the width of the first two columns (the second
            -- is relevant only when show_columns is set to 'both')
            col1_width = 4,
            col2_width = 30,
            -- How to format the symbols
            format_symbol = function(symbol_path, filetype)
              if filetype == "json" or filetype == "yaml" then
                return table.concat(symbol_path, ".")
              else
                return symbol_path[#symbol_path]
              end
            end,
            -- Available modes: symbols, lines, both
            show_columns = "both",
          },
        },
      }
    end
  }

}
