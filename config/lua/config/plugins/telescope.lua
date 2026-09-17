return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Dateien finden" },
    { "<leader>fa", function() require("telescope.builtin").find_files({ hidden = true, no_ignore = true }) end, desc = "Alle Dateien (inkl. versteckt)" },
    { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Git-Dateien" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Projektweit suchen (live)" },
    { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Wort unter Cursor suchen", mode = { "n", "x" } },
    { "<leader>fs", function()
        require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
      end, desc = "Suche nach Eingabe" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Offene Buffer" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Zuletzt geöffnet" },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Hilfe" },
    { "<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps" },
    { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
    { "<leader>fo", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Symbole in Datei" },
    { "<leader>fO", function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end, desc = "Symbole im Projekt" },
    { "<leader>f.", function() require("telescope.builtin").resume() end, desc = "Letzte Suche fortsetzen" },
    { "<leader>fp", function() require("telescope.builtin").pickers() end, desc = "Frühere Suchen (Historie)" },
    { "<leader>/", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "In Datei suchen" },
    { "<leader><leader>", function() require("telescope.builtin").buffers({ sort_mru = true, ignore_current_buffer = true }) end, desc = "Buffer wechseln" },
    { "<leader>fn", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end, desc = "Neovim-Config" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
        file_ignore_patterns = { "^.git/", "node_modules/", "target/" },
        -- Standard ist 1: nur die letzte Suche ist über <leader>f. wiederholbar.
        -- 10 gemerkte Picker -> <leader>fp zeigt sie mit Suchbegriff zur Auswahl.
        cache_picker = { num_pickers = 10 },
        mappings = {
          -- Ctrl-q: Treffer in die Quickfix-Liste (dann äq / öq zum Durchgehen)
          i = { ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist },
          n = { ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist },
        },
      },
      pickers = {
        find_files = { hidden = true },
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
      },
    })
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
  end,
}
