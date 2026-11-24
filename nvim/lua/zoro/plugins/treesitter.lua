return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false,
    priority = 800,
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local treesitter = require("nvim-treesitter.configs")

      -- Neovim 0.11+ / 0.12+ compatibility fix:
      -- In Neovim 0.11+, query matches map capture IDs to a list of nodes { TSNode },
      -- but legacy nvim-treesitter predicates/directives expect match[id] to be a single TSNode.
      pcall(require, "nvim-treesitter.query_predicates")

      local q = vim.treesitter.query
      local non_filetype_match_injection_language_aliases = {
        ex = "elixir",
        pl = "perl",
        sh = "bash",
        uxn = "uxntal",
        ts = "typescript",
      }

      local function get_parser_from_markdown_info_string(injection_alias)
        local match = vim.filetype.match({ filename = "a." .. injection_alias })
        return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
      end

      local function get_node(match, id)
        local nodes = match[id]
        if not nodes then
          return nil
        end
        if type(nodes) == "table" then
          return nodes[1] or nodes
        end
        return nodes
      end

      -- Safely patch treesitter node range / text in case a node table is passed
      local orig_get_range = vim.treesitter.get_range
      vim.treesitter.get_range = function(node, source, metadata)
        if type(node) == "table" and node[1] then
          node = node[1]
        end
        return orig_get_range(node, source, metadata)
      end

      local orig_get_node_text = vim.treesitter.get_node_text
      vim.treesitter.get_node_text = function(node, source, opts)
        if type(node) == "table" and node[1] then
          node = node[1]
        end
        return orig_get_node_text(node, source, opts)
      end

      local d_opts = { force = true, all = false }

      q.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local node = get_node(match, pred[2])
        if not node then
          return
        end
        local text = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata["injection.language"] = get_parser_from_markdown_info_string(text)
      end, d_opts)

      q.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
        local node = get_node(match, pred[2])
        if not node then
          return
        end
        local text = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata[pred[3]] = text
      end, d_opts)

      q.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
        local node = get_node(match, pred[2])
        if not node then
          return
        end
        local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
        local html_script_type_languages = {
          ["importmap"] = "json",
          ["module"] = "javascript",
          ["application/ecmascript"] = "javascript",
          ["text/ecmascript"] = "javascript",
        }
        local configured = html_script_type_languages[type_attr_value]
        if configured then
          metadata["injection.language"] = configured
        else
          local parts = vim.split(type_attr_value, "/", {})
          metadata["injection.language"] = parts[#parts]
        end
      end, d_opts)

      q.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
        local node = get_node(match, pred[2])
        local n = tonumber(pred[3])
        if node and node:parent() and node:parent():named_child_count() > n then
          return node:parent():named_child(n) == node
        end
        return false
      end, d_opts)

      q.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
        local node = get_node(match, pred[2])
        local types = { unpack(pred, 3) }
        if not node then
          return true
        end
        return vim.tbl_contains(types, node:type())
      end, d_opts)

      treesitter.setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
        ensure_installed = {
          "java",
          "typescript",
          "tsx",
          "javascript",
          "rust",
          "python",
          "sql",
          "bash",
          "lua",
          "html",
          "css",
          "json",
          "yaml",
          "markdown",
          "markdown_inline",
          "dockerfile",
          "toml",
          "vim",
          "vimdoc",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },
}
