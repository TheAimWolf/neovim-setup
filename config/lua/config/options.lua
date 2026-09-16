local opt = vim.opt

-- Zeilennummern: relativ, aktuelle Zeile absolut (Toggle: <leader>n)
opt.number = true
opt.relativenumber = true

-- Einrückung (Standard 4, pro Sprache in autocmds.lua / .editorconfig)
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Darstellung
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.cursorline = true
opt.termguicolors = true
opt.winborder = "rounded"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.showmode = false

-- Suche
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"

-- Dateien: kein Swap/Backup, dafür persistentes Undo
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- System-Zwischenablage (verzögert, beschleunigt den Start)
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

-- Verhalten
opt.mouse = "a"
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.confirm = true
opt.isfname:append("@-@")

-- Diagnostics
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  severity_sort = true,
  float = { source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
})
