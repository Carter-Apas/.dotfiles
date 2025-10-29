vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.docx",
  callback = function()
    local docx_file = vim.fn.expand("%:p")
    local md_file = docx_file:gsub("%.docx$", ".md")
    -- Ensure pandoc is available (a simple check, though pandoc can still fail later)
    if vim.fn.executable("pandoc") == 0 then
      vim.notify(
        "Pandoc is not installed or not in PATH. Cannot convert DOCX.",
        vim.log.levels.ERROR)
      return
    end

    -- 1. Check if the Markdown file already exists. If not, perform conversion.
    if vim.fn.filereadable(md_file) == 0 then
      vim.notify("Converting DOCX to Markdown...", vim.log.levels.INFO)

      -- Command to run: pandoc -s -t markdown_strict "input.docx" -o "output.md"
      -- The use of vim.cmd('silent !...') runs the command externally.
      local cmd = string.format(
        "silent !pandoc -s -t markdown_strict %q -o %q",
        docx_file, md_file)
      vim.cmd(cmd)

      -- Check if the conversion was successful
      if vim.fn.filereadable(md_file) == 0 then
        vim.notify("Pandoc conversion failed.", vim.log.levels.ERROR)
        return
      end
      vim.notify("Conversion complete.", vim.log.levels.INFO)
    end

    -- 2. Open the resulting .md file in the current window (replacing the initial .docx buffer)
    -- This is a clean way to "hijack" the file open process.
    vim.cmd("edit " .. md_file)
    vim.bo.filetype = "markdown"     -- Overwrite filetype to the correct markdown one
    vim.opt_local.buflisted = true
    vim.opt_local.swapfile = true
    vim.bo.modifiable = true
  end
})
