return {{
    "FabijanZulj/blame.nvim",
    opts = {
        blame_options = {"e", "w"},
        merge_consecutive = false,
        colors = false,
        blame_format = "{{author}} · {{time | date(format:'%Y-%m-%d')}}",
        virtual_text_column = 1
    },
    keys = {{
        "<leader>gb",
        function()
            require("blame").show()
        end,
        desc = "Toggle Git Blame"
    }}
}}
