# Ritual Handoff (versi manual — untuk LLM non-Claude)

Versi **manual** dari skill `/handoff` Claude (`.claude/skills/handoff/SKILL.md`). Jalankan saat menutup sesi. Tujuan: sesi berikut lanjut tanpa kehilangan konteks **dan catatan tetap ramping**.

## Langkah
1. **Sapu item BACKLOG yang selesai sesi ini.** Untuk tiap item DONE:
   - Milestone/deploy → entri `CHANGELOG.md`.
   - Keputusan → append `DECISIONS.md` (ber-ID `D-00x`, FAKTA/ASUMSI, `tanggal · topik · keputusan · alasan`).
   - Progress fitur → log build di `features/<nama>.md` **bila fitur itu punya berkas** (opt-in).
   - Pindahkan **1 baris ringkas** ke `_archive/backlog-archive.md` (`tanggal · item · hasil/commit`).
   - **HAPUS item itu dari `BACKLOG.md`.**
2. **Pastikan `BACKLOG.md` ramping** — hanya Inbox + item terbuka, **tanpa seksi DONE**. Item baru sesi ini **seharusnya sudah masuk Inbox saat diucapkan** (invariant "tangkap-seketika" di `CLAUDE.md`) — di sini cuma pastikan tak ada yang lolos, lalu triage. Handoff = jaring pengaman intake, bukan satu-satunya titik tangkap.
3. **Perbarui "Status kini" di `CLAUDE.md`** — **PENUNJUK, BUKAN RINCIAN**: mode · **berapa** item IN-PROGRESS & pending review (namanya saja) · "Mulai sesi dari" mana → sisanya "detail di BACKLOG". **Ini handoff inti.**
   - 🚨 **Langkah inilah yang membengkakkan `CLAUDE.md`**: tiap sesi menulis hasil kerjanya di blok atas padahal sudah lengkap di BACKLOG+DECISIONS — +1–2 KB per sesi, nol sesi menghapus (preseden: tembus 15.443 char, 2 paragraf 100% duplikat). **Saringan:** _"sudah ada di BACKLOG/DECISIONS/CHANGELOG?"_ → kalau ya, tulis penunjuknya saja. Yang boleh menetap cuma kalimat yang **mengubah tindakan sesi berikutnya**. **Handoff = pekerjaan MENGHAPUS juga.**
4. **Cek konsistensi + VERIFIKASI item terbuka ke KODE (bukan imbauan):**
   - 📏 **`wc -c CLAUDE.md` WAJIB dijalankan** — plafon **±12.000 char**. Lewat → pangkas SEKARANG (urutan: duplikat→penunjuk · rekap rilis→CHANGELOG · paragraf teknis→**pindah** ke `docs/` + sisakan 1 baris · baris kedaluwarsa), jangan diwariskan.
   - BACKLOG tak ada yang sebenarnya sudah DONE? `DECISIONS.md` lengkap (tak ada ASUMSI diam-diam jadi "fakta")? **Bila `features/` dipakai:** `FEATURE-SCOPE.md` sinkron dengannya? `git status` wajar?
   - **Spot-check item BACKLOG terbuka ke KODE HIDUP.** Tiap item yang menunjuk file/fungsi/perilaku → buka/grep, pastikan MASIH benar. Multi-LLM + sesi paralel = item sering diberesi di tempat lain tanpa baris backlog-nya ditandai. Yang ternyata beres → arsip + hapus. **Jangan percaya status backlog tanpa cek kode.**
   - 🚨 **ATURAN HASH-BASI.** Item "SELESAI DI-COMMIT `<hash>` — belum push/deploy" = jebakan; **hash BUKAN bukti**. Verifikasi lewat SIMBOL: `git merge-base --is-ancestor <hash> HEAD` (kalau bukan leluhur → hash mati, jangan simpulkan "belum deploy") lalu `grep -rl "<namaFungsi/kolom kunci>" <dir-kode>/` (kalau kodenya HIDUP di tree = BASI → arsipkan; cari commit penggantinya via `git log --oneline | grep <kata-kunci>` + Day rilisnya di `CHANGELOG.md`).
5. **Lapor ringkas ke user:** selesai apa, menggantung apa, langkah berikut. **Catatan `.md` = lokal & gitignored** (lihat `.gitignore`) → handoff murni operasi lokal, tak perlu commit. Kalau sesi menyentuh **kode**: itu langkah terpisah, **JANGAN auto-commit/push** tanpa persetujuan user.

## Catatan
Format & prinsip identik dengan skill Claude `/handoff`. Kalau salah satu berubah, **samakan dua-duanya** supaya tak drift.

**Uji terakhir sebelum menutup sesi:** kalau satu paragraf dihapus dari `CLAUDE.md`, apakah sesi berikutnya jadi salah bertindak? Kalau tidak → itu riwayat; tempatnya di BACKLOG/DECISIONS/CHANGELOG.
