return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<leader>F", function() require("conform").format({ async = true }) end, mode = { "n", "x" }, desc = "Formatieren" },
    { "<leader>tf", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Format beim Speichern: " .. (vim.g.disable_autoformat and "aus" or "an"))
      end, desc = "Format beim Speichern umschalten" },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      python = { "ruff_organize_imports", "ruff_format" },
      go = { "goimports", "gofmt" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function()
      if vim.g.disable_autoformat then return end
      return { timeout_ms = 2000 }
    end,
  },
}
