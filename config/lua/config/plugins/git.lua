return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "GBrowse" },
    keys = {
      { "<leader>gs", "<cmd>Git<CR>", desc = "Git Status (fugitive)" },
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git Blame (Datei)" },
      { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git Diff" },
      { "<leader>gl", "<cmd>Git log --oneline<CR>", desc = "Git Log" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        -- ]c / [c  (auf QWERTZ: äc / öc)
        map("n", "]c", function()
          if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
        end, "Nächster Hunk")
        map("n", "[c", function()
          if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
        end, "Voriger Hunk")
        map({ "n", "x" }, "<leader>hs", gs.stage_hunk, "Hunk stagen")
        map({ "n", "x" }, "<leader>hr", gs.reset_hunk, "Hunk zurücksetzen")
        map("n", "<leader>hS", gs.stage_buffer, "Datei stagen")
        map("n", "<leader>hR", gs.reset_buffer, "Datei zurücksetzen")
        map("n", "<leader>hv", gs.preview_hunk, "Hunk ansehen")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Zeile")
        map({ "o", "x" }, "ih", gs.select_hunk, "Hunk (Textobjekt)")
      end,
    },
  },
}
