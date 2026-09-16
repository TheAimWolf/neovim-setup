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
}
