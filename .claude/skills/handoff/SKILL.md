---
name: handoff
description: Tutup sesi kerja dengan rapi & siapkan handoff untuk sesi berikutnya — sapu item BACKLOG yang selesai ke arsip + changelog/decisions, ramping-kan BACKLOG, perbarui "Status kini" di CLAUDE.md. Pakai saat mengakhiri sesi kerja, atau saat user bilang "tutup sesi" / "handoff" / "beres-beres dulu".
---

# /handoff — Tutup Sesi & Handoff

Tujuan: sesi berikutnya bisa langsung lanjut tanpa kehilangan konteks, **dan catatan tetap ramping** (cegah bloat). Ini menegakkan "Daur hidup catatan" di `CLAUDE.md`.

## Langkah

1. **Sapu item BACKLOG yang selesai sesi ini.** Untuk tiap item yang jadi DONE:
   - Milestone/deploy → entri `CHANGELOG.md` (format: `Day N · tanggal · commit — ringkasan · rollback · backup`).
   - Keputusan → append `DECISIONS.md` (ber-ID `D-00x`, label FAKTA/ASUMSI, `tanggal · topik · keputusan · alasan`).
   - Progress fitur → update **log build** di `features/<nama>.md` **bila fitur itu punya berkas** (opt-in; fitur kecil cukup hidup di BACKLOG+DECISIONS).
   - Pindahkan **1 baris ringkas** ke `_archive/backlog-archive.md` (`tanggal · item · hasil/commit`).
   - **HAPUS item itu dari `BACKLOG.md`.**

2. **Pastikan `BACKLOG.md` ramping** — hanya Inbox + item terbuka. **Tidak boleh ada seksi DONE.** Permintaan/ide/temuan baru sesi ini **seharusnya sudah masuk Inbox saat diucapkan** (invariant "tangkap-seketika" di `CLAUDE.md`) — di sini cuma **pastikan tak ada yang lolos**, lalu triage ke prioritas. Handoff = jaring pengaman intake, bukan satu-satunya titik tangkap.

3. **Perbarui "Status kini" di `CLAUDE.md`** — **PENUNJUK, BUKAN RINCIAN.** Isinya cuma: mode (A/B) · **ada berapa** item IN-PROGRESS & pending review user (namanya saja) · "Mulai sesi dari" mana → sisanya **"detail di BACKLOG"**. **Ini handoff inti.** (Bila fase berubah, perbarui juga blok prompt di `START-HERE.md`.)
   - 🚨 **JEBAKAN UTAMA SKILL INI — langkah inilah yang membengkakkan `CLAUDE.md`.** Tiap sesi menuliskan **hasil kerjanya** di blok atas, padahal isi yang sama sudah lengkap di BACKLOG + DECISIONS. Satu sesi +1–2 KB, **nol sesi menghapus**, karena tiap paragraf terasa penting *hari itu*. Preseden nyata: file tembus 15.443 char; dua paragraf (1.333 + 1.201 char) **100% duplikat**.
   - **Saringan wajib sebelum menulis 1 kalimat pun ke blok atas:** _"sudah ada di BACKLOG/DECISIONS/CHANGELOG?"_ → kalau **ya**, tulis **penunjuknya saja.** Yang boleh menetap di blok atas hanya kalimat yang **mengubah tindakan sesi berikutnya** (mis. gotcha biaya/waktu di prod, jebakan branch belum-merge) — bukan riwayat, bukan laporan hasil, bukan rekap deploy.
   - **Handoff = pekerjaan MENGHAPUS, bukan hanya menambah.** Sebelum selesai: sapu blok atas dari kalimat usang (rilis yang sudah keluar, keputusan yang sudah masuk DECISIONS, tanggal yang sudah lewat).

4. **Cek konsistensi + VERIFIKASI item terbuka ke KODE (bukan imbauan):**
   - 📏 **UKUR, jangan kira-kira: `wc -c CLAUDE.md` WAJIB dijalankan.** Plafon **±12.000 char**. Lewat → **pangkas SEKARANG sebelum handoff dinyatakan selesai**, jangan diwariskan ke sesi berikutnya. Urutan pangkas yang terbukti: ① paragraf yang duplikat BACKLOG/DECISIONS → ganti penunjuk · ② rekap rilis yang sudah keluar → sudah ada di CHANGELOG · ③ paragraf teknis panjang → **pindahkan** ke `docs/` + sisakan 1 baris (memindahkan ≠ membuang) · ④ baris indeks yang tanggalnya sudah lewat. **Alasan plafonnya berupa angka: penilaian per-sesi selalu bilang "yang ini penting", cuma angka yang tak bisa dibujuk.**
   - Item terbuka di `BACKLOG.md` masih relevan (tak ada yang sebenarnya sudah DONE)?
   - **Spot-check item BACKLOG terbuka ke KODE HIDUP.** Tiap item yang menunjuk file/fungsi/perilaku spesifik → buka/grep, pastikan MASIH benar. Multi-LLM (model bergantian) + sesi paralel = item sering diberesi di tempat lain **tanpa baris backlog-nya ditandai**. Yang ternyata sudah beres → arsip + hapus (langkah 1). **Jangan percaya status backlog tanpa cek kode.**
   - 🚨 **ATURAN HASH-BASI (titik yang paling sering bocor).** Item berlabel **"SELESAI DI-COMMIT `<hash>` — belum push/belum deploy"** = jebakan: bunyinya seperti kerja pending, padahal WIP-nya sering sudah di-rebase/ganti hash lalu ter-deploy. **Hash BUKAN bukti.** Verifikasi WAJIB lewat SIMBOL, bukan hash:
     - `git merge-base --is-ancestor <hash> HEAD` → kalau BUKAN leluhur, hash itu **mati** — JANGAN simpulkan "belum deploy", lanjut cek simbol.
     - `grep -rl "<namaFungsi/kelas/kolom kunci>" <dir-kode>/` → kalau kodenya **HIDUP** di tree = **BASI**, arsipkan; cari commit penggantinya (`git log --oneline | grep <kata-kunci>`) + Day rilisnya di `CHANGELOG.md`.
     - Item ber-migrasi: cek CHANGELOG apakah migrasinya sudah jalan. Jangan tandai "belum deploy" hanya karena hash catatan tak cocok HEAD.
   - `DECISIONS.md` memuat semua keputusan yang disebut di percakapan? Tidak ada ASUMSI diam-diam yang lolos jadi "fakta"?
   - **Bila proyek memakai `features/`** (opt-in): `FEATURE-SCOPE.md` masih sinkron dengan isinya? Kalau proyek tak memakainya, lewati — jangan bikin kewajiban hantu.
   - `git status` bersih / untracked memang disengaja?

5. **Lapor ringkas ke user:** apa yang selesai, apa yang menggantung, langkah berikut yang disarankan. **Catatan `.md` = lokal & gitignored** (lihat `.gitignore`), jadi `/handoff` murni operasi lokal — tak perlu commit. Kalau sesi ini juga menyentuh **kode**, itu langkah terpisah: **JANGAN auto-commit/push** tanpa diminta user.

## Prinsip
File yang dibaca tiap sesi (`BACKLOG.md`, "Status kini" `CLAUDE.md`) WAJIB ramping — **dua-duanya, bukan BACKLOG saja.** Yang tumbuh (`CHANGELOG.md`, `DECISIONS.md`, `features/*.md`, `_archive/`) dibaca on-demand, jadi boleh panjang. **Uji terakhir sebelum menutup sesi: kalau satu paragraf dihapus dari `CLAUDE.md`, apakah sesi berikutnya jadi salah bertindak?** Kalau tidak → paragraf itu riwayat; tempatnya di BACKLOG/DECISIONS/CHANGELOG.

## Catatan
- LLM non-Claude menjalankan versi manual: `docs/handoff-checklist.md`. Kalau salah satu berubah, **samakan dua-duanya**.
- Kalau sesi menyentuh kode yang perlu dirilis, itu langkah terpisah dengan izin user (lihat skill `/deploy`).
