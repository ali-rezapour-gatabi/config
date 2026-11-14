return {

  { "folke/start-nvim", enabled = false },
  { "folke/dashboard-nvim", enabled = false },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "svelte",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "java",
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "shellcheck",
        "flake8",
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      -- Keep H/L for start/end of line (see config/keymaps.lua)
      { "<S-h>", false },
      { "<S-l>", false },
      -- <Tab> is the same key as <C-i> in the terminal, so it is used for
      -- "Goto Implementation" (see config/keymaps.lua). Use ]b / [b instead.
      { "<Tab>", false },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    },
    opts = function()
      local c = require("solarized-osaka.colors").setup()
      return {
        options = {
          mode = "buffers",
          -- minimal: no separators, only an underline for the active buffer
          separator_style = { "", "" },
          indicator = { style = "underline" },
          show_buffer_icons = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
          truncate_names = true,
          max_name_length = 24,
          color_icons = true,
          offsets = {
            { filetype = "neo-tree", text = "󰉋", text_align = "center", separator = "" },
          },
        },
        -- transparent background; only the text color changes between tabs
        highlights = {
          fill = { bg = "NONE" },
          background = { fg = c.base1, bg = "NONE" },
          buffer_selected = {
            fg = c.base3,
            bg = "NONE",
            bold = true,
            underline = true,
            sp = c.blue500,
          },
          buffer_visible = { fg = c.base1, bg = "NONE" },
          separator = { fg = "NONE", bg = "NONE" },
          separator_selected = { fg = "NONE", bg = "NONE" },
          separator_visible = { fg = "NONE", bg = "NONE" },
          indicator_selected = { fg = c.blue500, sp = c.blue500, bg = "NONE" },
          modified = { fg = c.yellow500, bg = "NONE" },
          modified_selected = { fg = c.yellow500, bg = "NONE" },
          modified_visible = { fg = c.yellow500, bg = "NONE" },
          duplicate = { fg = c.base01, bg = "NONE", italic = true },
          duplicate_selected = { fg = c.base2, bg = "NONE", italic = true },
          duplicate_visible = { fg = c.base01, bg = "NONE", italic = true },
          close_button = { fg = c.base01, bg = "NONE" },
          close_button_selected = { fg = c.base3, bg = "NONE" },
          close_button_visible = { fg = c.base01, bg = "NONE" },
          offset_separator = { fg = c.base01, bg = "NONE" },
        },
      }
    end,
  },

  {
    "b0o/incline.nvim",
    dependencies = { "craftzdog/solarized-osaka.nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("solarized-osaka.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
            InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  {
    "adibhanna/laravel.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>la", ":Artisan<cr>", desc = "Laravel Artisan" },
      { "<leader>lc", ":Composer<cr>", desc = "Composer" },
      { "<leader>lr", ":LaravelRoute<cr>", desc = "Laravel Routes" },
      { "<leader>lm", ":LaravelMake<cr>", desc = "Laravel Make" },
    },
    config = function()
      require("laravel").setup()
    end,
  },
}
