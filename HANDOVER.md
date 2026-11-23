# HANDOVER — {NAMA PROYEK}

> Panduan serah-terima untuk anggota tim yang melanjutkan proyek **di komputernya sendiri**. Aturan kerja & bahasa ada di `CLAUDE.md` — baca itu dulu. _(Opsional — isi hanya saat benar-benar serah-terima; sampai saat itu biarkan template.)_

## 1. Apa proyek ini
{1 paragraf: untuk siapa · apa yang dibangun · sampai mana visinya}

## 2. Status kini
{fase · apa yang selesai & terverifikasi · apa yang aktif dikerjakan · apa yang menggantung}
Detail: "Status kini" di `CLAUDE.md` + `BACKLOG.md` + `CHANGELOG.md`.

## 3. Struktur folder
{pohon singkat + 1 baris fungsi tiap folder — termasuk mana yang gitignored}

## 4. Cara menjalankan
{perintah run per komponen (prototype/app/server) + prasyarat (Node, key, dsb.)}

## 5. Dokumen kunci
| Butuh apa | Buka |
|---|---|
| Keputusan terkonfirmasi | `DECISIONS.md` |
| Antrian kerja | `BACKLOG.md` |
| Spec per fitur | `FEATURE-SCOPE.md` (indeks) → `features/<nama>.md` bila fitur itu punya berkas |
| {lainnya} | {berkas} |

## 6. Memory & skill Claude (kontinuitas antar-mesin)
Memory, transkrip sesi, dan skill custom Claude Code hidup di `~/.claude/…` **mesin asal** — di luar folder proyek. Saat serah-terima: salin yang perlu ke `_handover/` (memory/, skills/, sessions/) supaya tim bisa restore. Yang tim siapkan sendiri: **login akun Claude sendiri**, MCP server ({daftar, mis. context7}), preferensi model.

## 7. ⚠️ Git TIDAK membawa konteks — catatan harus disalin manual

**Baca ini sebelum menganggap `git clone` = serah-terima.** Kebijakan proyek: **catatan `.md` gitignored** (lihat `.gitignore`). Yang ikut repo cuma **kode + `prototype/` + `access/MANIFEST.md` + `.claude/skills/` + berkas ini**. Semua konteks kerja — `CLAUDE.md`, `BACKLOG.md`, `DECISIONS.md`, `CHANGELOG.md`, profil, `docs/`, `features/`, `_archive/`, `context/` — **hanya ada di laptop {user}.** Clone repo tanpa langkah di bawah = mewarisi kode tanpa satu pun alasan di baliknya.

**Prosedur serah-terima (urut):**
1. `git status` di mesin asal — pastikan tak ada kerja uncommitted yang tertinggal.
2. **Salin bundel catatan** dari mesin asal (folder proyek, semua yang gitignored kecuali `node_modules`/build/`.env`): `CLAUDE.md` · `START-HERE.md` · `BACKLOG.md` · `DECISIONS.md` · `CHANGELOG.md` · `CLIENT-PROFILE.md` · `PROBLEM-GOAL.md` · `FEATURE-SCOPE.md` · `features/` · `docs/` · `_archive/` · `context/` · `.roo/`. Kirim lewat kanal privat (bukan publik — `context/` memuat data klien).
3. Penerima: clone repo → **tumpahkan bundel itu ke atas folder hasil clone** → baru buka Claude Code.
4. Verifikasi di mesin baru: `CLAUDE.md` auto-load? `BACKLOG.md` ada isinya? Kalau tidak, langkah 2 belum lengkap — **jangan mulai kerja.**

**Backup:** karena catatan di luar Git, **Git bukan backup.** Pastikan Time Machine/backup lain mencakup folder proyek. Laptop hilang tanpa backup = konteks hilang permanen.

**Git & akses:** branch kerja {branch} · remote {URL} · commit hanya bila diminta eksplisit. Kredensial: indeks di `access/MANIFEST.md` (tanpa nilai). **Regenerate/pakai key sendiri di mesin baru — jangan wariskan key lama.**

## 8. Catatan sensitif (baca sebelum menyebar)
{data klien/PII ada di folder mana (mis. `context/`) · apa yang gitignored · transkrip sesi memuat apa · apa yang tak boleh keluar tim}
