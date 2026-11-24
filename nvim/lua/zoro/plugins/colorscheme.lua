return {
  {
    "zoro-theme",
    dir = vim.fn.stdpath("config") .. "/colors",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme("zoro")
    end,
  },
}
