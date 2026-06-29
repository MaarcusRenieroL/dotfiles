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
opt.grepprg = "rg --vimgrep --smart-case --hidden"
opt.grepformat = "%f:%l:%c:%m"

-- appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true
opt.colorcolumn = "100"
opt.laststatus = 3
opt.pumheight = 12
opt.list = true
opt.listchars = {
	tab = "> ",
	trail = ".",
	nbsp = "+",
}

-- splits
opt.splitright = true
opt.splitbelow = true

-- clipboard
opt.clipboard = "unnamedplus"

-- update time
opt.updatetime = 50
opt.timeoutlen = 500

-- mouse
opt.mouse = "a"

-- backups
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.inccommand = "split"
opt.undofile = true
opt.confirm = true
opt.jumpoptions = "stack"
opt.shortmess:append("c")
