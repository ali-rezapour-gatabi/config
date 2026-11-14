local map = vim.keymap.set

local opts = { noremap = true, silent = true }

-- Better horizontal movement
map({ "n", "v", "o" }, "H", "^", opts)
map({ "n", "v", "o" }, "L", "$", opts)

-- Delete without yanking
map("n", "x", '"_x', opts)
map("n", "dw", 'vb"_d', opts)

map("n", "<Space>", "<C-w>w", opts)

-- Split window
map("n", "ss", "<cmd>split<cr>", opts)
map("n", "sv", "<cmd>vsplit<cr>", opts)

-- Move between windows
map("n", "sh", "<C-w>h", opts)
map("n", "sk", "<C-w>k", opts)
map("n", "sj", "<C-w>j", opts)
map("n", "sl", "<C-w>l", opts)

-- Resize windows
map("n", "<C-Left>", "<C-w>>", opts)
map("n", "<C-Right>", "<C-w><", opts)
map("n", "<C-Up>", "<C-w>+", opts)
map("n", "<C-Down>", "<C-w>-", opts)

-- LSP
map("n", "<leader>cL", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

map({ "n", "x" }, "<C-Space>", function()
  require("snacks.scope").textobject({ linewise = false, notify = false })
end, { desc = "Select current scope" })

-- Telescope pickers
local function pick(builtin, picker_opts)
  require("lazy").load({ plugins = { "telescope.nvim" } })
  require("telescope.builtin")[builtin](picker_opts)
end

map("n", "ff", function()
  pick("find_files")
end, { desc = "Find files by name" })

map("n", "fs", function()
  pick("live_grep")
end, { desc = "Live grep" })

map("n", "fb", function()
  pick("oldfiles")
end, { desc = "Recently opened files" })

-- Goto implementation (Java interfaces, TypeScript, etc.)
-- Note: in the terminal <C-i> and <Tab> are the same key.
map("n", "<C-i>", function()
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/implementation" })
  if #clients == 0 then
    vim.notify("No LSP implementation support in this buffer", vim.log.levels.WARN)
    return
  end
  pick("lsp_implementations", { reuse_win = true })
end, { desc = "Goto Implementation" })

-- Lazygit
map("n", "gl", function()
  require("snacks").lazygit()
end, { desc = "Open Lazygit" })
