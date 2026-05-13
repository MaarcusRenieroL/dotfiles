local opt = vim.opt

-- line numbers
opt.number = true
opt.relativenumber = true

-- tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- search
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8

-- splits
opt.splitright = true
opt.splitbelow = true

-- clipboard
opt.clipboard = "unnamedplus"

-- update time
opt.updatetime = 50

-- cursor line
opt.cursorline = true

-- mouse
opt.mouse = "a"
