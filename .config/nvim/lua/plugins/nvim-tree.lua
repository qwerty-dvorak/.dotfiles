return {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
        -- Icons configuration
        require('nvim-tree').setup({
            renderer = {
                icons = {
                    glyphs = {
                        default = "", -- nf-cod-file
                        symlink = "", -- nf-oct-file_symlink_file
                        bookmark = "󰆤",
                        folder = {
                            arrow_closed = "", -- nf-oct-chevron_right
                            arrow_open = "", -- nf-oct-chevron_down
                            default = "", -- nf-custom-folder
                            open = "", -- nf-custom-folder_open
                            empty = "", -- nf-fa-folder (empty)
                            empty_open = "", -- nf-fa-folder_open (empty)
                            symlink = "", -- nf-oct-file_symlink_directory
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "✗",
                            staged = "✓",
                            unmerged = "", -- nf-dev-git_merge
                            renamed = "➜",
                            untracked = "★",
                            deleted = "", -- nf-oct-trashcan
                            ignored = "◌",
                        },
                    },
                },
            },
        })

        -- Web-devicons setup
        require('nvim-web-devicons').setup({
            override = {
                txt = {
                    icon = "", -- nf-cod-file
                    color = "#89e051",
                    cterm_color = "113",
                    name = "Txt"
                },
                c = {
                    icon = "", -- nf-seti-c
                    color = "#555555",
                    cterm_color = "59",
                    name = "C"
                },
                cpp = {
                    icon = "", -- nf-seti-cpp
                    color = "#f34b7d",
                    cterm_color = "204",
                    name = "Cpp"
                },
                go = {
                    icon = "", -- nf-seti-go
                    color = "#00acd7",
                    cterm_color = "38",
                    name = "Go"
                },
                js = {
                    icon = "", -- nf-seti-javascript
                    color = "#f1e05a",
                    cterm_color = "185",
                    name = "Js"
                },
                lua = {
                    icon = "", -- nf-seti-lua
                    color = "#51a0cf",
                    cterm_color = "74",
                    name = "Lua"
                },
                html = {
                    icon = "", -- nf-fa-html5
                    color = "#e44d26",
                    cterm_color = "202",
                    name = "Html"
                },
                css = {
                    icon = "", -- nf-fa-css3
                    color = "#563d7c",
                    cterm_color = "60",
                    name = "Css"
                },
                -- Fallback default icon
                default_icon = {
                    icon = "", -- nf-fa-file_text_o
                    color = "#6d8086",
                    cterm_color = "66",
                    name = "Default"
                },
            },
            default = true,
        })
    end
}
