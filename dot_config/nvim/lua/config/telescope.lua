local actions = require('telescope.actions')
local telescope = require("telescope")
telescope.setup {
    defaults = {
        mappings = {
            n = {
                ["q"] = actions.close
            },
            i = {
                ["<esc>"] = actions.close
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        ['ui-select'] = {
            require('telescope.themes').get_dropdown {

            }
        },
        undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
                preview_height = 0.8,
            }
        }
    }
}

telescope.load_extension('ui-select')
telescope.load_extension('undo')
