return {
    'akinsho/toggleterm.nvim',
    opts = {},
    keys = {{
        "<leader>tt",
        "<Cmd>2TermExec cmd=\"\"<CR>",
        desc = 'Toggle all terminal'
    }, {
        "<leader>ft",
        "<Cmd>ToggleTerm<CR>",
        desc = 'Toggle terminal'
    }, {'<leader>gg', function()
        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new({
            cmd = "lazygit",
            hidden = true,
            dir = "git_dir",
            direction = "float",
            float_opts = {
                border = "double"
            },
            -- function to run on opening the terminal
            on_open = function(term)
                vim.cmd("startinsert!")
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {
                    noremap = true,
                    silent = true
                })
            end
        })
        lazygit:toggle()
    end, {
        desc = 'Toggle LazyGit'
    }}}
}
