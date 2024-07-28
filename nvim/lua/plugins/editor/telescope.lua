return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      {
        "nvim-lua/plenary.nvim"
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      },
      {
        "nvim-telescope/telescope-file-browser.nvim"
      },
    },
    keys = {
      { "<leader>fp", pick, desc = "Projects" },
    },
  }
}