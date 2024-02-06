local function toggleColor(color)
  color = color or "ayu"
  vim.cmd.colorscheme(color)

  if toggleColorValue == "opaque" then
    vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
    vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
    toggleColorValue = "transparent"
    return
  end

  if toggleColorValue == "transparent" then
    vim.api.nvim_set_hl(1, "Normal", {bg = "none"})
    vim.api.nvim_set_hl(1, "NormalFloat", {bg = "none"})
    toggleColorValue = "opaque"
    return
  end
  toggleColorValue = "opaque"
end

toggleColor()

vim.keymap.set("n", "<leader>c", function() toggleColor() end)

