local M = {}
local job
local theme = vim.fn.expand("~/.local/bin/theme")

function M.apply()
  local dark = vim.fn.executable(theme) == 1
    and vim.fn.trim(vim.fn.system({ theme, "status" })) == "dark"
  local mode = dark and "dark" or "light"
  if vim.g.colors_name == "ayu" and vim.o.background == mode
      and require("ayu.config").mirage == dark then return end

  vim.g.ayucolor = dark and "mirage" or "light"
  require("ayu.config").mirage = dark
  vim.opt.background = mode
  vim.cmd.colorscheme("ayu")
end

function M.stop()
  if job then
    local previous = job
    job = nil
    vim.fn.jobstop(previous)
  end
end

function M.setup()
  M.stop()
  M.apply()
  local group = vim.api.nvim_create_augroup("DesktopTheme", { clear = true })
  vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = M.stop })
  if vim.fn.executable(theme) == 0 then return end

  local errors = {}
  job = vim.fn.jobstart({ vim.fn.stdpath("config") .. "/scripts/watch-appearance" }, {
    on_stdout = function(id, data)
      if id == job and table.concat(data, "") ~= "" then M.apply() end
    end,
    on_stderr = function(_, data)
      for _, line in ipairs(data) do
        if line ~= "" then table.insert(errors, line) end
      end
    end,
    on_exit = function(id, code)
      if job ~= id then return end
      job = nil
      local detail = #errors > 0 and (": " .. table.concat(errors, "\n")) or ""
      vim.notify("Appearance monitor stopped (exit " .. code .. ")" .. detail, vim.log.levels.WARN)
    end,
  })
  if job <= 0 then
    job = nil
    vim.notify("Could not start appearance monitor", vim.log.levels.WARN)
  end
end

return M
