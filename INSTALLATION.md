# Installation auf einem neuen Rechner

## Inhalt des Repos

```
neovim-setup/
├── INSTALLATION.md              ← diese Anleitung
├── ABHAENGIGKEITEN.md           ← alle Pakete, Tools, Plugins mit Versionen
├── install.sh                   ← installiert alles automatisch
├── konsole-Catppuccin.profile   ← optional: Konsole-Profil (Catppuccin + Nerd Font)
└── config/                      ← die eigentliche Neovim-Config (→ ~/.config/nvim)
    ├── init.lua
    ├── KEYMAPS.md               ← Übersicht aller Tastenkürzel
    ├── lazy-lock.json           ← fixierte Plugin-Versionen
    └── lua/config/…
```

---

## Variante A: Automatisch (empfohlen, Debian/Ubuntu/Kali)

```bash
sudo apt install -y git
git clone https://github.com/TheAimWolf/neovim-setup.git ~/neovim-setup
bash ~/neovim-setup/install.sh
```

Aus einem Git-Klon wird `~/.config/nvim` als **Symlink** auf `~/neovim-setup/config` angelegt.
Änderungen an der Config landen damit direkt im Repo (siehe **„Config synchron halten“**).

Vom USB-Stick geht es genauso – dann wird die Config **kopiert** statt verlinkt:

```bash
# Stick-Pfad anpassen (KDE: /run/media/$USER/ESD-USB, Ubuntu: /media/$USER/ESD-USB)
bash /run/media/$USER/ESD-USB/neovim/install.sh
```

> `bash install.sh` statt `./install.sh`, weil FAT32-Sticks keine Ausführungsrechte speichern.

Das Skript
1. installiert die System-Pakete per `apt` (fragt nach dem sudo-Passwort),
2. prüft, ob Neovim ≥ 0.12 ist,
3. fügt `rust-analyzer`, `rust-src`, `rustfmt`, `clippy` über rustup hinzu,
4. installiert die JetBrainsMono Nerd Font nach `~/.local/share/fonts`,
5. sichert eine vorhandene `~/.config/nvim` (→ `nvim.bak-DATUM`) und verlinkt bzw. kopiert die Config,
6. installiert alle Plugins in den Versionen aus `lazy-lock.json`,
7. installiert LSP-Server, Formatter und Treesitter-Parser.

Danach weiter bei **„Nach der Installation“**.

---

## Variante B: Manuell

### 1. System-Pakete
```bash
sudo apt update
sudo apt install -y neovim git gcc make curl unzip tar ripgrep fd-find tree-sitter-cli \
  nodejs npm golang-go python3 python3-venv python3-pip lazygit xclip
nvim --version | head -1     # muss v0.12 oder neuer sein
```

### 2. Rust
```bash
# nur falls rustup fehlt:
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup component add rust-analyzer rust-src rustfmt clippy
```

### 3. Schrift
```bash
mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd && cd ~/.local/share/fonts/JetBrainsMonoNerd
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
tar -xf JetBrainsMono.tar.xz && rm JetBrainsMono.tar.xz
fc-cache -f
```

### 4. Config einrichten
```bash
[ -e ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/TheAimWolf/neovim-setup.git ~/neovim-setup
ln -s ~/neovim-setup/config ~/.config/nvim
```

### 5. Plugins, LSPs, Parser
```bash
nvim --headless "+Lazy! restore" +qa
nvim --headless -c "MasonInstall lua-language-server typescript-language-server pyright ruff gopls stylua prettierd goimports" -c qa
nvim      # Treesitter-Parser werden beim ersten Start automatisch gebaut (dauert etwas)
```

---

## Nach der Installation

1. **Terminal-Schrift auf „JetBrainsMono Nerd Font Mono“ stellen.**
   - *Konsole:* erst **alle** Konsole-Fenster schließen und neu öffnen (sonst ist die Schrift nicht in der Liste),
     dann Einstellungen → Profil bearbeiten → Erscheinungsbild → Schrift.
     Oder das mitgelieferte Profil nutzen:
     ```bash
     mkdir -p ~/.local/share/konsole
     cp ~/neovim-setup/konsole-Catppuccin.profile ~/.local/share/konsole/Catppuccin.profile
     ```
     (Das Profil verweist auf das Farbschema `catppuccin-mocha` – das muss dort ggf. separat installiert werden:
     <https://github.com/catppuccin/konsole>. Ohne es nutzt Konsole die Standardfarben.)
2. `nvim` starten, `:checkhealth` ausführen – Warnungen zu nicht genutzten Sprachen (Java, PHP, …) sind egal.
3. `:Lazy` → Plugins, `:Mason` → LSPs/Formatter, `:TSUpdate` → Parser aktualisieren.
4. Tastenkürzel: `KEYMAPS.md` bzw. in nvim `<Leertaste>` drücken und kurz warten.

---

## Config synchron halten

```bash
# Änderungen von einem Rechner hochladen
cd ~/neovim-setup
git add -A && git commit -m "nvim: ..." && git push

# auf den anderen Rechnern holen
cd ~/neovim-setup && git pull
nvim --headless "+Lazy! restore" +qa     # Plugins auf die Versionen aus lazy-lock.json bringen
```

Plugins aktualisieren: in nvim `:Lazy update` → `lazy-lock.json` ändert sich → committen & pushen.

---

## Probleme & Lösungen

| Problem | Lösung |
|---|---|
| **Neovim ist zu alt** (apt liefert < 0.12, z.B. Ubuntu LTS / Debian stable) | Offizielles Release nutzen: `curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz && sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim` |
| `tree-sitter-cli` nicht in apt | `cargo install --locked tree-sitter-cli` (nicht über npm!) |
| `gitcommit`-Parser: *„parser.so not found after build attempt“* | nvim-treesitter bricht Builds nach 60 s ab. `install.sh` erneut ausführen – es baut den Parser dann manuell. |
| Icons sind Kästchen / Fragezeichen | Terminal-Schrift nicht umgestellt oder Terminal nicht neu gestartet. |
| Lua-Dateien: *„Parser could not be created … language lua“* | Wird in `lua/config/lazy.lua` über `performance.rtp.paths = { "/usr/lib/nvim" }` gelöst (Debian legt eingebaute Parser dort ab). Auf anderen Distros ist der Eintrag harmlos. |
| `ts_ls`/`pyright`/`gopls` fehlen | Node bzw. Go war bei der Installation nicht da → nachinstallieren, dann in nvim `:Mason` → Paket mit `i` installieren. |
| rust-analyzer startet nicht | `rustup component add rust-analyzer rust-src`; Projekt muss eine `Cargo.toml` haben. |
| Zwischenablage geht nicht | X11: `xclip`, Wayland: `sudo apt install wl-clipboard`. |
| Andere Distro | Arch: `sudo pacman -S neovim git base-devel ripgrep fd tree-sitter-cli nodejs npm go python lazygit xclip` (dort heißt fd `fd`, das passt automatisch). Fedora: `sudo dnf install neovim git gcc make ripgrep fd-find tree-sitter-cli nodejs npm golang python3 lazygit xclip`. |
