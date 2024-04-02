vim.g.mapleader = " "

-- Copy and paste
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("n", ">", "gv>")
vim.keymap.set("n", "<", "gv<")

-- Do not yank x
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("v", "x", "\"_x")

-- Do not yank p
vim.keymap.set("n", "p", "p")
vim.keymap.set("v", "p", "P")

-- Ctrl-A select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

-- New lines
vim.keymap.set("n", "o", "o<esc>", {noremap = true})
vim.keymap.set("n", "O", "O<esc>", {noremap = true})

-- set quit console to be also just quit for typos
vim.keymap.set("n", "q:", ":q<CR>")

vim.keymap.set("n", "-", "g_")
vim.keymap.set("v", "-", "g_")

-- Splitting
-- function move down
local function splitHorizontal()
  vim.cmd("split")
  vim.cmd("exe \"normal \\<C-w>j\"")
end

local function splitVertical()
  vim.cmd("vsplit")
  vim.cmd("exe \"normal \\<C-w>l\"")
end

vim.keymap.set("n", "<leader>ws", function() splitHorizontal() end)
vim.keymap.set("n", "<leader>wv", function() splitVertical() end)
vim.keymap.set("n", "<leader>wh", "<C-w>h")
vim.keymap.set("n", "<leader>wj", "<C-w>j")
vim.keymap.set("n", "<leader>wk", "<C-w>k")
vim.keymap.set("n", "<leader>wl", "<C-w>l")
vim.keymap.set("n", "<leader>wH", "<C-w>H")
vim.keymap.set("n", "<leader>wJ", "<C-w>J")
vim.keymap.set("n", "<leader>wK", "<C-w>K")
vim.keymap.set("n", "<leader>wL", "<C-w>L")
vim.keymap.set("n", "<leader>wr", "<C-w>r")
vim.keymap.set("n", "<leader>wq", "<C-w>q")
vim.keymap.set("n", "<leader>wa", vim.cmd.qa)
vim.keymap.set("n", "<leader>w=", "<C-w>=")
-- vim.keymap.set("n", "<leader>w<down>", function() makeSmaller() end)
-- vim.keymap.set("n", "<leader>w<up>", function() makeBigger() end)
-- vim.keymap.set("n", "<leader>w<left>", function() makeHorizontalSmaller() end)
-- vim.keymap.set("n", "<leader>w<right>", function() makeHorizontalBigger() end)
-- Terminal
local function makeTerminalHorizontal()
  splitHorizontal()
  vim.cmd("terminal")
  vim.cmd("exe \"normal i\"")
end

local function makeTerminalVertical()
  splitVertical()
  vim.cmd("terminal")
  vim.cmd("exe \"normal i\"")
end

-- Esc terminal back to normal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Open terminal
vim.keymap.set("n", "<leader>`", function() makeTerminalHorizontal() end)
vim.keymap.set("n", "<leader>~", function() makeTerminalVertical() end)

-- Open Tabs
vim.keymap.set("n", "<leader>tt", ":tabnew<CR>:terminal<CR>i")
vim.keymap.set("n", "<leader>tl", ":+tabnext<CR>")
vim.keymap.set("n", "<leader>th", ":-tabnext<CR>")

-- Move Tabs
vim.keymap.set("n", "<leader>tL", ":tabm +1<CR>")
vim.keymap.set("n", "<leader>tH", ":tabm -1<CR>")

-- File Formatting
local function formatFile()
  local fileType = vim.bo.filetype
  print(vim.bo.filetype)
  if (fileType == "typescript" or fileType == "typescriptreact") then
    vim.cmd("w")
    vim.cmd("!prettier --write %")
    vim.cmd("!npx eslint --fix %")
  end
  if (fileType == "javascript" or fileType == "html" or fileType == "css" or
    fileType == "scss") then
    vim.cmd("w")
    vim.cmd("!prettier --write %")
  end
  if (fileType == "json" or fileType == "jsonc") then
    vim.cmd("w")
    vim.cmd("!fixjson --write %")
  end
  if (fileType == "python") then
    vim.cmd("w")
    vim.cmd("!black --line-length 79 --preview  %")
    vim.cmd("!isort %")
    vim.cmd("!mypy %")
  end
  if (fileType == "terraform") then
    vim.cmd("w")
    vim.cmd("!terraform fmt %")
  end
  if (fileType == "lua") then
    vim.cmd("w")
    vim.cmd("!lua-format -i % -c ~/.config/nvim/lua/carter/luaformat.yml")
  end
  if (fileType == "yaml") then
    vim.cmd("w")
    vim.cmd("!yamlfmt %")
  end
end

vim.keymap.set("n", "<leader>f", formatFile)

local list_snips = function()
  local ft_list = require("luasnip").available()[vim.o.filetype]
  local ft_snips = {}
  for _, item in pairs(ft_list) do ft_snips[item.trigger] = item.name end
  print(vim.inspect(ft_snips))
end

vim.api.nvim_create_user_command("SnipList", list_snips, {})
