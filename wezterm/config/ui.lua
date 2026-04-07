local wezterm = require("wezterm")
-- local colors = require("colors.init")
local neapsix = require("colors.neapsix")
local fonts = {"FiraCode Nerd Font", "Fira Code", "Source Code Pro", "JetBrains Mono NL", "JetBrains Mono"}

return {
    animation_fps = 60,
    max_fps = 120,
    front_end = "WebGpu",
    font = wezterm.font(fonts[4]),
    font_size = 12.5,
    webgpu_power_preference = "HighPerformance",
    webgpu_preferred_adapter = wezterm.gui.enumerate_gpus()[1],
    hide_tab_bar_if_only_one_tab = false,
    -- scrollbar
    enable_scroll_bar = true,
    -- tab bar
    enable_tab_bar = false,
    use_fancy_tab_bar = true,
    tab_max_width = 25,
    show_tab_index_in_tab_bar = false, -- 是否显示tab标签数
    switch_to_last_active_tab_when_closing_tab = true,

    colors = neapsix.moon.colors(),
    window_frame = neapsix.moon.window_frame(),
    -- color_scheme = "Nord (Gogh)",
    window_background_opacity = 0.9,

    -- window
    line_height = 1.06, -- 默认上下间距
    window_padding = { -- 四周padding，为0消除边框间距
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    },
    window_close_confirmation = "NeverPrompt",
    inactive_pane_hsb = {
        saturation = 0.9,
        brightness = 0.65
    },
    window_decorations = "NONE",
    default_cursor_style = "BlinkingBar", -- 改变光标形状

    -- from: https://akos.ma/blog/adopting-wezterm/
    hyperlink_rules = { -- Matches: a URL in parens: (URL)
    {
        regex = "\\((\\w+://\\S+)\\)",
        format = "$1",
        highlight = 1
    }, -- Matches: a URL in brackets: [URL]
    {
        regex = "\\[(\\w+://\\S+)\\]",
        format = "$1",
        highlight = 1
    }, -- Matches: a URL in curly braces: {URL}
    {
        regex = "\\{(\\w+://\\S+)\\}",
        format = "$1",
        highlight = 1
    }, -- Matches: a URL in angle brackets: <URL>
    {
        regex = "<(\\w+://\\S+)>",
        format = "$1",
        highlight = 1
    }, -- Then handle URLs not wrapped in brackets
    {
        -- Before
        -- regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
        -- format = '$0',
        -- After
        regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
        format = "$1",
        highlight = 1
    }, -- implicit mailto link
    {
        regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
        format = "mailto:$0"
    }}
}
