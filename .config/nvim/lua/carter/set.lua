vim.opt.relativenumber = true
vim.opt.nu = true

-- required for blankline
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.cmd.DoMatchParen = true

vim.opt.guicursor =
"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175"
-- Set copy and and paste to the same register
vim.opt.clipboard = "unnamedplus"

-- Add Date
vim.cmd("command! Date put =strftime('%F')")
vim.api.nvim_command("augroup FormatBeforeSave")
vim.api.nvim_command("au!")
vim.api.nvim_command("augroup END")
