--@enum
local M = {
  ERROR = vim.log.levels.ERROR,
  DEBUG = vim.log.levels.DEBUG,
  INFO = vim.log.levels.INFO,
  TRACE = vim.log.levels.TRACE,
  WARN = vim.log.levels.WARN,
}

function M.write(tbl, level)
  local msg
  level = level or M.INFO
  if type(tbl) == "table" then
    msg = table.concat(tbl, "\n", 1, #tbl)
  end
  -- stylua: ignore
  if msg == "" then return end
  vim.notify(msg, level, {
    title = "dotnet.nvim",
    icon = " ",
  })
end

return M
