# Multi-LLM (opsional — hapus bila proyek 1 LLM)

Proyek boleh dikerjakan **beberapa LLM bergantian (TAK paralel)** — mis. Claude Code + {LLM lain via Roo Code/harness lain}.

## Arsitektur memory lintas-LLM
- **Otak/memory = file markdown lokal di folder proyek** (`CLAUDE.md`, `DECISIONS.md`, `BACKLOG.md`, `CHANGELOG.md`, `docs/`) — **gitignored**, lihat `.gitignore`. Konten LLM-agnostik.
- Yang beda per-tool hanya file **bootstrap** auto-load: Claude Code → `CLAUDE.md`; {tool lain} → `.roo/rules/00-brain.md` (menyuruh baca CLAUDE.md + protokol).
- **Sinkronisasi = disk yang sama.** Bukan paralel. **Jangan dua LLM menulis file yang sama bersamaan** — selesai giliran → LLM lain lanjut. ⚠️ Karena catatan gitignored, **commit bukan checkpoint untuk catatan** (disk-lah checkpoint-nya); commit tetap checkpoint untuk **kode**.

## Pembagian tugas
**Tak ada pembagian model** — user memilih model per-tugas. Satu-satunya rem = guardrail universal **"berhenti & konfirmasi sebelum hal sulit dibalik"** (data/uang/deploy) + aturan deploy/data di CLAUDE.md, berlaku untuk model mana pun.

## Padanan skill Claude → tool lain
| Claude skill | Di tool lain |
|---|---|
| `/handoff` | `docs/handoff-checklist.md` (manual) |
| `/deploy` | `docs/deploy.md` + guardrail CLAUDE.md |
| gerbang mutu | `npm run gerbang` (perintah agregat — sama untuk semua LLM) |

## Batasan verifikasi via gambar
Bila salah satu LLM **tidak bisa membaca gambar**: verifikasi hasil kerja **hanya lewat** log terminal, output CLI, response API, kode sumber, atau test otomatis — screenshot tidak boleh jadi satu-satunya konfirmasi (berlaku untuk SEMUA model demi konsistensi). Cek UI visual → minta user verifikasi manual.

## Prinsip portabilitas
Taruh "logika" di lapisan portable — **markdown** (memory) + **skrip** (`scripts/` — lihat `scripts/README.md`). Skill/mode per-tool hanya **pembungkus tipis**. Ganti LLM = tak perlu nulis ulang logika.
