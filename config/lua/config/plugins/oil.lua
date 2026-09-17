return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Übergeordneter Ordner" },
    { "<leader>pv", "<cmd>Oil<CR>", desc = "Datei-Explorer" },
  },
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = { show_hidden = true },
    -- Nur im Explorer-Fenster: keine 80-Zeichen-Markierung, und die aktuelle
    -- Zeile wird unterstrichen statt mit einem Farbblock hinterlegt.
    -- Neovim merkt sich Fenster-Optionen pro Buffer, beim Öffnen einer Datei
    -- im selben Fenster gilt also wieder colorcolumn=80.
    win_options = {
      colorcolumn = "",
      winhighlight = "CursorLine:OilCursorLine",
    },
    keymaps = {
      -- Ctrl-h/j/k/l gehören Harpoon, Split-Öffnen daher auf Ctrl-s / Ctrl-v
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-v>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-r>"] = "actions.refresh",
      ["q"] = "actions.close",
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)

    -- Highlight-Gruppen werden bei jedem Colorscheme-Wechsel zurückgesetzt
    -- (auch durch <leader>tb), darum per Autocmd nachziehen.
    local function set_hl()
      vim.api.nvim_set_hl(0, "OilCursorLine", { underline = true })
    end
    set_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("oil-cursorline", { clear = true }),
      callback = set_hl,
    })
  end,
}
