return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({
            global = false,
          })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      {
        "<leader>bp",
        "<Cmd>BufferLineTogglePin<CR>",
        desc = "Toggle Pin",
      },
      {
        "<leader>bP",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Delete Non-Pinned Buffers",
      },
      {
        "<leader>br",
        "<Cmd>BufferLineCloseRight<CR>",
        desc = "Delete Buffers to the Right",
      },
      {
        "<leader>bl",
        "<Cmd>BufferLineCloseLeft<CR>",
        desc = "Delete Buffers to the Left",
      },
      {
        "<S-h>",
        "<cmd>BufferLineCyclePrev<cr>",
        desc = "Prev Buffer",
      },
      {
        "<S-l>",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "Next Buffer",
      },
      {
        "[b",
        "<cmd>BufferLineCyclePrev<cr>",
        desc = "Prev Buffer",
      },
      {
        "]b",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "Next Buffer",
      },
      {
        "[B",
        "<cmd>BufferLineMovePrev<cr>",
        desc = "Move buffer prev",
      },
      {
        "]B",
        "<cmd>BufferLineMoveNext<cr>",
        desc = "Move buffer next",
      },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = LazyVim.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          return LazyVim.config.icons.ft[opts.filetype]
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local icons = LazyVim.config.icons
      local opts = {

        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "ministarter" },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },

          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = {
                left = 1,
                right = 0,
              },
            },
          },
          lualine_y = {
            {
              "progress",
              separator = " ",
              padding = {
                left = 1,
                right = 0,
              },
            },
            {
              "location",
              padding = {
                left = 0,
                right = 1,
              },
            },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
      }
      return opts
    end,
    extensions = { "neo-tree", "lazy", "fzf" },
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      {
        "<leader>,",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      {
        "<leader>/",
        "<cmd>Telescope live_grep<cr>",
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>:",
        "<cmd>Telescope command_history<cr>",
        desc = "Command History",
      },
      {
        "<leader><space>",
        "<cmd>Telescope find_files<cr>",
        desc = "Find Files (Root Dir)",
      }, -- find
      {
        "<leader>fb",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
        desc = "Buffers",
      },
      {
        "<leader>ff",
        "<cmd>Telescope find_files<cr>",
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fF",
        "<cmd>Telescope find_files root=false<cr>",
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fg",
        "<cmd>Telescope git_files<cr>",
        desc = "Find Files (git-files)",
      },
      {
        "<leader>fr",
        "<cmd>Telescope oldfiles<cr>",
        desc = "Recent",
      },
      {
        "<cmd>Telescope oldfiles cwd=vim.uv.cwd()<cr>",
        desc = "Recent (cwd)",
      }, -- git
      {
        "<leader>gc",
        "<cmd>Telescope git_commits<CR>",
        desc = "Commits",
      },
      {
        "<leader>gs",
        "<cmd>Telescope git_status<CR>",
        desc = "Status",
      }, -- search
      {
        '<leader>s"',
        "<cmd>Telescope registers<cr>",
        desc = "Registers",
      },
      {
        "<leader>sa",
        "<cmd>Telescope autocommands<cr>",
        desc = "Auto Commands",
      },
      {
        "<leader>sb",
        "<cmd>Telescope current_buffer_fuzzy_find<cr>",
        desc = "Buffer",
      },
      {
        "<leader>sc",
        "<cmd>Telescope command_history<cr>",
        desc = "Command History",
      },
      {
        "<leader>sC",
        "<cmd>Telescope commands<cr>",
        desc = "Commands",
      },
      {
        "<leader>sd",
        "<cmd>Telescope diagnostics bufnr=0<cr>",
        desc = "Document Diagnostics",
      },
      {
        "<leader>sD",
        "<cmd>Telescope diagnostics<cr>",
        desc = "Workspace Diagnostics",
      },
      {
        "<leader>sg",
        "<cmd>Telescope live_grep<cr>",
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sG",
        "<cmd>Telescope live_grep root=false<cr>",
        desc = "Grep (cwd)",
      },
      {
        "<leader>sh",
        "<cmd>Telescope help_tags<cr>",
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        "<cmd>Telescope highlights<cr>",
        desc = "Search Highlight Groups",
      },
      {
        "<leader>sj",
        "<cmd>Telescope jumplist<cr>",
        desc = "Jumplist",
      },
      {
        "<leader>sk",
        "<cmd>Telescope keymaps<cr>",
        desc = "Key Maps",
      },
      {
        "<leader>sl",
        "<cmd>Telescope loclist<cr>",
        desc = "Location List",
      },
      {
        "<leader>sM",
        "<cmd>Telescope man_pages<cr>",
        desc = "Man Pages",
      },
      {
        "<leader>sm",
        "<cmd>Telescope marks<cr>",
        desc = "Jump to Mark",
      },
      {
        "<leader>so",
        "<cmd>Telescope vim_options<cr>",
        desc = "Options",
      },
      {
        "<leader>sR",
        "<cmd>Telescope resume<cr>",
        desc = "Resume",
      },
      {
        "<leader>sq",
        "<cmd>Telescope quickfix<cr>",
        desc = "Quickfix List",
      },
    },
  },
  { "sitiom/nvim-numbertoggle" },
  {
    "mikavilpas/yazi.nvim",
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- mark netrw as loaded so it's not loaded at all.
      --
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
