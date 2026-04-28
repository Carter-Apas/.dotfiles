for _, lhs in ipairs({ "<C-/>", "<C-_>" }) do
  vim.keymap.set("n", lhs, "gcc", {
    desc = "Toggle comment",
    remap = true,
    silent = true,
  })

  vim.keymap.set("x", lhs, "gc", {
    desc = "Toggle comment",
    remap = true,
    silent = true,
  })
end
