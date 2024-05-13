return {
  "jackMort/ChatGPT.nvim",
  keys = "<leader>gc",
  lazy = "true",
  config = function()
    vim.keymap.set("n", "<leader>gc", vim.cmd.ChatGPT)
    local config = {
      api_key_cmd = "op read op://Private/openaiapi/credential --no-newline --account K5ZLIBMCORHLNASER73H3FIM5Y"
    }
    require("chatgpt").setup(config)
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim"
  }
}
