return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = {"nvim-lua/plenary.nvim"}
    }, {
        "nvim-tree/nvim-tree.lua",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        tag = "nightly"
    }, {"tpope/vim-fugitive"}, {"tpope/vim-surround"}, {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    }, {"windwp/nvim-ts-autotag"}, {
        "mrjones2014/smart-splits.nvim",
        event = "VeryLazy",
        dependencies = {"pogyomo/submode.nvim"},
        config = function()
            -- Resize
            local submode = require "submode"
            submode.create("WinResize", {
                mode = "n",
                enter = "<leader>r",
                leave = {"<Esc>", "q", "<C-c>"},
                hook = {
                    on_enter = function()
                        vim.notify "Use { h, j, k, l } or { <Left>, <Down>, <Up>, <Right> } to resize the window"
                    end,
                    on_leave = function() vim.notify "" end
                },
                default = function(register)
                    register("h", require("smart-splits").resize_left,
                             {desc = "Resize left"})
                    register("j", require("smart-splits").resize_down,
                             {desc = "Resize down"})
                    register("k", require("smart-splits").resize_up,
                             {desc = "Resize up"})
                    register("l", require("smart-splits").resize_right,
                             {desc = "Resize right"})
                    register("<Left>", require("smart-splits").resize_left,
                             {desc = "Resize left"})
                    register("<Down>", require("smart-splits").resize_down,
                             {desc = "Resize down"})
                    register("<Up>", require("smart-splits").resize_up,
                             {desc = "Resize up"})
                    register("<Right>", require("smart-splits").resize_right,
                             {desc = "Resize right"})
                end
            })
        end
    }, {"ggandor/leap.nvim"}, {"f-person/git-blame.nvim"}, {
        "numToStr/Comment.nvim",
        opts = {
            -- add any options here
        },
        lazy = false
    }, {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = {"BufReadPost", "BufNewFile"},
        opts = {enabled = true, indent = {highlight = {"grey"}, char = {"│"}}},
        config = function(_, opts)
            local hooks = require "ibl.hooks"
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "grey", {fg = "#d3d3d3"})
            end)
            require("ibl").setup(opts)
        end
    }
}
