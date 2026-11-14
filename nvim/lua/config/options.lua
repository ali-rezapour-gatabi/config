vim.g.mapleader = " "

-- LazyVim plugin choices
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_php_lsp = "intelephense"

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.scrolloff = 10
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.inccommand = "split"
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""
vim.opt.title = true
vim.opt.shell = "fish"
vim.opt.clipboard:append("unnamedplus")
vim.g.autoformat = false
vim.opt.splitkeep = "cursor"
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })
