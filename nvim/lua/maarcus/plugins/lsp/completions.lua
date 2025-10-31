return {
  "hrsh7th/cmp-nvim-lsp",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local cmp = require("cmp_nvim_lsp")

    local capabilities = cmp.default_capabilities();

    vim.lsp.config("*", {
      capabilities = capabilities
    })
  end
}
