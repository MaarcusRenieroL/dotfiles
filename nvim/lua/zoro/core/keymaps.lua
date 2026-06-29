vim.g.mapleader = " "

local keymap = vim.keymap.set

-- clear search highlights
keymap("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
keymap("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })
keymap("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })

-- window splits
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })
keymap("n", "<M-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<M-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<M-Left>", "<cmd>vertical resize -4<CR>", { desc = "Decrease window width" })
keymap("n", "<M-Right>", "<cmd>vertical resize +4<CR>", { desc = "Increase window width" })

-- window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
keymap("n", "<leader>wh", "<C-w>H", { desc = "Move split left" })
keymap("n", "<leader>wj", "<C-w>J", { desc = "Move split down" })
keymap("n", "<leader>wk", "<C-w>K", { desc = "Move split up" })
keymap("n", "<leader>wl", "<C-w>L", { desc = "Move split right" })

-- better indenting
keymap("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap("v", ">", ">gv", { desc = "Indent right and reselect" })

-- move selected lines
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

keymap("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
keymap("n", "<leader>bD", "<cmd>bdelete!<CR>", { desc = "Force delete buffer" })
keymap("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Decode the JWT under the cursor (header + payload) into a scratch float.
local function decode_jwt(token)
	local function b64url(part)
		part = part:gsub("-", "+"):gsub("_", "/")
		local pad = #part % 4
		if pad > 0 then
			part = part .. string.rep("=", 4 - pad)
		end
		local ok, decoded = pcall(vim.base64.decode, part)
		return ok and decoded or nil
	end

	local segments = vim.split(token, ".", { plain = true })
	if #segments < 2 then
		vim.notify("No JWT under cursor", vim.log.levels.WARN)
		return
	end

	local lines = {}
	for _, label in ipairs({ "HEADER", "PAYLOAD" }) do
		local raw = b64url(segments[label == "HEADER" and 1 or 2])
		table.insert(lines, "── " .. label .. " ──")
		if raw then
			local ok, tbl = pcall(vim.json.decode, raw)
			local pretty = ok and vim.split(vim.inspect(tbl), "\n") or { raw }
			vim.list_extend(lines, pretty)
		else
			table.insert(lines, "(could not decode)")
		end
		table.insert(lines, "")
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = "lua"
	local width = math.min(80, vim.o.columns - 4)
	local height = math.min(#lines + 1, vim.o.lines - 4)
	vim.api.nvim_open_win(buf, true, {
		relative = "cursor",
		row = 1,
		col = 0,
		width = width,
		height = height,
		border = "rounded",
		title = " JWT ",
	})
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf })
end

keymap("n", "<leader>cj", function()
	decode_jwt(vim.fn.expand("<cWORD>"))
end, { desc = "Decode JWT under cursor" })
vim.api.nvim_create_user_command("JwtDecode", function(o)
	decode_jwt(o.args ~= "" and o.args or vim.fn.expand("<cWORD>"))
end, { nargs = "?", desc = "Decode a JWT" })
