--[[ local lsp_config = require('config/lsp')

lsp_zero.setup()
lsp_zero.set_preferences({
    set_lsp_keymaps = false,
})
lsp_zero.on_attach(lsp_config.on_attach)

local cmp_setup = require('config/cmp')
cmp_setup.setup() ]]
