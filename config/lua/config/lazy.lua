-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Debian/Kali: mitgelieferte Treesitter-Parser liegen in /usr/lib/nvim.
-- Auf anderen Systemen (z.B. macOS/Homebrew) gibt es den Pfad nicht.
local extra_rtp = {}
if vim.uv.fs_stat("/usr/lib/nvim") then
  table.insert(extra_rtp, "/usr/lib/nvim")
end

require("lazy").setup({
  spec = { { import = "config.plugins" } },
  install = { colorscheme = { "rose-pine" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  ui = { border = "rounded" },
  performance = {
    rtp = { paths = extra_rtp },
  },
})
