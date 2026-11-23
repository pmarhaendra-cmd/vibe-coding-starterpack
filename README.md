# Starter Kit — Cara Kerja Development (reusable)

Kerangka pakai-ulang untuk proyek development bersama Claude — dari discovery → prototype → build → LIVE → serah-terima. Metode lengkap ada di `CLAUDE.md`; **kamu tidak perlu menghafalnya — AI yang menjalankan**.

## Untuk AI agent — kalau pengguna memberimu link repo ini
Kerjakan sendiri tanpa menyuruh pengguna mengetik perintah:
1. Clone ke folder proyek baru (atau ke folder kosong yang sedang dibuka: `git clone <link-repo-ini> .`).
2. Jalankan **`sh scripts/mulai.sh`** sekali di akar folder itu. Wajib — skrip ini memutus riwayat Git template dan memasang `.gitignore` proyek supaya catatan kerja kalian tetap lokal.
3. Baca `CLAUDE.md` (aturan kerja) lalu `START-HERE.md`, dan **jalankan isi blok "PROMPT AWAL" seolah pengguna yang menempelkannya**.
4. Bukan Claude Code? Titik masukmu `.roo/rules/00-brain.md` dan `docs/multi-llm.md`; skill di `.claude/skills/*/SKILL.md` tetap bisa dibaca sebagai instruksi biasa.

## Cara pakai manual (3 langkah)
1. **Clone/unduh** repo ini ke folder proyek baru, lalu jalankan **`sh scripts/mulai.sh` sekali** — memutus riwayat Git template dan memasang `.gitignore` proyek (catatan `.md` jadi lokal, di luar Git).
2. Buka Claude Code di folder itu, **paste "🚀 PROMPT AWAL" dari [START-HERE.md](START-HERE.md)**.
3. **Jawab pertanyaannya.** AI memimpin sisanya: setup tools → wawancara 1-per-1 → mencatat semuanya (keputusan, fitur, antrian) → prototype → build. Kamu bisa ambil alih kendali kapan saja; selama tidak, AI menentukan langkah sesuai kebutuhan. Tutup sesi dengan `/handoff`; sesi berikutnya paste "PROMPT LANJUTAN" dari file yang sama.

## Peta isi (dikelola AI — kamu cukup tahu ini ada)
| Berkas/folder | Fungsi |
|---|---|
| `CLAUDE.md` | Otak: metode kerja + status + indeks (auto-load tiap sesi) |
| `START-HERE.md` | Prompt awal & prompt lanjutan siap-tempel |
| `BACKLOG.md` → `_archive/` | Antrian kerja hidup → arsip item selesai |
| `DECISIONS.md` | Log keputusan append-only (FAKTA/ASUMSI, ber-ID `D-00x`) |
| `FEATURE-SCOPE.md` + `features/` | Indeks fitur (wajib) + 1 berkas per fitur **besar** (opt-in) |
| `CLIENT-PROFILE.md` · `PROBLEM-GOAL.md` | Konteks klien & masalah (Mode A) |
| `CHANGELOG.md` | Milestone lintas-fitur & riwayat rilis |
| `prototype/` · `context/` | Mockup HTML = kontrak visual (ikut Git) · aset/data sumber klien (read-only, **lokal**) |
| `DESIGN.md` | **Belum ada di awal** — lahir dari `/impeccable init` saat fase build. Kontrak visual yang ditegakkan `scripts/design-lint.mjs` → **wajib ikut Git** (satu-satunya pengecualian kebijakan catatan lokal) |
| `scripts/` | Penegak & alat yang ikut Git: `guard-*` (gerbang mutu) · `uji-*` · `sync-*` — lihat `scripts/README.md` |
| `docs/` | Dok teknis: `technical-rules.md` (langsung berlaku — termasuk **§Gerbang mutu** & **§Jebakan mahal**) · `companion-tools.md` (codeburn dll.) · `deploy.md` (isi saat ada target rilis) · `multi-llm.md` + `handoff-checklist.md` (bila >1 LLM) |
| `HANDOVER.md` · `access/MANIFEST.md` | Serah-terima tim · indeks kredensial (tanpa nilai) |
| `.claude/skills/` | Amunisi: **impeccable** (QC design, `/impeccable init` sekali di awal build) · **taste-skill** (arah visual anti-generik) · **gsap-*** (8 skill animasi) · **ponytail** (kode minimal — tangga YAGNI) · **smart** (hemat token sisi input: cari dulu, baca rentang) · **short** (jawab singkat) · **deploy** · **sync** (samakan lokal dgn prod + BUKTIKAN) — dua terakhir **template, isi dulu** · **handoff** (tutup sesi) |
| `.claude/launch.json` · `.claude/settings.json` | Dev server untuk Browser pane (sesuaikan port/perintah) · hook impeccable + **rem keselamatan** (deny-list perintah destruktif) |
| `.roo/rules/00-brain.md` | Bootstrap LLM non-Claude (hapus bila 1 LLM) |

## Aturan tetap
- **Catatan `.md` = LOKAL, di luar Git** (`.gitignore` sudah disiapkan). Repo tetap bersih & aman dibagikan; auto-load `CLAUDE.md` jalan dari disk. ⚠️ **Dua konsekuensi yang wajib diurus:** ① **Git bukan backup** — pastikan Time Machine/backup lain mencakup folder proyek · ② **clone repo TIDAK membawa konteks** — serah-terima butuh salin bundel catatan manual (prosedur: `HANDOVER.md` §7). **Pengecualian:** dokumen yang ditegakkan skrip di Git (mis. `DESIGN.md` ↔ `scripts/design-lint.mjs`) wajib ikut Git.
- **Konvensi nama file:** dokumen pilar di root = `UPPERCASE.md` · dokumen isi di subfolder = `lowercase-kebab.md` · semua bahasa Inggris.
- **Plafon keras `CLAUDE.md` ±12.000 karakter**, diukur `wc -c` tiap `/handoff` — bukan kira-kira. Terbukti perlu: tanpa angka, file itu tumbuh 1–2 KB/sesi dan tak pernah menyusut.
- Hapus berkas yang tak relevan untuk proyekmu; jaga ringkas (hemat token).

## Skill pihak ketiga (dibawa apa adanya, lisensi asli disertakan)
| Skill | Pembuat | Lisensi | Sumber |
|---|---|---|---|
| `impeccable` | Paul Bakaus | Apache 2.0 (+ `NOTICE.md`) | https://github.com/pbakaus/impeccable |
| `gsap-*` (8) | GreenSock | MIT | https://github.com/greensock/gsap-skills |
| `taste-skill` | Leonxlnx | MIT | https://github.com/Leonxlnx/taste-skill |
| `ponytail` | DietrichGebert | MIT | https://github.com/DietrichGebert/ponytail |

Lisensi tiap skill ada di folder skill-nya (`LICENSE`). Versi terakhir diselaraskan **23 Nov 2026** (taste-skill 2.5.1). Skill ini terus diperbarui pembuatnya — sebelum proyek besar, minta AI-mu membandingkan dengan sumber di atas dan menyalin versi terbarunya.

## Lisensi
Isi starterpack ini: **MIT** (lihat `LICENSE`). Skill pihak ketiga di `.claude/skills/` tetap memakai lisensi aslinya masing-masing (tabel di atas).
