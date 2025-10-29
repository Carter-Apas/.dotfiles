local function diffgetLeft()
  print("Pulling left")
  vim.cmd("diffget //2")
end

local function diffgetRight()
  print("Pulling right")
  vim.cmd("diffget //3")
end

local function gitPush()
  print("Pushing...")
  vim.cmd("Git push")
end

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gp", function() gitPush() end)
vim.keymap.set("n", "<leader>gH", function() diffgetLeft() end)
vim.keymap.set("n", "<leader>gL", function() diffgetRight() end)

vim.api.nvim_command("augroup FugitiveToggle")
vim.api.nvim_command("au!")
vim.api.nvim_command("au Filetype fugitive nnoremap <buffer> <space>gs <C-w>q")
vim.api.nvim_command("augroup END")
