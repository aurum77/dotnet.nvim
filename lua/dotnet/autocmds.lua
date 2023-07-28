local M = {}

-- function M.register_autocmds()
--   -- Disable non-standard semantic tokens coming from omnisharp lsp
--   vim.api.nvim_create_autocmd("LspAttach", {
--     desc = "Fix startup error by disabling semantic tokens for omnisharp",
--     group = vim.api.nvim_create_augroup("OmnisharpHook", {}),
--     callback = function(ev)
--       local client = vim.lsp.get_client_by_id(ev.data.client_id)
--       if client.name == "omnisharp" then
--         client.server_capabilities.semanticTokensProvider = nil
--       end
--     end,
--   })
-- end

function M.register_autocmds()
  local dotnet_group = vim.api.nvim_create_augroup("DotnetGroup", {})
  local dotnet = require "dotnet"

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = dotnet_group,
    pattern = { "*.cs" },
    once = true,
    callback = dotnet.start,
  })

  -- Disable non-standard semantic tokens coming from omnisharp lsp
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Fix startup error by disabling semantic tokens for omnisharp",
    group = dotnet_group,
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client.name == "omnisharp" then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end,
  })
end

return M
