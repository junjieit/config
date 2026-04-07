return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        require('dashboard').setup {
            theme = 'hyper',
            config = {
                week_header = {
                    enable = true
                },
                shortcut = {{
                    desc = '󰊳 Update',
                    group = '@property',
                    action = 'Lazy update',
                    key = 'u'
                }, {
                    desc = 'Session',
                    group = '@property',
                    action = 'SessionManager load_session',
                    key = 's'
                }}
            }
        }
    end,
    dependencies = {{'nvim-tree/nvim-web-devicons'}}
}
