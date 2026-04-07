return {{'nvim-telescope/telescope-ui-select.nvim'}, {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    opts = function()
        return {
            extensions = {
                ["ui-select"] = {require("telescope.themes").get_dropdown {
                    -- even more opts
                } -- pseudo code / specification for writing custom displays, like the one
                }
            }
        }
    end
}}
