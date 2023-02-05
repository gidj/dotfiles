local M = {}

local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Helper function for creating keymaps
local function nnoremap(rhs, lhs, bufopts, desc)
    bufopts.desc = desc
    vim.keymap.set("n", rhs, lhs, bufopts)
end


M.setup = function()
    local lsp_zero = require('lsp-zero')

    lsp_zero.ensure_installed({
        'gopls',
        'jdtls',
        'pyright',
        'rust_analyzer',
        'sumneko_lua',
        'tsserver',
    })

    vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

    lsp_zero.preset('lsp-only')
    lsp_zero.skip_server_setup({ "jdtls" })
    lsp_zero.nvim_workspace({
        library = vim.api.nvim_get_runtime_file('', true)
    })

    --[[ -- This MAY NOT actualy have an effect, because of 'lsp-only'
    -- nvim-cmp supports additional completion capabilities
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
    }

    -- lsp.extend_lspconfig({ capabilities = capabilities })
    lsp_zero.setup_nvim_cmp({
        capabilities = capabilities
    }) ]]

    lsp_zero.set_preferences({
        set_lsp_keymaps = false,
    })
    lsp_zero.on_attach(on_attach)
    lsp_zero.setup()
end

M.on_attach = on_attach

M.old = function()
    -- nvim-cmp supports additional completion capabilities
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
    }

    local lspconfig = require("lspconfig")
    local servers = {
        "sumneko_lua",
    }

    for _, lsp in pairs(servers) do
        local opts = {
            settings = {},
            on_attach = on_attach,
            flags = { debounce_text_changes = 150 },
            capabilities = capabilities
        }
        if lsp == "sumneko_lua" then
            local runtime_path = vim.split(package.path, ';')
            table.insert(runtime_path, "lua/?.lua")
            table.insert(runtime_path, "lua/?/init.lua")
            local Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim', 'use' }
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true)
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = { enable = false }
            }
            opts.settings.Lua = Lua
        end
        lspconfig[lsp].setup(opts)
    end
end

return M
