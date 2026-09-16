local augroup = vim.api.nvim_create_augroup("config", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- Kurz markieren, was gerade kopiert wurde
autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- 2 Leerzeichen Einrückung für Web & Lua
autocmd("FileType", {
  group = augroup,
  pattern = {
    "lua", "javascript", "typescript", "javascriptreact", "typescriptreact",
    "json", "jsonc", "yaml", "html", "css", "markdown",
  },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- Beim Öffnen an die letzte Cursorposition springen
autocmd("BufReadPost", {
  group = augroup,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Fenstergrößen angleichen, wenn das Terminal skaliert wird
autocmd("VimResized", {
  group = augroup,
  command = "wincmd =",
})
