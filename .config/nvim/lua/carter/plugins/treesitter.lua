return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({})
    treesitter.install({ "javascript", "typescript", "html", "css", "markdown", "markdown_inline" })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("CarterTreesitter", { clear = true }),
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
        if not lang then
          return
        end

        local function parser_available()
          local ok, loaded = pcall(vim.treesitter.language.add, lang)
          return ok and loaded
        end

        local function attach()
          -- Installation can finish after the buffer is closed or changes filetype.
          if not vim.api.nvim_buf_is_valid(event.buf)
            or vim.treesitter.language.get_lang(vim.bo[event.buf].filetype) ~= lang
            or not parser_available() then
            return
          end
          vim.treesitter.start(event.buf, lang)
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        if parser_available() then
          attach()
        elseif require("nvim-treesitter.parsers")[lang] then
          treesitter.install({ lang }):await(vim.schedule_wrap(attach))
        end
      end,
    })
  end,
  dependencies = { "OXY2DEV/markview.nvim" },
  lazy = false
}
