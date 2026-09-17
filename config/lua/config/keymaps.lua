local map = vim.keymap.set

-- QWERTZ: ö = [  und  ä = ]  (alle [x / ]x Standard-Befehle funktionieren so,
-- z.B. äd/öd Diagnostics, äq/öq Quickfix, äc/öc Git-Hunks, äb/öb Buffer)
map({ "n", "x", "o" }, "ö", "[", { remap = true })
map({ "n", "x", "o" }, "ä", "]", { remap = true })

-- Suchmarkierung löschen (Ctrl-l ist für Harpoon belegt)
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Zeilennummern relativ <-> absolut
map("n", "<leader>n", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Relative Zeilennummern umschalten" })

-- Markierte Zeilen verschieben (Visual: J / K)
map("x", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Zeilen runter" })
map("x", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Zeilen hoch" })
-- Einrücken im Visual-Mode ohne Auswahl zu verlieren
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Cursor bleibt beim Joinen / Scrollen / Suchen mittig
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Einfügen über Auswahl, ohne das Register zu überschreiben
map("x", "<leader>p", [["_dP]], { desc = "Einfügen ohne Yank" })
-- Löschen ins schwarze Loch
map({ "n", "x" }, "<leader>d", [["_d]], { desc = "Löschen ohne Yank" })

-- Speichern / Schließen
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Speichern" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Fenster schließen" })

-- Insert-Mode: Ctrl-c verhält sich wie Esc (triggert InsertLeave)
map("i", "<C-c>", "<Esc>")

-- Q (Ex-Mode) deaktivieren
map("n", "Q", "<nop>")

-- Wort unter Cursor in der ganzen Datei ersetzen
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Wort ersetzen" })

-- Datei ausführbar machen
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "chmod +x" })

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic anzeigen" })
map("n", "<leader>E", vim.diagnostic.setqflist, { desc = "Diagnostics -> Quickfix" })

-- Undotree (in Neovim 0.12 eingebaut)
map("n", "<leader>u", function()
  vim.cmd.packadd("nvim.undotree")
  vim.cmd.Undotree()
end, { desc = "Undotree" })

-- Terminal: Esc Esc verlässt den Terminal-Mode
map("t", "<Esc><Esc>", [[<C-\><C-n>]])

-- Ordner des aktuellen Buffers: im Explorer der angezeigte Ordner,
-- bei einer Datei deren Verzeichnis, sonst das Arbeitsverzeichnis
local function buf_dir()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].filetype == "oil" then
    local ok, oil = pcall(require, "oil")
    local dir = ok and oil.get_current_dir(buf)
    if dir then return dir end
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if name ~= "" and vim.bo[buf].buftype == "" then
    return vim.fs.dirname(name)
  end
  return assert(vim.uv.cwd())
end

-- lazygit in eigenem Tab, im Git-Repo des aktuellen Buffers
map("n", "<leader>gg", function()
  local dir = buf_dir()
  local root = vim.fs.root(dir, ".git")
  if not root then
    vim.notify("Kein Git-Repo für " .. dir, vim.log.levels.WARN)
    return
  end
  vim.cmd("tabnew")
  vim.cmd("tcd " .. vim.fn.fnameescape(root))
  vim.cmd("terminal lazygit")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = buf,
    once = true,
    callback = function()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end)
    end,
  })
  vim.cmd.startinsert()
end, { desc = "lazygit (Repo des Buffers)" })
