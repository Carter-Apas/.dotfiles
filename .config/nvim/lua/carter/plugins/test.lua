return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {"nvim-lua/plenary.nvim"}
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    tag = "nightly"
  },
  {"williamboman/mason.nvim"},
  {"williamboman/mason-lspconfig.nvim"},
  {"neovim/nvim-lspconfig"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/nvim-cmp"},
  {
    "L3MON4D3/LuaSnip",
    dependencies = {"rafamadriz/friendly-snippets"},
    version = "v2.*",
    build = "make install_jsregexp"
  },
  {"saadparwaiz1/cmp_luasnip"},
  {"rafamadriz/friendly-snippets"},
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"Shatur/neovim-ayu"},
  {"tpope/vim-fugitive"},
  {"tpope/vim-surround"},
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
  {"windwp/nvim-ts-autotag"},
  {"mrjones2014/smart-splits.nvim"},
  {"ggandor/leap.nvim"},
  {"f-person/git-blame.nvim"},
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    lazy = false
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = {"BufReadPost", "BufNewFile"},
    opts = {enabled = true, indent = {highlight = {"grey"}, char = {"│"}}},
    config = function(_, opts)
      local hooks = require "ibl.hooks"
      hooks.register(
        hooks.type.HIGHLIGHT_SETUP,
        function() vim.api.nvim_set_hl(0, "grey", {fg = "#d3d3d3"}) end
      )
      require("ibl").setup(opts)
    end
  }
}
