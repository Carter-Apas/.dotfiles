return {
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "background",          -- 'background' | 'foreground' | 'virtual'
        enable_hex = true,              -- Highlight #FFFFFF
        enable_short_hex = true         -- Highlight #FFF
      })
    end
  }
}
