-- Wrap interactive shells so :terminal and all terminal keymaps share the prompt.
-- Commands passed through the shell still use the original shell directly.
local wrapper = vim.fn.stdpath("config") .. "/scripts/devcontainer-shell"
vim.env.NVIM_DEVCONTAINER_HOST_SHELL = vim.o.shell
vim.o.shell = wrapper
