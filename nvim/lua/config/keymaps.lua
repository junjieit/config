local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    local modes = type(mode) == "string" and {mode} or mode

    ---@param m string
    modes = vim.tbl_filter(function(m)
        return not (keys.have and keys:have(lhs, m))
    end, modes)

    -- do not create the keymap if a lazy keys handler exists
    if #modes > 0 then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        if opts.remap and not vim.g.vscode then
            ---@diagnostic disable-next-line: no-unknown
            opts.remap = nil
        end
        vim.keymap.set(modes, lhs, rhs, opts)
    end
end

map('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<cr>', {
    desc = 'Open Texplore'
})
-- windows
map("n", "<leader>-", "<C-W>s", {
    desc = "Split Window Below",
    noremap = false
})
map("n", "<leader>|", "<C-W>v", {
    desc = "Split Window Right",
    noremap = false
})
map("n", "<leader>wd", "<C-W>c", {
    desc = "Delete Window",
    noremap = false
})

-- better up/down
map({"n", "x"}, "j", "v:count == 0 ? 'gj' : 'j'", {
    desc = "Down",
    expr = true,
    silent = true
})
map({"n", "x"}, "<Down>", "v:count == 0 ? 'gj' : 'j'", {
    desc = "Down",
    expr = true,
    silent = true
})
map({"n", "x"}, "k", "v:count == 0 ? 'gk' : 'k'", {
    desc = "Up",
    expr = true,
    silent = true
})
map({"n", "x"}, "<Up>", "v:count == 0 ? 'gk' : 'k'", {
    desc = "Up",
    expr = true,
    silent = true
})

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", {
    desc = "Go to Left Window",
    remap = true
})
map("n", "<C-j>", "<C-w>j", {
    desc = "Go to Lower Window",
    remap = true
})
map("n", "<C-k>", "<C-w>k", {
    desc = "Go to Upper Window",
    remap = true
})
map("n", "<C-l>", "<C-w>l", {
    desc = "Go to Right Window",
    remap = true
})

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", {
    desc = "Increase Window Height"
})
map("n", "<C-Down>", "<cmd>resize -2<cr>", {
    desc = "Decrease Window Height"
})
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", {
    desc = "Decrease Window Width"
})
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", {
    desc = "Increase Window Width"
})

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", {
    desc = "Move Down"
})
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", {
    desc = "Move Up"
})
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", {
    desc = "Move Down"
})
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", {
    desc = "Move Up"
})
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", {
    desc = "Move Down"
})
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", {
    desc = "Move Up"
})

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", {
    desc = "Prev Buffer"
})
map("n", "<S-l>", "<cmd>bnext<cr>", {
    desc = "Next Buffer"
})
map("n", "[b", "<cmd>bprevious<cr>", {
    desc = "Prev Buffer"
})
map("n", "]b", "<cmd>bnext<cr>", {
    desc = "Next Buffer"
})
map("n", "<leader>bb", "<cmd>e #<cr>", {
    desc = "Switch to Other Buffer"
})
map("n", "<leader>`", "<cmd>e #<cr>", {
    desc = "Switch to Other Buffer"
})
map("n", "<leader>bd", "<cmd>bdelete<cr>", {
    desc = "Delete Buffer"
})
map("n", "<leader>bo", "<cmd>%bd[elete]<cr>", {
    desc = "Delete Other Buffers"
})
map("n", "<leader>bD", "<cmd>:bd<cr>", {
    desc = "Delete Buffer and Window"
})

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", {
    desc = "Redraw / Clear hlsearch / Diff Update"
})

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", {
    expr = true,
    desc = "Next Search Result"
})
map("x", "n", "'Nn'[v:searchforward]", {
    expr = true,
    desc = "Next Search Result"
})
map("o", "n", "'Nn'[v:searchforward]", {
    expr = true,
    desc = "Next Search Result"
})
map("n", "N", "'nN'[v:searchforward].'zv'", {
    expr = true,
    desc = "Prev Search Result"
})
map("x", "N", "'nN'[v:searchforward]", {
    expr = true,
    desc = "Prev Search Result"
})
map("o", "N", "'nN'[v:searchforward]", {
    expr = true,
    desc = "Prev Search Result"
})

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({"i", "x", "n", "s"}, "<C-s>", "<cmd>w<cr><esc>", {
    desc = "Save File"
})

-- keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", {
    desc = "Keywordprg"
})

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", {
    desc = "Add Comment Below"
})
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", {
    desc = "Add Comment Above"
})

-- terminal
-- map("n", "<leader>ft", "<cmd>botright new | resize 10 | terminal toggle<cr>", {
--     desc = "Terminal"
-- })
-- map("n", "<leader>sft", "<cmd>vsplit | term<cr>A", {
--     desc = "Terminal (split)"
-- })
map("t", "<Esc>", "<C-\\><C-n>", {
    desc = "Esc insert mode"
})
map("t", "<C-h>", "<Cmd>wincmd h<CR>", {
    desc = "Left"
})
map("t", "<C-j>", "<Cmd>wincmd j<CR>", {
    desc = "Up"
})
map("t", "<C-k>", "<Cmd>wincmd k<CR>", {
    desc = "Down"
})
map("t", "<C-l>", "<Cmd>wincmd l<CR>", {
    desc = "Right"
})
map("t", "<C-w>", "<C-\\><C-n><C-w>", {
    desc = "Close"
})
