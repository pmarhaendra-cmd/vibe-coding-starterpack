<!-- OPT-IN: salin template ini HANYA untuk fitur besar (multi-layar / lintas-sesi / banyak aturan).
     Fitur kecil cukup hidup di BACKLOG.md + DECISIONS.md — berkas kosong yang tak pernah diisi
     cuma jadi kewajiban hantu saat /handoff. Lihat catatan di FEATURE-SCOPE.md. -->

# {Nama Fitur}
Untuk apa: {1 baris — fungsi fitur ini untuk user}

Status: {Mode A / Mode B}
Langkah berikutnya: {1 baris — biar sesi berikutnya tahu mulai dari mana}
Keputusan terkait: {D-00x, D-00y — tunjuk ke DECISIONS.md, JANGAN tulis ulang isinya}

── Layar & keadaan ──────────────────────
<!-- Tiap layar + kondisinya. Tandai [FAKTA]/[ASUMSI]. (Ini dulu di screen-spec.md, kini nempel di fiturnya.) -->
- {layar}: {keadaan}

── Aturan ───────────────────────────────
<!-- Logika/perilaku/validasi khas fitur ini. Tandai [FAKTA]/[ASUMSI]. -->
- [FAKTA] {...}
- [ASUMSI] {...}

── Selesai bila ─────────────────────────
<!-- Kriteria terima: fitur SELESAI hanya bila semua tercentang — diverifikasi (jalankan/tes), bukan diasumsikan. Ini target untuk aturan "verify sebelum diagnosa". -->
- [ ] {perilaku teramati — mis. "user bisa X dan melihat Y"}
- [ ] {cara test: langkah manual ATAU perintah test otomatis}

── Prototype ────────────────────────────
- {prototype/nama.html — bila ada}

── Log build (terbaru di atas) ──────────
<!-- Terisi saat Mode B: apa yang berubah saat membangun. -->
- {tanggal} — {perubahan}
