# Abhängigkeiten

Stand: 16.09.2026 — getestet auf Kali Linux Rolling (KDE, X11) mit den unten genannten Versionen.

## System-Pakete (apt)

| Paket | Getestete Version | Wofür |
|---|---|---|
| `neovim` | 0.12.4 | **Mindestens 0.12** (nvim-treesitter `main`, eingebautes Undotree, `vim.lsp.config`) |
| `git` | – | lazy.nvim lädt Plugins per git |
| `gcc`, `make` | – | Treesitter-Parser & telescope-fzf-native kompilieren |
| `curl`, `unzip`, `tar` | – | Mason-Downloads, Font-Download |
| `ripgrep` | 15.2.0 | Telescope: projektweite Textsuche (`<leader>fg`) |
| `fd-find` | 10.5.0 | Telescope: schnelle Dateisuche (`<leader>ff`), Binary heißt `fdfind` |
| `tree-sitter-cli` | 0.26.11 | nvim-treesitter baut Parser damit (**nicht** über npm installieren) |
| `nodejs`, `npm` | 24.19 / 11.19 | Mason installiert damit `ts_ls`, `pyright`, `prettierd` |
| `golang-go` | 1.26 | Mason installiert damit `gopls`, `goimports` |
| `python3`, `python3-venv`, `python3-pip` | 3.x | Python-Entwicklung, Mason-Pakete |
| `lazygit` | 0.57 | Git-Oberfläche (`<leader>gg`) |
| `xclip` (X11) oder `wl-clipboard` (Wayland) | – | System-Zwischenablage |

```bash
sudo apt install -y neovim git gcc make curl unzip tar ripgrep fd-find tree-sitter-cli \
  nodejs npm golang-go python3 python3-venv python3-pip lazygit xclip
```

## System-Pakete (macOS / Homebrew)

Getestet auf macOS 27 (arm64) mit Neovim 0.12.5.

```bash
brew install neovim git make curl ripgrep fd tree-sitter-cli node go python3 lazygit
brew install --cask font-jetbrains-mono-nerd-font
```

| Abweichung zu apt | Grund |
|---|---|
| `tree-sitter-cli` statt `tree-sitter` | Die Formel `tree-sitter` enthält nur die Library, nicht das CLI-Binary |
| `fd` statt `fd-find` | Binary heißt auf Homebrew direkt `fd` |
| `node` statt `nodejs`/`npm` | npm ist in der Node-Formel enthalten |
| `go` statt `golang-go` | – |
| kein `xclip` / `gcc` | Zwischenablage über `pbcopy`, Compiler über Xcode Command Line Tools (`xcode-select --install`) |
| Schrift als Cask | landet in `~/Library/Fonts`, kein `fc-cache` nötig |

## Rust (rustup, ohne sudo)

| Komponente | Wofür |
|---|---|
| `rustup` + stable toolchain | Rust (getestet: rustc 1.98.1) |
| `rust-analyzer` | Rust-LSP (bewusst über rustup, nicht Mason → passt immer zur Toolchain) |
| `rust-src` | Wird von rust-analyzer für die Standardbibliothek gebraucht |
| `rustfmt`, `clippy` | Formatieren / Linting (rust-analyzer nutzt clippy beim Speichern) |

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh   # falls noch nicht vorhanden
rustup component add rust-analyzer rust-src rustfmt clippy
```

## Schrift

| Schrift | Wofür |
|---|---|
| **JetBrainsMono Nerd Font Mono** | Icons in Telescope, oil, which-key, Diagnostics. Im Terminal einstellen! |

Quelle: <https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz>
→ entpacken nach `~/.local/share/fonts/JetBrainsMonoNerd/`, dann `fc-cache -f`.

## Über Mason installiert (automatisch, `~/.local/share/nvim/mason/`)

| Tool | Art | Sprache | Braucht |
|---|---|---|---|
| `lua-language-server` | LSP | Lua | – |
| `typescript-language-server` | LSP | JS / TS | Node |
| `pyright` | LSP (Typen) | Python | Node |
| `ruff` | LSP (Lint) + Formatter | Python | – |
| `gopls` | LSP | Go | Go |
| `stylua` | Formatter | Lua | – |
| `prettierd` | Formatter | JS/TS/JSON/CSS/HTML/YAML/Markdown | Node |
| `goimports` | Formatter | Go | Go |

## Neovim-Plugins (lazy.nvim, Versionen fixiert in `config/lazy-lock.json`)

| Plugin | Zweck |
|---|---|
| `folke/lazy.nvim` | Plugin-Manager |
| `rose-pine/neovim` | Theme |
| `nvim-telescope/telescope.nvim` | Fuzzy-Finder |
| `nvim-telescope/telescope-fzf-native.nvim` | Schnelle Sortierung (wird mit `make` gebaut) |
| `nvim-telescope/telescope-ui-select.nvim` | Code-Actions etc. im Telescope-Fenster |
| `nvim-lua/plenary.nvim` | Bibliothek für Telescope & Harpoon |
| `nvim-tree/nvim-web-devicons` | Datei-Icons |
| `ThePrimeagen/harpoon` (Branch `harpoon2`) | Schnell zwischen Lieblingsdateien springen |
| `nvim-treesitter/nvim-treesitter` (Branch `main`) | Syntax-Highlighting & Einrückung |
| `neovim/nvim-lspconfig` | Server-Konfigurationen |
| `mason-org/mason.nvim` | Installiert LSPs/Formatter |
| `mason-org/mason-lspconfig.nvim` | Verbindet Mason & lspconfig |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | Installiert Formatter automatisch |
| `folke/lazydev.nvim` | Lua-LSP kennt die Neovim-API |
| `saghen/blink.cmp` (v1.*) | Autovervollständigung (lädt vorkompilierte Rust-Lib) |
| `rafamadriz/friendly-snippets` | Snippets |
| `stevearc/conform.nvim` | Formatieren (beim Speichern) |
| `stevearc/oil.nvim` | Datei-Explorer |
| `tpope/vim-fugitive` | Git-Befehle |
| `lewis6991/gitsigns.nvim` | Git-Änderungen in der Seitenleiste |
| `windwp/nvim-autopairs` | Klammern automatisch schließen |
| `kylechui/nvim-surround` | Umschließen (`ys`, `cs`, `ds`) |
| `folke/which-key.nvim` | Keymap-Hilfe |

Eingebaut (kein Plugin nötig): Undotree (`nvim.undotree`), EditorConfig, Kommentieren (`gc`).

## Treesitter-Parser

rust, lua, luadoc, javascript, typescript, tsx, jsdoc, python, go, gomod, gosum, gowork,
json, yaml, toml, html, css, markdown, markdown_inline, bash, vim, vimdoc, query, regex,
diff, git_config, gitcommit, gitignore, dockerfile, sql
