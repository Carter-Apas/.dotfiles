return {
  { "towolf/vim-helm" },
  { "b0o/schemastore.nvim" },
  {
    "williamboman/mason.nvim",
    dependencies = { "towolf/vim-helm" },
    config = function()
      require("mason").setup()
      local registry = require("mason-registry")

      local versions = { ["eslint-lsp"] = "4.8.0", ["css-lsp"] = "4.8.0" }

      local ensure_installed = {
        "prettier",
        "fixjson",
        "html-lsp",
        "eslint-lsp", -- 4.8.0
        "css-lsp",
        "pyright",
        "typescript-language-server",
        "yamlfmt",
        "dockerfile-language-server",
        "lua-language-server",
        "yaml-language-server",
        "helm-ls",
        "json-lsp",
        "tailwindcss-language-server",
        "terraform-ls",
        "tflint",
        "ruff",
      }

      registry.refresh(
        function()
          for _, name in pairs(ensure_installed) do
            local package = registry.get_package(name)
            local version = versions[name]
            if not registry.is_installed(name) then
              package:install({ version = version or nil })
              goto continue
            elseif version then
              package:install({ version = version })
              goto continue
            end
            package:check_new_version(
              function(success, result_or_err)
                if success then
                  package:install({ version = result_or_err.latest_version })
                end
              end
            )
            ::continue::
          end
        end
      )
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      local default_cap = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup_handlers {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = default_cap,
          }
        end,
        ["eslint"] = function()
          require("lspconfig")["eslint"].setup {
            on_attach = function(_, bufnr)
              vim.api.nvim_create_autocmd(
                "BufWritePre", { buffer = bufnr, command = "EslintFixAll" }
              )
            end
          }
        end,
        ["cssls"] = function()
          require("lspconfig")["cssls"].setup {
            capabilities = capabilities
          }
        end,
        ["lua_ls"] = function()
          require("lspconfig")["lua_ls"].setup {
            settings = { Lua = { diagnostics = { globals = { "vim" } } } }
          }
        end,
        ["jsonls"] = function()
          require("lspconfig")["jsonls"].setup {
            capabilities = capabilities,
            settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true }
              }
            }
          }
        end,
        ["yamlls"] = function()
          require("lspconfig")["yamlls"].setup {
            settings = {
              capabilities = capabilities,
              yaml = {
                schemaStore = { enable = false, url = "" },
                schemas = require("schemastore").yaml.schemas()
              }
            }
          }
        end
      }
    end
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lspconfig")

      vim.api.nvim_create_autocmd(
        "LspAttach", {
          desc = "LSP actions",
          callback = function(event, _)
            local opts = { buffer = event.buf }

            vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
            vim.keymap.set(
              "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts
            )
            vim.keymap.set(
              "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts
            )
            vim.keymap.set(
              "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts
            )
            vim.keymap.set(
              "n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts
            )
            vim.keymap.set(
              "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts
            )
            vim.keymap.set(
              "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts
            )
            vim.keymap
                .set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
            vim.keymap.set(
              { "n", "x" }, "<F3>",
              "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts
            )
            vim.keymap.set(
              "n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts
            )

            vim.keymap.set(
              "n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts
            )
            vim.keymap.set(
              "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts
            )
            vim.keymap.set(
              "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts
            )
            vim.schedule(
              function()
                if vim.lsp.get_client_by_id(event.data.client_id).name ==
                    "yamlls" and vim.bo.filetype == "helm" then
                  vim.lsp.buf_detach_client(event.buf, event.data.client_id)
                end
              end
            )
          end
        }
      )
    end
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup(
        {
          format_on_save = { timeout_ms = 500, lsp_fallback = "always" },
          formatters_by_ft = {
            python = { "ruff" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            javascriptreact = { "prettier" },
            astro = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            json = { "fixjson" },
            jsonc = { "fixjson " },
            yml = { "yamlfmt --formatter retain_line_breaks=true" },
            yaml = { "yamlfmt --formatter retain_line_breaks=true" },
            terraform = { "terraform_fmt" }
          }
        }
      )
    end
  }
}
