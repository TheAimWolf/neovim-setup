local parsers = {
  "rust", "lua", "luadoc", "javascript", "typescript", "tsx", "jsdoc",
  "python", "go", "gomod", "gosum", "gowork",
  "json", "yaml", "toml", "html", "css", "markdown", "markdown_inline",
  "bash", "vim", "vimdoc", "query", "regex", "diff",
  "git_config", "gitcommit", "gitignore", "dockerfile", "sql",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local headless = #vim.api.nvim_list_uis() == 0
    if vim.fn.executable("tree-sitter") == 1 then
      -- Headless (Skripte) nicht automatisch bauen, sonst brechen Builds beim Beenden ab
      if not headless then ts.install(parsers) end
    elseif not headless then
      vim.notify("tree-sitter-cli fehlt: sudo apt install tree-sitter-cli", vim.log.levels.WARN)
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang or not vim.treesitter.language.add(lang) then return end
        vim.treesitter.start(args.buf, lang)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
