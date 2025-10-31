
return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  config = function()
    require("incline").setup({
      highlight = {
        groups = { InclineNormal = { guibg = "#2e3440", guifg = "#a3be8c" } },
      },
      window = { margin = { vertical = 0, horizontal = 1 } },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local modified = vim.bo[props.buf].modified and " ●" or ""
        return { { filename, gui = "bold" }, { modified, guifg = "#ebcb8b" } }
      end,
    })
  end,
}
