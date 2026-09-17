-- Standard: transparent, also das Design des Terminals.
-- Mit <leader>tb den rose-pine-Hintergrund an- und ausschalten.
local transparent = true

local function apply()
  require("rose-pine").setup({
    variant = "main", -- main | moon | dawn
    styles = { italic = false, transparency = transparent },
  })
  vim.cmd.colorscheme("rose-pine")
end

return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  config = function()
    apply()

    vim.keymap.set("n", "<leader>tb", function()
      transparent = not transparent
      apply()
      vim.notify("Hintergrund: " .. (transparent and "transparent (Terminal)" or "rose-pine"))
    end, { desc = "Hintergrund transparent umschalten" })
  end,
}
