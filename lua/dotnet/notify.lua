--@enum
local M = {
  ERROR = vim.log.levels.ERROR,
  DEBUG = vim.log.levels.DEBUG,
  INFO = vim.log.levels.INFO,
  TRACE = vim.log.levels.TRACE,
  WARN = vim.log.levels.WARN,
}

function M.write(msg, level, opts)
  opts = opts or {}
  level = level or M.INFO
  if msg == "" then return end
  vim.notify(msg, level, {
    title = "dotnet.nvim",
    icon = " ",
  })
end

return M
