---
name: short
description: Jawab SINGKAT, PADAT, LUGAS. Dipanggil user dengan "/short" — boleh di awal pertanyaan (minta jawaban pendek sejak awal) atau sesudah jawaban panjang (minta diringkas ulang). Pakai juga saat user bilang "terlalu bertele-tele", "singkat saja", "to the point".
---

# /short — Jawab singkat, padat, lugas

Memangkas **OUTPUT**; `/smart` memangkas **INPUT** — beda sisi, boleh bersamaan.
Ini menegakkan invariant "Gaya output (caveman untuk narasi)" di `CLAUDE.md` pada satu
jawaban tertentu. Kalau user memintanya berkali-kali, itu bukan selera sesaat: naikkan jadi
baris tetap di `CLAUDE.md` (lihat §Naikkan jadi aturan di bawah).

## Bentuk

- **Jawaban dulu, di kalimat pertama.** Baru alasannya. Jangan menunda kesimpulan.
- **Maksimal ±12 baris.** Kalau tak muat, berarti belum diputuskan mana yang penting.
- **Butir, bukan paragraf.** Satu butir satu gagasan.
- **Angka, bukan kata sifat.** "Rp 1,9 jt/bulan" bukan "lumayan besar"; "840 ms" bukan "agak lambat".
- **Bahasa awam.** Istilah teknis hanya kalau user yang menyebutnya duluan — kalau harus, sederhanakan pakai analogi.
- Tabel hanya kalau membandingkan ≥3 hal. Kalau 2 hal, pakai kalimat.

## Buang

- Pembukaan ("Baik, saya cek dulu…"), penutup basa-basi, pengulangan pertanyaan user.
- Riwayat bagaimana jawabannya ditemukan — kecuali diminta.
- Pilihan yang tidak kamu rekomendasikan, kecuali user memang sedang memilih.
- Peringatan yang tidak mengubah tindakan apa pun.
- Permintaan maaf dan pembelaan diri. Juga: menawarkan kerja tambahan yang tak diminta.

## Tetap wajib ada walau pendek

- **Angka yang menentukan keputusan.** Memendekkan tidak boleh membuang buktinya.
- **Rekomendasi**, kalau ada pilihan. Jangan sodorkan menu tanpa pendapat.
- **Peringatan hal sulit dibalik** (uang, data prod, deploy, publikasi) — ini tak pernah boleh dipotong.
- **Yang belum pasti**, ditandai jelas. Pendek bukan alasan terdengar lebih yakin dari kenyataan.
- **`berkas:baris`** untuk tiap klaim tentang kode.

## Jangan

- Jangan memendekkan dengan cara menghapus syarat atau risiko — itu bukan ringkas, itu menyesatkan.
- Jangan kehilangan verbatim: kode, perintah, nama berkas/API/flag, pesan galat tetap utuh.
- Jangan pakai singkatan karangan (cfg/impl) — tokenizer tak menghemat apa pun, pembaca rugi.

## Naikkan jadi aturan (kalau user memintanya >2×)

Permintaan berulang = masalah sistemik, bukan satu jawaban. Tulis 1 baris di blok Invariants
`CLAUDE.md` (mis. _"GAYA JAWAB WAJIB: ringkas & bahasa awam; panjang hanya bila diminta"_) +
tanggal & siapa yang meminta. Aturan berupa **kata sifat** ("ringkas") tak bisa dicek —
kalau masih bocor, pasang **angka** (maks N baris / N kata) atau hook.
