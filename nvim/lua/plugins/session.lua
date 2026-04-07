return {
    "Shatur/neovim-session-manager",
    dependencies = {"nvim-lua/plenary.nvim"},
    opts = function()
        local config = require('session_manager.config')
        return {
            autoload_mode = config.AutoloadMode.GitSession
        }
    end
}
