return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = vim.split(
      [[
⠀⠀⠀⠀⠀⣖⣴⣆⡀⠀⣠⠶⢉⡾⠻⢦⣀⠀⠀⠀⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠬⠀⠀⢊⡠⠏⢉⣹⠞⠛⣦⡾⣶⡖⠛⠁⡄⢄⠇⡰⠻⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠈⠀⣷⡿⠋⣀⡴⣋⡤⠖⣿⣿⠁⢸⣿⡧⠀⢹⠌⡸⠁⢀⡄⠉⣱⣶⣂⣀⢀⡆⣠⠀⣠⠂⠀⠀⢀⠄⠄⢀⠄⡀⠀⠀⡀⠀⠰⠆⠀⠀
⢀⡴⠋⣴⣾⡗⠋⢹⡄⣼⡏⠃⢈⣼⣿⣖⣦⠨⣠⠃⢀⡞⠀⠈⠋⠡⡾⠟⠋⠛⠳⣦⣧⠀⣤⢥⣅⣁⣁⣀⣖⠥⢂⡈⠀⣼⣟⠁⠀⠀
⢨⣴⣾⠋⣿⢇⢀⠆⢘⣏⣤⣶⣿⣿⣿⣿⡎⡦⡟⠀⠚⠀⠀⠀⠀⠀⢠⠀⠀⠀⢀⠈⠋⢳⣷⢸⠁⣄⠀⢹⢷⣶⢿⢷⣾⣿⣿⣷⠀⠀
⠀⡼⢳⣴⠇⢀⣬⣶⣿⣿⣿⣿⣿⣿⣿⢹⣿⡇⠀⣭⣉⣱⡀⠀⠀⠀⢸⡆⠀⢀⡼⠀⠀⢠⠋⢸⠀⡇⠀⣾⣿⣀⣤⣤⣿⣿⣿⣿⣧⡀
⠴⢃⣤⣿⣿⣿⣿⣿⣿⣿⣿⢻⠏⢻⣏⣿⣿⠃⠀⡟⢷⣬⣣⡀⠀⠀⢸⡇⢰⣿⡜⠁⠀⢸⠀⣾⠁⡇⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣾⣿⣿⣿⣿⣿⣿⣿⢿⡟⠁⣸⠀⠨⢻⡘⣿⠀⠀⠈⢦⣙⣛⣧⡀⠀⠸⢧⠿⠋⠀⠀⠀⢸⣼⣷⣄⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⠿⢋⡴⢋⢤⠀⡇⠀⠀⠀⠻⣿⠀⠀⠀⠈⠻⠿⢿⣷⣴⡏⣾⡄⢀⣀⣤⣴⣟⣉⣉⡟⠉⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⠿⠋⣁⡴⣫⠞⢁⡿⢀⡇⠀⠀⠀⠀⣿⠀⢷⠂⠀⠀⠀⠀⠀⠹⢠⠟⢛⣻⠿⣿⣿⣿⡟⠋⠐⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣯⣵⡶⢿⢻⡟⠁⠀⣼⢃⢺⢿⠿⣽⣷⣾⣿⣦⣜⣷⣄⠀⠀⠀⢀⠇⡎⠀⠈⢧⡀⢀⣎⡴⠇⠀⣸⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿
⠛⠉⠀⢸⡿⠀⠀⢀⣟⡎⢸⠀⠀⠀⠀⢸⡟⡷⡀⠹⡧⢝⠢⠤⣿⣼⠅⠀⠀⠀⢉⣻⣿⡷⠀⣰⣿⣿⣿⣿⣿⣿⣿⢳⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠘⠃⠀⠀⢸⡿⠀⢸⠀⠀⠀⠀⢻⡄⠹⡷⡀⠈⣖⠭⣒⡢⠭⠉⠉⣩⣽⡿⠛⠉⢀⣴⣿⣿⡿⣿⣿⣿⣿⡏⢸⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⢸⠀⠀⠀⠀⢸⡇⠀⢻⡱⡄⠈⠳⣦⣬⣽⡟⠋⠉⠀⢀⣠⣶⡿⣿⣿⣯⣷⣿⣿⣿⣿⠁⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⢸⡇⠀⠀⠳⡈⢲⣤⣀⣈⣇⣀⠤⠴⠚⠋⢉⣠⣾⣿⣿⣿⣿⣿⣿⣳⠃⠀⣿⣿⣿⣿⣿⣿⣿
    ]],
      "\n",
      true
    )

    -- 🔘 Buttons
    dashboard.section.buttons.val = {
      dashboard.button("e", "  New File", ":ene <BAR> startinsert<CR>"),
      dashboard.button("f", "󰱼  Find File", ":Telescope find_files<CR>"),
      dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
      dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
      dashboard.button("t", "  Find Text", ":Telescope live_grep<CR>"),
      dashboard.button("c", "  Config", ":e $MYVIMRC<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }

    -- 📜 Footer
    dashboard.section.footer.val = function()
      local stats = require("lazy").stats()
      return {
        "⚡ Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins",
        "",
        " " .. os.date("%A, %B %d"),
        "",
        "Ready to cut through bugs with three swords?",
      }
    end

    -- Highlighting
    dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Keyword"
    dashboard.section.footer.opts.hl = "Constant"

    -- Initialize alpha
    alpha.setup(dashboard.opts)
  end,
}
