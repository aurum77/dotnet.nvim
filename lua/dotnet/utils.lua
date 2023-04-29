local M = {}

local scan = require "plenary.scandir"

function M.tbl_contains_pattern(t, pattern)
  vim.validate { t = { t, "t" } }

  for _, v in ipairs(t) do
    if string.match(v, pattern) then
      return true
    end
  end
  return false
end

function M.cwd_contains_pattern(pattern)
  local dir = scan.scan_dir(".", { hidden = true, depth = 1 })

  local result = M.tbl_contains_pattern(dir, pattern)

  return result
end

return M
