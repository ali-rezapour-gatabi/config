local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set({ "n", "v", "o" }, "H", "^", opts)
keymap.set({ "n", "v", "o" }, "L", "$", opts)

-- Git
keymap.set("n", "<Leader>gb", ":Gitsigns toggle_current_line_blame<CR>")
keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", opts)
keymap.set("n", "<leader>gn", "<cmd>Gitsigns next_hunk<cr>", opts)
keymap.set("n", "<leader>gp", "<cmd>Gitsigns prev_hunk<cr>", opts)
keymap.set("n", "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", opts)
keymap.set("n", "<leader>gl", "<cmd>Git log --oneline --graph --decorate --all<cr>")
keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>")
keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>")
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")

keymap.set("n", "nh", ":nohl<CR>", opts)
keymap.set("n", ";;", ":w<CR>", opts)
keymap.set("n", "x", '"_x', opts)
keymap.set("n", "dw", 'vb"_d', opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")
-- Resize window
keymap.set("n", "<C-Left>", "<C-w>>", { noremap = true, silent = true })
keymap.set("n", "<C-Right>", "<C-w><", { noremap = true, silent = true })
keymap.set("n", "<C-Up>", "<C-w>+", { noremap = true, silent = true })
keymap.set("n", "<C-Down>", "<C-w>-", { noremap = true, silent = true })
-- Close window
keymap.set("n", "cl", ":bd<CR>", { noremap = true, silent = true })

-- New tab
keymap.set("n", "te", ":tabedit")
-- keymap.set("n", "<tab>", ":tabnext<Return>", opts)
-- keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

keymap.set("n", "<Space>", "<C-w>w", opts)

-- Find files
keymap.set("n", "ff", "<cmd>Telescope find_files<cr>", opts)
keymap.set("n", "fs", "<cmd>Telescope live_grep<cr>", opts)
keymap.set("n", "fb", "<cmd>Telescope buffers<cr>", opts)
keymap.set("n", "fh", "<cmd>Telescope help_tags<cr>", opts)
keymap.set("n", "<leader-e>", ":Neotree<CR>", opts)
keymap.set("n", "<C-m>", "<cmd>Telescope lsp_references<CR>", opts)

-- Select current scope
keymap.set({ "n", "x" }, "<C-Space>", function()
  require("snacks.scope").textobject({ linewise = false, notify = false })
end, { desc = "Select current scope" })

-- format
keymap.set("v", "<C-A-l>", function()
  vim.lsp.buf.format({ async = true })
end)

keymap.set("n", "<C-A-l>", function()
  vim.lsp.buf.format({ async = true })
end)

keymap.set("n", "rss", ":LspRestart<CR>", opts)

keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

vim.keymap.set("n", "<C-k>", function()
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
    if not result or vim.tbl_isempty(result) then
      print("No definition found")
      return
    end

    local target = result[1] or result
    local uri = target.uri or target.targetUri
    local range = target.range or target.targetSelectionRange
    local filename = vim.uri_to_fname(uri)

    vim.cmd("badd " .. vim.fn.fnameescape(filename))
    local bufnr = vim.fn.bufnr(filename)
    vim.cmd("buffer " .. bufnr)
    if range then
      vim.api.nvim_win_set_cursor(0, {
        range.start.line + 1,
        range.start.character,
      })
    end
  end)
end, { silent = true })
