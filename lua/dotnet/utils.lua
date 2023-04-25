local M = {}

function M.tbl_contains_regex(t, pattern)
  vim.validate { t = { t, "t" } }

  for _, v in ipairs(t) do
    if string.match(v, pattern) then
      return true
    end
  end
  return false
end

function M.pwd_contains_sln()
  local scan = require "plenary.scandir"
  local dir = scan.scan_dir(".", { hidden = true, depth = 1 })

  local result = M.tbl_contains_regex(dir, "./*.sln")

  return result
end

return M
