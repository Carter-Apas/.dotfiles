return {
  { "rafamadriz/friendly-snippets" },
  { "saadparwaiz1/cmp_luasnip" },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "v2.*",
    build = "make install_jsregexp"
  },
  { "hrsh7th/cmp-nvim-lsp" },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      local s = luasnip.snippet
      local t = luasnip.text_node
      local i = luasnip.insert_node

      luasnip.filetype_extend("typescriptreact", { "javascript" })
      luasnip.filetype_extend("typescriptreact", { "html" })
      luasnip.filetype_extend("typescript", { "javascript" })

      require("luasnip.loaders.from_vscode").lazy_load()

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
            vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)
            :match("%s") == nil
      end
      cmp.setup(
        {
          sources = { { name = "nvim_lsp" }, { name = "luasnip" }, { name = "copilot" } },
          mapping = cmp.mapping.preset.insert(
            {
              -- Enter key confirms completion item
              ["<CR>"] = cmp.mapping.confirm({ select = false }),

              -- Ctrl + space triggers completion menu
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<Tab>"] = cmp.mapping(
                function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                    -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                    -- that way you will only jump inside the snippet region
                  elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                  elseif has_words_before() then
                    cmp.complete()
                  else
                    fallback()
                  end
                end, { "i", "s" }
              ),

              ["<S-Tab>"] = cmp.mapping(
                function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" }
              )
            }
          ),
          snippet = {
            expand = function(args) require("luasnip").lsp_expand(args.body) end
          }
        }
      )
    end
  },
}
