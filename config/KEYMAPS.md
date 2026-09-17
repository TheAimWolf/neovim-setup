# Keymaps (Leader = Leertaste)

`<leader>` + kurz warten zeigt which-key mit allen Optionen. `<leader>fk` durchsucht alle Keymaps.

## QWERTZ
| Taste | Wirkung |
|---|---|
| `ö` / `ä` | wie `[` / `]` → `öd/äd` Diagnostic, `öq/äq` Quickfix, `öc/äc` Git-Hunk, `öb/äb` Buffer |

## Navigation
| Taste | Wirkung |
|---|---|
| `<leader>a` | Datei zu Harpoon hinzufügen |
| `Ctrl-e` | Harpoon-Menü (Reihenfolge per `dd`/`p` ändern) |
| `Ctrl-h/j/k/l` | Harpoon-Datei 1/2/3/4 |
| `<leader>hp` / `<leader>hn` | Harpoon vorherige / nächste |
| `-` / `<leader>pv` | Ordner der Datei (oil): Text editieren + `:w` = umbenennen/löschen/anlegen |
| `Ctrl-o` / `Ctrl-i` | Sprungliste zurück / vor (Standard) |
| `Ctrl-^` | Zur vorherigen Datei (Standard) |
| `Ctrl-w h/j/k/l` | Fenster wechseln (Standard) |

## Suchen (Telescope)
| Taste | Wirkung |
|---|---|
| `<leader>ff` | Dateien |
| `Ctrl-p` | Git-Dateien |
| `<leader>fa` | Alle Dateien inkl. ignorierter |
| `<leader>fg` | Projektweit Text suchen (live) |
| `<leader>fw` | Wort unter Cursor / Auswahl suchen |
| `<leader>fs` | Nach Eingabe suchen |
| `<leader>/` | In aktueller Datei |
| `<leader><leader>` | Offene Buffer |
| `<leader>fr` | Zuletzt geöffnet |
| `<leader>fo` / `<leader>fO` | Symbole Datei / Projekt |
| `<leader>fd` | Diagnostics |
| `<leader>fh` / `<leader>fk` | Hilfe / Keymaps |
| `<leader>f.` | Letzte Suche fortsetzen (mit Suchbegriff und Treffern) |
| `<leader>fp` | Frühere Suchen: Liste der letzten 10 Picker, Auswahl setzt sie fort |
| `<leader>fn` | Neovim-Config-Dateien |
| im Picker: `Ctrl-q` | Treffer → Quickfix-Liste |

## LSP
| Taste | Wirkung |
|---|---|
| `gd` / `gD` | Definition / Deklaration |
| `K` | Doku (Standard) |
| `grr` | Referenzen (Standard) |
| `gri` / `grt` | Implementierung / Typ (Standard) |
| `grn` / `<leader>r` | Umbenennen |
| `gra` / `<leader>c` | Code-Action |
| `gO` | Symbole (Standard) |
| `<leader>e` / `<leader>E` | Diagnostic-Popup / alle → Quickfix |
| `<leader>ti` | Inlay-Hints an/aus |
| `<leader>F` | Formatieren |
| `<leader>tf` | Format beim Speichern an/aus |

## Autocomplete (Insert)
`Ctrl-n`/`Ctrl-p` wählen · `Ctrl-y` übernehmen · `Ctrl-e` abbrechen · `Ctrl-Space` öffnen · `Tab`/`Shift-Tab` Snippet-Felder · `Ctrl-k` Signatur

## Editieren
| Taste | Wirkung |
|---|---|
| `J` / `K` (Visual) | Zeilen verschieben |
| `<` / `>` (Visual) | Einrücken, Auswahl bleibt |
| `<leader>p` (Visual) | Drüber einfügen ohne Register zu verlieren |
| `<leader>d` | Löschen ohne Yank |
| `<leader>s` | Wort unter Cursor überall ersetzen |
| `ys{motion}{z}` / `cs{alt}{neu}` / `ds{z}` | Surround: z.B. `ysiw"`, `cs"'`, `ds(` |
| `<leader>u` | Undotree |
| `<leader>n` | Zeilennummern relativ ↔ absolut |
| `<leader>tb` | Hintergrund: transparent (Terminal) ↔ rose-pine |
| `<leader>w` / `<leader>q` | Speichern / Fenster schließen |
| `<leader>x` | `chmod +x` |
| `Esc` | Suchmarkierung aus |

## Git
| Taste | Wirkung |
|---|---|
| `<leader>gg` | lazygit (im Repo der aktuellen Datei / des Explorer-Ordners) |
| `<leader>gs` | fugitive Status (`s` stage, `u` unstage, `cc` commit, `=` diff) |
| `<leader>gb` / `<leader>gd` / `<leader>gl` | Blame / Diff / Log |
| `äc` / `öc` | Nächster / voriger Hunk |
| `<leader>hs` / `<leader>hr` | Hunk stagen / zurücksetzen |
| `<leader>hS` / `<leader>hR` | Datei stagen / zurücksetzen |
| `<leader>hv` / `<leader>hb` | Hunk ansehen / Blame Zeile |

## Befehle
`:Lazy` Plugins · `:Mason` LSP/Formatter · `:ConformInfo` · `:checkhealth` · `:TSUpdate`
