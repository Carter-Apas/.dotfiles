require("nvim-tree").setup({ view = { side = "left", width = 30 } })

vim.keymap.set("n", "<leader>sd", vim.cmd.NvimTreeToggle)

local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
