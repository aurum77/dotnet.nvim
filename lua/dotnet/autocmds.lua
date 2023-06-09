local M = {}

function M.register_autocmds()
  -- Disable non-standard semantic tokens coming from omnisharp lsp
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Fix startup error by disabling semantic tokens for omnisharp",
    group = vim.api.nvim_create_augroup("OmnisharpHook", {}),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client.name == "omnisharp" then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end,
  })
end

return M
