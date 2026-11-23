# Runbook Deploy — {NAMA PROYEK}

> **TEMPLATE — isi saat proyek sudah punya target deploy nyata.** File ini = *perintah & detail spesifik proyek*; skill `/deploy` menjaga *urutan & rambu keselamatan*; aturan eksekusi umum (pipe safety, verify artefak berubah, secrets, batas resource) → `technical-rules.md`. Sampai infra jelas, biarkan `{placeholder}`.

## Target
- **Lingkungan:** {prod / staging — URL}
- **Host/platform:** {mis. VPS, Vercel, container registry}
- **Arsitektur build:** {mis. build di laptop bukan server; flag arsitektur}

## Prasyarat (sekali per mesin)
- {tool CLI + versi · akses/login · env var yang harus ada — nilai di `access/secrets/`, indeks di `access/MANIFEST.md`}

## Prosedur rilis (urut)
1. **Local-first:** test 100% sukses lokal dulu. {perintah test}
2. **Build:** {perintah} → **verify artefak BERUBAH** (hash/timestamp/versi), bukan sekadar exit 0.
3. **Deploy code-only:** {perintah}. Migrasi/mutasi data = **langkah terpisah + izin eksplisit**.
4. **Verify pasca-deploy:** {endpoint/health-check yang membuktikan versi baru live} — bukan asumsi "perintah sukses".

## Rollback
- **Cara:** {perintah/tag/commit untuk balik ke versi sebelumnya}
- **Backup sebelum rilis:** {apa yang di-backup + di mana}

## Pra-launch (sekali, sebelum rilis publik pertama)
- [ ] Meta title/description + OG image + favicon
- [ ] Halaman 404 ada · semua form dites kirim sungguhan
- [ ] Cek mobile + browser utama (bukan hanya viewport dev)
- [ ] Domain + SSL aktif · uptime monitor sederhana terpasang
- [ ] **`/security-review`** atas perubahan menjelang LIVE (skill bawaan Claude Code — tanpa install)
- [ ] {analytics — hanya bila diminta klien}

## Pasca-launch (tagih tujuan — jangan dilewati)
Setelah stabil beberapa hari: **cek hasil terhadap "Definisi sukses" di `PROBLEM-GOAL.md`** — tercapai / belum / butuh data apa untuk mengukurnya. Catat verdict 1 baris ke `CHANGELOG.md`; bila memicu keputusan/scope baru → `DECISIONS.md` / `BACKLOG.md`. Proyek belum "selesai" hanya karena sudah live.

## Rambu (dari CLAUDE.md — jangan dilanggar)
- Tidak deploy di jam sibuk {mis. 11:00–22:00} tanpa izin.
- Tidak auto-commit/auto-push tanpa diminta.
- Source of truth data = {prod/lokal}; sync sebelum kerja yang menyentuh data.

## Jebakan deploy (gejala → fix)
<!-- Catat langsung saat ketemu, supaya sesi berikut tak diagnosa ulang. -->
- **Deploy bisa gagal SENYAP — "ada" ≠ "bekerja".** Kasus nyata: berkas konfigurasi tak ikut terkirim (hanya artefak build); env var benar di `.env`, container di-recreate, app hijau — tapi variabelnya **tak pernah sampai** karena konfigurasi di server masih versi lama. Nol error; fiturnya diam-diam mati. **Fix:** `diff` konfigurasi server vs lokal SEBELUM rilis · paksa recreate · **uji panggil fiturnya sungguhan** sesudahnya, bukan cek "env ada".
- Daftar jebakan lintas-topik (pipa menyembunyikan kegagalan, skrip melapor sukses padahal gagal, verifikator yang menipu) → `technical-rules.md` §Jebakan mahal.
- {—}
