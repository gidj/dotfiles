local lsp = require('lsp-zero')

lsp.ensure_installed({
    'gopls',
    'jdtls',
    'pyright',
    'rust_analyzer',
    'sumneko_lua',
    'tsserver',
})

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

lsp.preset('lsp-only')
lsp.skip_server_setup({ "jdtls" })
lsp.nvim_workspace({
    library = vim.api.nvim_get_runtime_file('', true)
})

-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" }
}

-- lsp.extend_lspconfig({ capabilities = capabilities })
lsp.setup_nvim_cmp({
    capabilities = capabilities
})

lsp.setup()

local cmp_setup = require('config/cmp')
cmp_setup.setup()
