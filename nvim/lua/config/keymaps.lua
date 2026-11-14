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

map("n", "cl", ":bd<CR>", { noremap = true, silent = true })

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

map("n", "<C-j>", function()
  vim.diagnostic.goto_next({
    severity = vim.diagnostic.severity.ERROR,
  })
end, opts)

map("n", "<C-k>", function()
  vim.diagnostic.goto_prev({
    severity = vim.diagnostic.severity.ERROR,
  })
end, opts)

map("n", "ff", function()
  pick("find_files")
end, { desc = "Find files by name" })

map("n", "fs", function()
  pick("live_grep")
end, { desc = "Live grep" })

map("n", "fb", function()
  pick("oldfiles")
end, { desc = "Recently opened files" })

map("n", "<C-i>", function()
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/implementation" })
  if #clients == 0 then
    vim.notify("No LSP implementation support in this buffer", vim.log.levels.WARN)
    return
  end
  pick("lsp_implementations", { reuse_win = true })
end, { desc = "Goto Implementation" })

map("n", "<C-n>", function()
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/definition" })
  if #clients == 0 then
    vim.cmd("normal! j")
    return
  end
  pick("lsp_definitions", { reuse_win = true })
end, { desc = "Goto Definition" })

map("n", "<C-m>", function()
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/references" })
  if #clients == 0 then
    vim.cmd("normal! +")
    return
  end

  local encoding = clients[1].offset_encoding

  local function show_list(items)
    require("lazy").load({ plugins = { "telescope.nvim" } })

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local make_entry = require("telescope.make_entry")

    pickers.new({}, {
      prompt_title = "LSP References",
      finder = finders.new_table({
        results = items,
        entry_maker = make_entry.gen_from_quickfix({}),
      }),
      previewer = conf.qflist_previewer({}),
      sorter = conf.generic_sorter({}),
      push_cursor_on_edit = true,
      push_tagstack_on_edit = true,
    }):find()
  end

  vim.lsp.buf.references({ includeDeclaration = false }, {
    on_list = function(list)
      local items = list.items
      if #items == 1 then
        vim.lsp.util.show_document(items[1].user_data, encoding, { reuse_win = true })
        vim.cmd("normal! zz")
      else
        show_list(items)
      end
    end,
  })
end, { desc = "Find references" })

-- Lazygit
map("n", "gl", function()
  require("snacks").lazygit()
end, { desc = "Open Lazygit" })

map({ "n", "v" }, "<C-M-l>", function()
  require("conform").format({
    async = true,
    lsp_format = "fallback",
  })
end, {
  noremap = true,
  silent = true,
  desc = "Format manually",
})

