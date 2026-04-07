return {{
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {"lua_ls"}
    },
    dependencies = {{
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    }, {"neovim/nvim-lspconfig"}}
}, {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy"
}, {
    "folke/trouble.nvim",
    cmd = {"Trouble"},
    opts = {
        modes = {
            lsp = {
                win = {
                    position = "right"
                }
            }
        }
    },
    keys = {{
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)"
    }, {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)"
    }, {
        "<leader>cs",
        "<cmd>Trouble symbols toggle<cr>",
        desc = "Symbols (Trouble)"
    }, {
        "<leader>cS",
        "<cmd>Trouble lsp toggle<cr>",
        desc = "LSP references/definitions/... (Trouble)"
    }, {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)"
    }, {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)"
    }, {
        "[q",
        function()
            if require("trouble").is_open() then
                require("trouble").prev({
                    skip_groups = true,
                    jump = true
                })
            else
                local ok, err = pcall(vim.cmd.cprev)
                if not ok then
                    vim.notify(err, vim.log.levels.ERROR)
                end
            end
        end,
        desc = "Previous Trouble/Quickfix Item"
    }, {
        "]q",
        function()
            if require("trouble").is_open() then
                require("trouble").next({
                    skip_groups = true,
                    jump = true
                })
            else
                local ok, err = pcall(vim.cmd.cnext)
                if not ok then
                    vim.notify(err, vim.log.levels.ERROR)
                end
            end
        end,
        desc = "Next Trouble/Quickfix Item"
    }}
}, {
    "stevearc/conform.nvim",
    dependencies = {"mason.nvim"},
    lazy = true,
    cmd = "ConformInfo",
    keys = {{
        "<leader>cf",
        function()
            require("conform").format({
                formatters = {"injected"},
                timeout_ms = 3000
            })
        end,
        mode = {"n", "v"},
        desc = "Format Injected Langs"
    }},
    config = function()
        require("conform").setup {
            formatters_by_ft = {
                lua = {"stylua"},
                -- Conform will run multiple formatters sequentially
                python = {"isort", "black"},
                -- You can customize some of the format options for the filetype (:help conform.format)
                rust = {
                    "rustfmt",
                    lsp_format = "fallback"
                },
                -- Conform will run the first available formatter
                javascript = {
                    -- "prettierd",
                    "prettier",
                    stop_after_first = true
                },
                typescript = {"prettier"},
                javascriptreact = {"prettier"},
                typescriptreact = {"prettier"},
                css = {"prettier"},
                html = {"prettier"},
                json = {"prettier"},
                yaml = {"prettier"},
                markdown = {"prettier"},
                graphql = {"prettier"},
                ["*"] = {"trim_whitespace"}
            },
            format_on_save = {
                -- 启用时保存时自动格式化
                lsp_fallback = true,
                -- 如果有 LSP，使用 LSP 格式化
                async = false,
                -- 同步执行
                timeout_ms = 500
                -- 超时时间
            }
        }
    end
}, {
    "neovim/nvim-lspconfig",
    keys = {{
        "gd",
        function()
            require("telescope.builtin").lsp_definitions({
                reuse_win = true
            })
        end,
        desc = "Goto Definition"
    }, {
        "gr",
        "<cmd>Telescope lsp_references<cr>",
        desc = "References",
        nowait = true
    }, {
        "gI",
        function()
            require("telescope.builtin").lsp_implementations({
                reuse_win = true
            })
        end,
        desc = "Goto Implementation"
    }, {
        "gy",
        function()
            require("telescope.builtin").lsp_type_definitions({
                reuse_win = true
            })
        end,
        desc = "Goto T[y]pe Definition"
    }}
}}
