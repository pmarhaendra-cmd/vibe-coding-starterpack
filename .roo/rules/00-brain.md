# Brain — {NAMA PROYEK} (WAJIB baca di awal sesi)

Kamu (LLM apa pun via Roo/harness lain) mengerjakan proyek ini **bergantian** dengan Claude Code. **Source of truth = file di disk repo ini, BUKAN memory internalmu.**

> _(Hapus folder `.roo/` bila proyek hanya memakai 1 LLM.)_

## Baca dulu sebelum kerja (urut)
1. `CLAUDE.md` — otak: cara kerja + invariants + **"Status kini"** + indeks dokumen. (Baris `@...` di dalamnya = sintaks import khusus Claude; baca file itu manual.)
2. `BACKLOG.md` — antrian kerja hidup (Inbox + item terbuka; **tanpa DONE**).
3. `DECISIONS.md` — keputusan yang sudah diambil. **Jangan langgar.**

Muat dokumen lain seperlunya sesuai indeks — **hemat token**.

## Aturan kerja (sama persis seperti Claude — jangan menyimpang)
- **Bahasa Indonesia.** Labeli **FAKTA vs ASUMSI**. **{user} yang memutuskan** — jangan isi diam-diam.
- **Narasi proses ringkas** (tanpa filler/preamble/rekap tak diminta). Pertanyaan/keputusan/warning tetap kalimat penuh. Kode/command/error verbatim.
- **Kode minimal:** tangga ponytail sebelum menulis kode (perlu ada? → reuse → stdlib → native → dependency terpasang → 1 baris → minimum). Jangan pangkas validasi/keamanan/a11y/permintaan eksplisit; kontrak visual = eksplisit (craft penuh). Detail: `.claude/skills/ponytail/SKILL.md`.
- Keputusan baru → **append `DECISIONS.md`**. Item BACKLOG selesai → arsipkan (daur hidup di CLAUDE.md).
- **Verify sebelum diagnosa:** ambil log/error asli dulu; UI sukses ≠ backend sukses. Sebelum menyatakan SELESAI: jalankan gerbang mutu proyek + tagih "Selesai bila" end-to-end (lulus typecheck+lint ≠ benar).
- **Tangkap-seketika:** permintaan/ide/temuan user → tulis ke `BACKLOG.md` Inbox SAAT ITU juga, jangan tunda ke akhir sesi.
- **Pola gagal yang harus dijaga:** ① menyimpulkan dari pola tanpa cek kodenya hidup · ② "membetulkan" kode agar cocok dgn harapan uji yang keliru · ③ mengubah kerja sendiri jadi "keputusan user" · ④ mengutip catatan lama tanpa membaca penggantinya.
- Verifikasi hasil kerja lewat log terminal / output CLI / response API / kode / test otomatis — **bukan screenshot** (lihat `docs/multi-llm.md`).
- **Mode A** (cari WHAT): jangan asumsi; **cek `context/`/dokumen dulu** sebelum bertanya; tanya 1-per-1 + **rekomendasi + alasan**; **tegur kontradiksi** antar-jawaban; **sapu ASUMSI terbuka** sebelum engsel A→B → konvergen → catat. **Mode B** (eksekusi): otonom untuk mekanik, **berhenti & konfirmasi** bila: ubah yang dilihat user di luar kesepakatan / tak tercakup keputusan / geser scope / **sulit dibalik** (data/biaya/keamanan/deploy).

## Akhir sesi (pengganti skill `/handoff` milik Claude)
Lakukan **manual** ikut checklist: `docs/handoff-checklist.md`.

## Sinkronisasi antar-LLM
Berbagi disk yang sama → perubahan langsung terlihat. **Jangan jalan paralel di file yang sama.** Selesai giliran → LLM lain lanjut. ⚠️ Catatan `.md` **gitignored** (lokal) → commit BUKAN checkpoint untuk catatan; disk-lah checkpoint-nya. Commit tetap checkpoint untuk **kode**.
