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
        ['ui-select'] = {
            require('telescope.themes').get_dropdown {

            }
        }
    }
}

telescope.load_extension('ui-select')
