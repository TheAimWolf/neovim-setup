-- LSP-Server (Namen wie in nvim-lspconfig). rust-analyzer kommt über rustup.
local servers = { "lua_ls", "ts_ls", "pyright", "ruff", "gopls" }
-- Formatter, die Mason zusätzlich installieren soll
local tools = { "stylua", "prettierd", "goimports" }

return {
  {
    -- nicht lazy: legt mason/bin in den PATH (Formatter für conform)
    "mason-org/mason.nvim",
    lazy = false,
    opts = { ui = { border = "rounded" } },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = { ensure_installed = tools },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Fähigkeiten von blink.cmp an alle Server weitergeben
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("lua_ls", {
        settings = { Lua = { completion = { callSnippet = "Replace" } } },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = { check = { command = "clippy" } },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = false,
            staticcheck = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
          },
        },
      })

      -- Pyright macht Typen, Ruff macht Linting -> doppelte Hinweise vermeiden
      vim.lsp.config("pyright", {
        settings = {
          pyright = { disableOrganizeImports = true },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = { exclude = { "stylua" } },
      })
      vim.lsp.enable("rust_analyzer")

      -- Keymaps, sobald ein Server an den Buffer andockt.
      -- Neovim-Standards bleiben: K Hover, grn Umbenennen, gra Code-Action,
      -- grr Referenzen, gri Implementierung, grt Typ-Definition, gO Symbole,
      -- Ctrl-s Signatur (Insert), äd/öd nächste/vorige Diagnostic
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local function map(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, desc = desc })
          end
          local tb = require("telescope.builtin")

          map("gd", tb.lsp_definitions, "Gehe zu Definition")
          map("gD", vim.lsp.buf.declaration, "Gehe zu Deklaration")
          map("grr", tb.lsp_references, "Referenzen")
          map("gri", tb.lsp_implementations, "Implementierungen")
          map("grt", tb.lsp_type_definitions, "Typ-Definition")
          -- Kurzformen
          map("<leader>r", vim.lsp.buf.rename, "Umbenennen")
          map("<leader>c", vim.lsp.buf.code_action, "Code-Action", { "n", "x" })

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            map("<leader>ti", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
            end, "Inlay-Hints umschalten")
          end
          -- Ruff: Hover Pyright überlassen
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })
    end,
  },
}
