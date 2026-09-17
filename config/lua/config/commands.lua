-- :ReloadConfig            lädt options.lua, keymaps.lua und autocmds.lua neu
-- :ReloadConfig rose-pine  liest die Plugin-Spec neu ein und führt deren
--                          config() erneut aus (Tab vervollständigt die Namen)
--
-- Grenzen: Bereits gesetzte Keymaps/Autocmds verschwinden nicht, wenn du sie
-- aus der Datei löschst – dafür braucht es einen Neustart.
local modules = { "config.options", "config.keymaps", "config.autocmds" }

local function reload_core()
  for _, mod in ipairs(modules) do
    package.loaded[mod] = nil
    local ok, err = pcall(require, mod)
    if not ok then
      vim.notify("Fehler in " .. mod .. ":\n" .. tostring(err), vim.log.levels.ERROR)
      return
    end
  end
  vim.notify("Config neu geladen: " .. table.concat(modules, ", "))
end

local function reload_plugin(name)
  require("lazy.core.plugin").load() -- Spec-Dateien neu einlesen
  if not require("lazy.core.config").plugins[name] then
    vim.notify("Kein Plugin namens '" .. name .. "' (Namen mit <Tab> vervollständigen)", vim.log.levels.WARN)
    return
  end
  require("lazy.core.loader").reload(name)
  vim.notify("Plugin neu geladen: " .. name)
end

vim.api.nvim_create_user_command("ReloadConfig", function(opts)
  if opts.args == "" then
    reload_core()
  else
    reload_plugin(opts.args)
  end
end, {
  nargs = "?",
  desc = "Config neu laden (optional: ein Plugin)",
  complete = function(lead)
    return vim.tbl_filter(function(name)
      return name:find(lead, 1, true) == 1
    end, vim.tbl_keys(require("lazy.core.config").plugins))
  end,
})
