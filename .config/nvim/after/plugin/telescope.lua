local builtin = require("telescope.builtin")
require("telescope").setup { defaults = { preview = { treesitter = false } } }
vim.keymap.set("n", "<leader>sf", builtin.find_files, {})
vim.keymap.set("n", "<leader>sg", builtin.git_files, {})
vim.keymap.set("n", "<leader>ss", builtin.grep_string, {})
vim.keymap.set("n", "<leader>sl", builtin.live_grep, {})
vim.keymap.set("n", "<leader>sb", builtin.buffers, {})
