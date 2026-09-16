# neovim-setup

Meine Neovim-Konfiguration – schlank, selbst zusammengestellt, im Stil von ThePrimeagen, angepasst an eine **QWERTZ**-Tastatur.

- **Theme:** rose-pine
- **LSP:** Rust, Lua, JavaScript/TypeScript, Python, Go (über Mason bzw. rustup)
- **Navigation:** Harpoon 2, Telescope (ripgrep/fd), oil.nvim
- **Editor:** Treesitter, blink.cmp, conform.nvim (Format beim Speichern), autopairs, surround, which-key
- **Git:** fugitive, gitsigns, lazygit
- **Plugin-Manager:** lazy.nvim (Versionen fixiert in `config/lazy-lock.json`)

Benötigt **Neovim ≥ 0.12**.

## Schnellstart (Debian / Ubuntu / Kali)

```bash
sudo apt install -y git
git clone https://github.com/TheAimWolf/neovim-setup.git ~/neovim-setup
bash ~/neovim-setup/install.sh
```

Danach im Terminal die Schrift **JetBrainsMono Nerd Font Mono** einstellen und `nvim` starten.

`~/.config/nvim` wird dabei als Symlink auf `~/neovim-setup/config` angelegt – eine vorhandene Config wird vorher gesichert.

## Dokumentation

| Datei | Inhalt |
|---|---|
| [INSTALLATION.md](INSTALLATION.md) | Automatische & manuelle Installation, Synchronisieren, Problemlösungen |
| [ABHAENGIGKEITEN.md](ABHAENGIGKEITEN.md) | Alle System-Pakete, Tools, LSP-Server, Plugins |
| [config/KEYMAPS.md](config/KEYMAPS.md) | Alle Tastenkürzel (Leader = Leertaste) |

## Die wichtigsten Tasten

| Taste | Wirkung |
|---|---|
| `<leader>ff` / `<leader>fg` | Dateien finden / projektweit suchen |
| `<leader>a`, `Ctrl-e`, `Ctrl-h/j/k/l` | Harpoon: merken, Menü, Datei 1–4 |
| `-` | Datei-Explorer (oil) |
| `gd`, `K`, `grr`, `<leader>r`, `<leader>c` | Definition, Doku, Referenzen, Umbenennen, Code-Action |
| `ö` / `ä` | wie `[` / `]` (z.B. `äd` nächste Diagnostic) |
| `<leader>n` | Zeilennummern relativ ↔ absolut |
| `<leader>gg` | lazygit |

## Aufbau

```
config/                     → ~/.config/nvim
├── init.lua
├── lazy-lock.json
└── lua/config/
    ├── options.lua  keymaps.lua  autocmds.lua  lazy.lua
    └── plugins/     colorscheme, telescope, harpoon, treesitter, lsp,
                     completion, format, git, oil, editor
install.sh                  → Einrichtung auf einem neuen Rechner
konsole-Catppuccin.profile  → optionales KDE-Konsole-Profil
```
