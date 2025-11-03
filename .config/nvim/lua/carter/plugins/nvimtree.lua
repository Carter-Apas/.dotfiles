return {
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override_by_filename = {
        ["Dockerfile.cron"] = {
          icon = "󰡨",
          color = "#2e5f99",
          name = "Anothername"
        }
      }
    }
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup {}
      vim.keymap.set("n", "<leader>sd", vim.cmd.NvimTreeToggle)
      local function open_nvim_tree()
        -- open the tree
        require("nvim-tree.api").tree.open()
      end

      vim.api.nvim_create_autocmd({ "VimEnter" },
        { callback = open_nvim_tree })
    end
  }
}
