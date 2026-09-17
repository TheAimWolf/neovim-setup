#!/usr/bin/env bash
# neovim-setup installieren (Debian / Ubuntu / Kali sowie macOS mit Homebrew)
# Aufruf:  bash install.sh   (aus dem Git-Klon oder vom USB-Stick)
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"

step() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!!  %s\033[0m\n' "$*"; }

case "$(uname -s)" in
  Darwin) OS=macos ;;
  *)      OS=linux ;;
esac

# ---------------------------------------------------------------------------
step "1/7 System-Pakete"
if [ "$OS" = macos ]; then
  if command -v brew >/dev/null; then
    # tree-sitter-cli = CLI-Binary (die Formel "tree-sitter" ist nur die Library)
    brew install neovim git make curl ripgrep fd tree-sitter-cli node go python3 lazygit
    # git/curl/make/python3 liefert macOS zwar mit, Homebrew-Versionen sind aber
    # neuer; Compiler kommt von den Xcode Command Line Tools:
    xcode-select -p >/dev/null 2>&1 || xcode-select --install || true
  else
    warn "Homebrew fehlt. Installieren mit:"
    warn '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    warn "und danach dieses Skript erneut starten."
    exit 1
  fi
elif command -v apt >/dev/null; then
  sudo apt update
  sudo apt install -y neovim git gcc make curl unzip tar ripgrep fd-find \
    tree-sitter-cli nodejs npm golang-go python3 python3-venv python3-pip \
    lazygit xclip
else
  warn "Kein apt/brew gefunden – Pakete aus ABHAENGIGKEITEN.md bitte manuell installieren."
fi

# ---------------------------------------------------------------------------
step "2/7 Neovim-Version prüfen"
ver="$(nvim --version | head -1 | sed 's/NVIM v//')"
major="${ver%%.*}"; rest="${ver#*.}"; minor="${rest%%.*}"
if (( major == 0 && minor < 12 )); then
  warn "Neovim $ver ist zu alt (mindestens 0.12 nötig)."
  warn "Siehe INSTALLATION.md → 'Neovim ist zu alt'. Abbruch."
  exit 1
fi
echo "Neovim $ver ok"

# ---------------------------------------------------------------------------
step "3/7 Rust-Komponenten"
if ! command -v rustup >/dev/null && [ -x "$HOME/.cargo/bin/rustup" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi
if command -v rustup >/dev/null; then
  rustup component add rust-analyzer rust-src rustfmt clippy
else
  warn "rustup nicht gefunden – Rust-LSP fehlt. Installieren mit:"
  warn "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
  warn "und danach dieses Skript erneut starten."
fi

# ---------------------------------------------------------------------------
step "4/7 JetBrainsMono Nerd Font"
if [ "$OS" = macos ]; then
  if ls ~/Library/Fonts /Library/Fonts 2>/dev/null | grep -qi "JetBrainsMonoNerdFont"; then
    echo "Schrift bereits installiert"
  else
    brew install --cask font-jetbrains-mono-nerd-font
    echo "Schrift installiert"
  fi
else
  FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
  if fc-list | grep -q "JetBrainsMono Nerd Font Mono"; then
    echo "Schrift bereits installiert"
  else
    mkdir -p "$FONT_DIR"
    curl -fsSL -o "$FONT_DIR/f.tar.xz" \
      https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    tar -xf "$FONT_DIR/f.tar.xz" -C "$FONT_DIR"
    rm "$FONT_DIR/f.tar.xz"
    fc-cache -f >/dev/null
    echo "Schrift installiert"
  fi
fi

# ---------------------------------------------------------------------------
step "5/7 Konfiguration einrichten"
target="$(readlink -f "$CONFIG_DIR" 2>/dev/null || true)"
if [ "$target" = "$HERE/config" ]; then
  echo "Config ist bereits verlinkt"
else
  if [ -e "$CONFIG_DIR" ] || [ -L "$CONFIG_DIR" ]; then
    backup="$CONFIG_DIR.bak-$(date +%Y%m%d-%H%M%S)"
    mv "$CONFIG_DIR" "$backup"
    warn "Vorhandene Config gesichert nach $backup"
  fi
  mkdir -p "$(dirname "$CONFIG_DIR")"
  if [ -d "$HERE/.git" ]; then
    # Git-Klon: verlinken, damit git pull / git push die Config synchron halten
    ln -s "$HERE/config" "$CONFIG_DIR"
    echo "Config verlinkt: $CONFIG_DIR -> $HERE/config"
  else
    # USB-Stick o.ä.: kopieren
    cp -r "$HERE/config" "$CONFIG_DIR"
    # FAT32-Sticks setzen komische Rechte → normalisieren
    find "$CONFIG_DIR" -type d -exec chmod 755 {} +
    find "$CONFIG_DIR" -type f -exec chmod 644 {} +
    echo "Config kopiert nach $CONFIG_DIR"
  fi
fi

# ---------------------------------------------------------------------------
step "6/7 Plugins (exakte Versionen aus lazy-lock.json)"
nvim --headless "+Lazy! restore" +qa

# ---------------------------------------------------------------------------
step "7/7 LSP-Server, Formatter & Treesitter-Parser"
nvim --headless -c "MasonInstall lua-language-server typescript-language-server pyright ruff gopls stylua prettierd goimports" -c qa || \
  warn "Mason-Installation meldete Fehler – in nvim ':Mason' prüfen."

PARSERS='"rust","lua","luadoc","javascript","typescript","tsx","jsdoc","python","go","gomod","gosum","gowork","json","yaml","toml","html","css","markdown","markdown_inline","bash","vim","vimdoc","query","regex","diff","git_config","gitcommit","gitignore","dockerfile","sql"'
nvim --headless "+lua require('nvim-treesitter').install({$PARSERS}):wait(900000)" +qa || true

# nvim-treesitter bricht Builds nach 60 s ab – gitcommit ist auf manchen
# Rechnern langsamer. Dann von Hand bauen.
SITE="$DATA_DIR/site"
if [ ! -f "$SITE/parser/gitcommit.so" ]; then
  warn "gitcommit-Parser fehlt – baue ihn manuell (kann ein paar Minuten dauern)"
  rev="$(grep -A3 '^  gitcommit = {' "$DATA_DIR/lazy/nvim-treesitter/lua/nvim-treesitter/parsers.lua" \
         | sed -n "s/.*revision = '\(.*\)'.*/\1/p")"
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/gbprod/tree-sitter-gitcommit/archive/$rev.tar.gz" | tar -xz -C "$tmp"
  (cd "$tmp"/tree-sitter-gitcommit-* && tree-sitter build -o parser.so)
  mkdir -p "$SITE/parser" "$SITE/queries" "$SITE/parser-info"
  cp "$tmp"/tree-sitter-gitcommit-*/parser.so "$SITE/parser/gitcommit.so"
  ln -sfn "$DATA_DIR/lazy/nvim-treesitter/runtime/queries/gitcommit" "$SITE/queries/gitcommit"
  printf '%s' "$rev" > "$SITE/parser-info/gitcommit.revision"
  rm -rf "$tmp"
fi

# ---------------------------------------------------------------------------
step "Fertig!"
if [ "$OS" = macos ]; then
cat <<EOF
Noch zu tun:
  1. Im Terminal die Schrift "JetBrainsMono Nerd Font Mono" einstellen
     (Terminal.app: Einstellungen > Profile > Schrift,
      iTerm2/Ghostty/WezTerm: font family in der jeweiligen Config).
  2. nvim starten und :checkhealth ausführen.
  3. Tastenbelegung: ~/.config/nvim/KEYMAPS.md  (in nvim: <Leertaste>fn)
EOF
else
cat <<EOF
Noch zu tun:
  1. Im Terminal die Schrift "JetBrainsMono Nerd Font Mono" einstellen
     (Konsole: vorher ALLE Konsole-Fenster schließen und neu öffnen).
     Optional: konsole-Catppuccin.profile nach ~/.local/share/konsole/ kopieren.
  2. nvim starten und :checkhealth ausführen.
  3. Tastenbelegung: ~/.config/nvim/KEYMAPS.md  (in nvim: <Leertaste>fn)
EOF
fi
