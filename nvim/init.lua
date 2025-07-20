-- global variables

local opt = vim.opt
local k = vim.keymap.set

vim.g.mapleader = " "

-- base options for neovim

opt.relativenumber = true
opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false

-- global shortcuts

k("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
k("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
k("n", "<leader>se", "<C-w>=", { desc = "Make splits of equal size" })
k("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split window" })

-- Formatting and linting shortcuts
k("n", "<leader>lf", "<cmd>Format<CR>", { desc = "Format current buffer" })
k("n", "<leader>lF", "<cmd>FormatWrite<CR>", { desc = "Format and write current buffer" })
k("n", "<leader>ld", "<cmd>NullLsInfo<CR>", { desc = "Show null-ls info" })
k("n", "<leader>la", "<cmd>CodeActionMenu<CR>", { desc = "Show code actions" })

-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

-- Setup lazy.nvim

require("lazy").setup({
	spec = {
		-- add your plugins here

		-- core infrastructure

		{ "nvim-lua/plenary.nvim" },

		-- navigation

		{

			-- nvim tree

			{
				"nvim-tree/nvim-tree.lua",
				version = "*",
				lazy = false,
				dependencies = {
					"nvim-tree/nvim-web-devicons",
				},
				config = function()
					local nvimtree = require("nvim-tree")

					vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])

					vim.g.loaded_netrw = 1
					vim.g.loaded_netrwPlugin = 1

					nvimtree.setup({
						view = {
							width = 45,
							relativenumber = true,
							cursorline = true,
						},
						renderer = {
							indent_markers = {
								enable = true,
							},
							icons = {
								show = {
									file = true,
									folder = true,
									folder_arrow = true,
									git = true,
								},
								glyphs = {
									default = "󰈚",
									symlink = "",
									folder = {
										default = "",
										empty = "",
										empty_open = "",
										open = "",
										symlink = "",
										symlink_open = "",
										arrow_open = "",
										arrow_closed = "",
									},
									git = {
										unstaged = "✗",
										staged = "✓",
										unmerged = "",
										renamed = "➜",
										untracked = "★",
										deleted = "",
										ignored = "◌",
									},
								},
							},
						},
						actions = {
							open_file = {
								window_picker = {
									enable = false,
								},
							},
						},
						filters = {
							custom = { ".DS_Store" },
						},
						git = {
							ignore = false,
						},
					})

					k("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
					k(
						"n",
						"<leader>ef",
						"<cmd>NvimTreeFindFileToggle<CR>",
						{ desc = "Toggle file explorer on current file" }
					)
					k("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
				end,
			},

			-- telescope

			{
				"nvim-telescope/telescope.nvim",
				tag = "0.1.6",
				dependencies = { "nvim-lua/plenary.nvim" },
				config = function()
					require("telescope").setup({
						defaults = {
							layout_strategy = "vertical",
							layout_config = {
								horizontal = {
									prompt_position = "top",
								},
							},
							sorting_strategy = "ascending",
						},
					})

					k("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
					k("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
				end,
			},
		},

		-- coding

		{

			-- lsp

			{
				"nvim-java/nvim-java",
				config = false,
				dependencies = {
					{
						"neovim/nvim-lspconfig",
						opts = {
							setup = {
								jdtls = function()
									require("java").setup({})
								end,
							},
						},
					},
				},
			},

			{
				"williamboman/mason.nvim",
				lazy = false,
				config = function()
					require("mason").setup()
				end,
			},

			{
				"williamboman/mason-lspconfig.nvim",
				lazy = false,
			},

			{
				"neovim/nvim-lspconfig",
				lazy = false,
				config = function()
					local capabilities = require("cmp_nvim_lsp").default_capabilities()

					local lspconfig = require("lspconfig")

					-- Helper function to safely setup LSP servers
					local function setup_lsp(server_name, config)
						local ok, _ = pcall(function()
							lspconfig[server_name].setup(config or { capabilities = capabilities })
						end)
						if not ok then
							vim.notify("Failed to setup " .. server_name .. " LSP", vim.log.levels.WARN)
						end
					end

					-- Setup LSP servers
					setup_lsp("tailwindcss")
					setup_lsp("html")
					setup_lsp("cssls")
					setup_lsp("lua_ls")
					setup_lsp("ts_ls")
					setup_lsp("angularls")

					-- Special setup for Java
					setup_lsp("jdtls", {
						capabilities = capabilities,
						cmd = {
							"jdtls",
							"--jvm-arg=" .. string.format("-javaagent:%s", vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"),
						},
					})
				end,
			},

			-- auto complete

			{
				"hrsh7th/cmp-nvim-lsp",
			},

			{
				"L3MON4D3/LuaSnip",
				dependencies = {
					"saadparwaiz1/cmp_luasnip",
					"rafamadriz/friendly-snippets",
				},
			},

			{
				"hrsh7th/nvim-cmp",
				config = function()
					local cmp = require("cmp")
					require("luasnip.loaders.from_vscode").lazy_load()

					local options = {
						snippet = {
							expand = function(args)
								require("luasnip").lsp_expand(args.body)
							end,
						},
						window = {
							completion = cmp.config.window.bordered(),
							documentation = cmp.config.window.bordered(),
						},
						mapping = cmp.mapping.preset.insert({
							["<C-b>"] = cmp.mapping.scroll_docs(-4),
							["<C-f>"] = cmp.mapping.scroll_docs(4),
							["<C-Space>"] = cmp.mapping.complete(),
							["<C-e>"] = cmp.mapping.abort(),
							["<CR>"] = cmp.mapping.confirm({ select = true }),
						}),
						sources = cmp.config.sources({
							{ name = "nvim_lsp" },
							{ name = "path" },
							{ name = "luasnip" }, -- For luasnip users.
						}, {
							{ name = "buffer" },
						}),
					}

					cmp.setup(options)
				end,
			},

			-- formatting and linting

			{
				"stevearc/conform.nvim",
				event = { "BufReadPre", "BufNewFile" },
				config = function()
					local conform = require("conform")

					conform.setup({
						formatters_by_ft = {
							-- Web technologies
							javascript = { "prettier", "eslint_d" },
							typescript = { "prettier", "eslint_d" },
							javascriptreact = { "prettier", "eslint_d" },
							typescriptreact = { "prettier", "eslint_d" },
							jsx = { "prettier", "eslint_d" },
							tsx = { "prettier", "eslint_d" },
							css = { "prettier", "stylelint" },
							scss = { "prettier", "stylelint" },
							sass = { "prettier", "stylelint" },
							less = { "prettier", "stylelint" },
							html = { "prettier", "htmlbeautifier" },
							htmldjango = { "prettier", "htmlbeautifier" },

							-- JSON and config files
							json = { "prettier", "jsonlint" },
							jsonc = { "prettier" },
							yaml = { "prettier", "yamllint" },
							yml = { "prettier", "yamllint" },
							toml = { "taplo" },

							-- Markup and documentation
							markdown = { "prettier", "markdownlint" },
							md = { "prettier", "markdownlint" },
							rst = { "rstfmt" },

							-- Database and ORM
							sql = { "sqlformat" },
							prisma = { "prisma-fmt" },

							-- Programming languages
							lua = { "stylua" },
							python = { "isort", "black", "ruff" },
							java = { "google-java-format", "checkstyle" },
							rust = { "rustfmt" },
							go = { "gofmt", "goimports" },
							c = { "clang_format" },
							cpp = { "clang_format" },
							csharp = { "csharpier" },
							php = { "php_cs_fixer" },
							ruby = { "rubocop" },
							scala = { "scalafmt" },
							kotlin = { "ktlint" },

							-- Shell and config
							sh = { "shfmt", "shellcheck" },
							bash = { "shfmt", "shellcheck" },
							zsh = { "shfmt", "shellcheck" },
							fish = { "fish_indent" },
							dockerfile = { "hadolint" },
							make = { "make" },

							-- GraphQL
							graphql = { "prettier" },
							gql = { "prettier" },
						},
						format_on_save = {
							timeout_ms = 3000,
							lsp_fallback = true,
						},
						notify_on_error = true,
						formatters = {
							-- Custom formatter configurations
							prettier = {
								prepend_args = {
									"--print-width=100",
									"--tab-width=2",
									"--use-tabs=false",
									"--semi=true",
									"--single-quote=true",
									"--trailing-comma=es5",
									"--bracket-spacing=true",
									"--bracket-same-line=false",
									"--arrow-parens=avoid",
								},
							},
							eslint_d = {
								prepend_args = { "--fix" },
							},
							stylelint = {
								prepend_args = { "--fix" },
							},
							black = {
								prepend_args = { "--line-length=100" },
							},
							ruff = {
								prepend_args = { "--fix" },
							},
							google_java_format = {
								prepend_args = { "--aosp" },
							},
						},
					})
				end,
			},

			-- indent line

			{
				"lukas-reineke/indent-blankline.nvim",
				main = "ibl",
				---@module "ibl"
				---@type ibl.config
				opts = {},
				config = function()
					local highlight = {
						"RainbowRed",
						"RainbowYellow",
						"RainbowBlue",
						"RainbowOrange",
						"RainbowGreen",
						"RainbowViolet",
						"RainbowCyan",
					}

					local hooks = require("ibl.hooks")
					-- create the highlight groups in the highlight setup hook, so they are reset
					-- every time the colorscheme changes
					hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
						vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
						vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
						vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
						vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
						vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
						vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
						vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
					end)

					require("ibl").setup({ indent = { highlight = highlight } })
				end,
			},
		},

		-- treesitter

		{
			"nvim-treesitter/nvim-treesitter",
			event = { "BufReadPost", "BufNewFile" },
			cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
			build = ":TSUpdate",
			config = function(_, opts)
				require("nvim-treesitter").setup({
					automatic_installation = true,

					highlight = {
						enable = true,
						use_languagetree = true,
					},

					indent = { enable = true },
				})
			end,
		},

		-- ui

		{
			{
				"projekt0n/github-nvim-theme",
				name = "github-theme",
				lazy = false, -- make sure we load this during startup if it is your main colorscheme
				priority = 1000, -- make sure to load this before all the other start plugins
				config = function()
					require("github-theme").setup({
						-- ...
					})

					vim.cmd("colorscheme github_light_default")
				end,
			},

			{
				"nvim-lualine/lualine.nvim",
				config = function()
					require("lualine").setup({
						options = {
							icons_enabled = true,
							component_separators = { left = "", right = "" },
							section_separators = { left = "", right = "" },
							disabled_filetypes = { "NvimTree", "lazy", "alpha" },
							always_divide_middle = true,
							globalstatus = true,
						},

						sections = {
							lualine_a = { { "mode", icon = "" } },
							lualine_b = {
								{ "branch", icon = "" },
								{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
								{
									"diagnostics",
									sources = { "nvim_diagnostic" },
									symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
								},
							},
							lualine_c = {
								{
									"filename",
									path = 1, -- 0 = name, 1 = relative, 2 = absolute
									symbols = {
										modified = " [+]",
										readonly = " ",
										unnamed = "[No Name]",
									},
								},
							},

							lualine_x = {
								{
									function()
										local msg = require("lsp-status").status()
										return #msg > 0 and msg or ""
									end,
									icon = " LSP:",
									cond = function()
										return vim.tbl_count(vim.lsp.get_active_clients()) > 0
									end,
								},
								{
									function()
										local ok, noice = pcall(require, "noice")
										return ok and noice.api.status.mode.get() or ""
									end,
									cond = function()
										local ok, noice = pcall(require, "noice")
										return ok and noice.api.status.mode.has()
									end,
									color = { fg = "#ff9e64" },
								},
								{ "encoding" },
								{
									"fileformat",
									icons_enabled = true,
									symbols = { unix = "", dos = "", mac = "" },
								},
								{ "filetype", icon_only = true },
							},

							lualine_y = { "progress" },
							lualine_z = { { "location", icon = "" } },
						},

						inactive_sections = {
							lualine_a = {},
							lualine_b = {},
							lualine_c = {
								{
									"filename",
									path = 1,
									symbols = { modified = " [+]", readonly = " ", unnamed = "[No Name]" },
								},
							},
							lualine_x = { "location" },
							lualine_y = {},
							lualine_z = {},
						},

						tabline = nil,
						extensions = { "nvim-tree", "fugitive", "quickfix", "toggleterm", "man" },
					})
				end,
			},

			{ "tpope/vim-fugitive", event = "VeryLazy" },

			{
				"lewis6991/gitsigns.nvim",
				event = { "BufReadPre", "BufNewFile" },
				config = function()
					require("gitsigns").setup({
						signs = {
							add = { text = "│" },
							change = { text = "│" },
							delete = { text = "_" },
							topdelete = { text = "‾" },
							changedelete = { text = "~" },
						},
						current_line_blame = true,
						on_attach = function(bufnr)
							local gs = package.loaded.gitsigns
							local function map(mode, l, r, opts)
								opts = opts or {}
								opts.buffer = bufnr
								vim.keymap.set(mode, l, r, opts)
							end
							-- Example keymaps:
							map("n", "]c", function()
								gs.next_hunk()
							end)
							map("n", "[c", function()
								gs.prev_hunk()
							end)
							map("n", "<leader>hs", gs.stage_hunk)
							map("n", "<leader>hr", gs.reset_hunk)
							map("n", "<leader>hp", gs.preview_hunk)
						end,
					})
				end,
			},
		},

		-- 1. Auto Pairs
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = function()
				require("nvim-autopairs").setup()
			end,
		},

		-- 2. Commenting
		{
			"numToStr/Comment.nvim",
			keys = { "gc", "gcc", "gbc" },
			config = function()
				require("Comment").setup()
			end,
		},

		-- 3. Surround
		{
			"kylechui/nvim-surround",
			event = "VeryLazy",
			config = function()
				require("nvim-surround").setup()
			end,
		},

		-- 13. Copilot
		{
			"github/copilot.vim",
			event = "InsertEnter",
			config = function()
				vim.g.copilot_no_tab_map = true
				vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', {
					expr = true,
					silent = true,
					replace_keycodes = false,
				})
			end,
		},

		-- 17. Tmux Navigator
		{
			"christoomey/vim-tmux-navigator",
			lazy = false,
			keys = {
				{ "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
				{ "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
				{ "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
				{ "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
			},
		},
	},

	-- automatically check for plugin updates
	checker = { enabled = true },
})
