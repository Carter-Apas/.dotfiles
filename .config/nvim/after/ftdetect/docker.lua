local dockerfile_group = vim.api.nvim_create_augroup(
  "CustomDockerfileDetection", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = dockerfile_group,
  pattern = "*Dockerfile*",
  callback = function() vim.bo.filetype = "dockerfile" end,
  desc = "Sets filetype to 'dockerfile' for any file named *Dockerfile*"
})
