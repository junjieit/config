return {
  "nvimdev/lspsaga.nvim",

  keys = {
    { "<leader>cb", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Lspsaga diagnostic" },
  },

  opts = {
    diagnostic = {
      max_height = 0.8,
      keys = {
        quit = { "q", "<ESC>" },
      },
    },
  },
}
