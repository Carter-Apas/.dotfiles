local lspconfig = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.api.nvim_create_autocmd(
  "LspAttach", {
    desc = "LSP actions",
    callback = function(event)
      local opts = {buffer = event.buf}

      vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
      vim.keymap
        .set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
      vim.keymap
        .set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
      vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
      vim.keymap
        .set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
      vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
      vim.keymap.set(
        {"n", "x"}, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>",
        opts
      )
      vim.keymap
        .set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

      vim.keymap
        .set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
      vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
      vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
    end
  }
)

local default_setup = function(server)
  lspconfig[server].setup({capabilities = lsp_capabilities})
end

require("mason").setup({})

local registry = require('mason-registry')

  -- These are package names sourced from the Mason registry,
  -- and may not necessarily match the server names used in lspconfig
  local ensure_installed = { "prettier", "fixjson", "html-lsp", "eslint-lsp", "css-lsp", "luaformatter", "pyright", "typescript-language-server", "yamlfmt", "dockerfile-language-server" }

registry.refresh(function()
  for _, name in pairs(ensure_installed) do
    local package = registry.get_package(name)
    if not registry.is_installed(name) then
      package:install()
    else
      package:check_new_version(function(success, result_or_err)
        if success then
          package:install({ version = result_or_err.latest_version })
        end
      end)
    end
  end
end)

require("mason-lspconfig").setup({})
