return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true },
  },
  {
    -- ys{motion}{char} hinzufügen, cs{alt}{neu} ändern, ds{char} löschen, S im Visual
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "Finden" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunks / Harpoon" },
        { "<leader>t", group = "Umschalten" },
        { "gr", group = "LSP" },
      },
    },
  },
}
