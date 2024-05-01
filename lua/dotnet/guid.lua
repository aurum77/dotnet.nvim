local M = {}
local random = math.random

function M.guid()
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  vim.fn.setreg(
    "+",
    string.gsub(template, "[xy]", function(c)
      local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
      return string.format("%x", v)
    end)
  )
end

return M
