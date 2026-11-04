return {
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    opts = {
      mirage = true,
      overrides = {
        VertSplit = { bg = "None" },
        ["@variable.css"] = { link = "@property" }
      }
    },
    config = function(_, opts)
      require("ayu").setup(opts)
      require("carter.theme").setup()
    end
  }
}
