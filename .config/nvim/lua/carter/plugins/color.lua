return {
    {
        "Shatur/neovim-ayu",
        opts = {overrides = {VertSplit = {bg = "None"}}},
        config = function(_, opts)
            require("ayu").setup(opts)
            vim.cmd.colorscheme("ayu")
            vim.opt.background = "light"
        end
    }
}
