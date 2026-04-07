-- Pretty lsp progress notify
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
        -- ...
    end
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("UserHighlightYank", {
        clear = true
    }),
    callback = function()
        vim.hl.on_yank({
            higroup = "Visual"
        })
    end
})

-- go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("UserLastLoc", {
        clear = true
    }),
    callback = function(event)
        local exclude = {"gitcommit"}
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].user_last_loc then
            return
        end
        vim.b[buf].user_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(buf) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end
})

