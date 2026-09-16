local function harpoon() return require("harpoon") end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>a", function() harpoon():list():add() end, desc = "Harpoon: Datei merken" },
    { "<C-e>", function() harpoon().ui:toggle_quick_menu(harpoon():list()) end, desc = "Harpoon: Menü" },
    { "<C-h>", function() harpoon():list():select(1) end, desc = "Harpoon 1" },
    { "<C-j>", function() harpoon():list():select(2) end, desc = "Harpoon 2" },
    { "<C-k>", function() harpoon():list():select(3) end, desc = "Harpoon 3" },
    { "<C-l>", function() harpoon():list():select(4) end, desc = "Harpoon 4" },
    { "<leader>hp", function() harpoon():list():prev() end, desc = "Harpoon: vorherige" },
    { "<leader>hn", function() harpoon():list():next() end, desc = "Harpoon: nächste" },
  },
  config = function()
    harpoon():setup({ settings = { save_on_toggle = true } })
  end,
}
