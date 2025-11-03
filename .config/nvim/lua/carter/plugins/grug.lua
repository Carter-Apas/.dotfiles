return {
    {
        "MagicDuck/grug-far.nvim",
        opts = {
            headerMaxWidth = 80,
            enabledEngines = {"astgrep"},
            engine = "astgrep",
            engines = {
                astgrep = {
                    defaults = {flags = "--strictness=ast"},
                    placeholders = {enabled = true, flags = "yo"}
                }
            }
        },
        config = function(_, opts)
            require("grug-far").setup(opts);
            vim.keymap.set("n", "<leader>sr", ":botright vertical GrugFar<CR>")
        end
    }
}
