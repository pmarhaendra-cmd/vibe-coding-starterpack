---
name: smart
description: Mode hemat token sisi INPUT — cari lokasi dulu, baca rentang baris, batch, dan jangan menyimpulkan "tidak ada" dari grep kosong. Pakai saat user bilang "/smart", "hemat token", "boros konteks", "jangan baca semua", atau sebelum menjelajah repo besar / berkas >500 KB.
---

# /smart — Cari dulu, baca sedikit, buktikan alamatnya

Memangkas **INPUT** (berkas yang dibaca + hasil tool); `/short` memangkas **OUTPUT** — beda sisi,
boleh bersamaan. Ringkasannya hidup di `CLAUDE.md` ("Hemat token"); rinciannya di sini.

## Urutan (jangan dibalik)

0. **Alamat dulu.** `ls` folder atau tool `Glob`. Salah alamat = semua hasil bohong.
1. **Peta berkas.** Tool `Grep` mode `files_with_matches` / `rg -l`. Nama berkas dulu, bukan isinya.
2. **Hitung.** Mode `count` / `rg -c`. Nol hasil → **Protokol Kosong**, jangan menyimpulkan.
3. **Baris.** Mode `content` / `rg -n` pada berkas yang sudah pasti. Batasi `head_limit` / `-m 20`.
4. **Baca rentang.** Tool `Read` dengan `offset`/`limit` (di harness lain: `start_line`/`end_line`). Jangan seluruh berkas.
5. **Batch.** Semua pencarian/pembacaan independen dalam SATU balasan.
6. **Catat `berkas:baris`** di jawaban. Jangan membaca ulang berkas yang sama.

## Perkakas — UKUR di mesin ini, jangan percaya kebiasaan

**Pencarian biasa pakai tool `Grep`/`Glob`;** bash hanya kalau butuh pipa/hitungan khusus.
Sebelum merangkai `--exclude-dir` panjang, periksa dulu apa yang sebenarnya terpasang:

```bash
rg --version; grep --version | head -1; command -v rg grep
```

`rg` menghormati `.gitignore` sendiri → rantai `--exclude-dir` TIDAK diperlukan. Beberapa
`grep` shell sebenarnya **ugrep** (juga melewati `.git`), sementara `/usr/bin/grep` BSD tidak —
jadi "grep" di PATH belum tentu yang kamu kira. Catat hasil ukuran + tanggalnya di
`docs/technical-rules.md`; angka pasti cepat basi kalau pindah mesin.

```bash
# Tahap 1 — daftar berkasnya dulu
rg -l -F '<identifier>' -g '*.ts' -g '*.tsx' src

# Tahap 2 — nomor baris di berkas yang sudah pasti
rg -n -F '<identifier>' src/<berkas-yang-pasti>.ts

# Cadangan: git grep (buta ke berkas yang belum di-`git add`)
git grep -n -F -e '<identifier>' -- 'src/**/*.ts' 'src/**/*.tsx'
```

## Bendera

| Bendera | Pakai untuk | Jangan |
|---|---|---|
| `-F` | string literal (titik, kurung, `$`) | jangan untuk regex |
| `-n` | selalu | — |
| `-l` | tahap 1: nama berkas saja | — |
| `-c` | hitung kecocokan per berkas | — |
| `-i` | teks bebas/docs | **jangan** untuk identifier — besar/kecil huruf itu informasi |
| `-w` | kata utuh | **jangan** untuk camelCase: `-w createPurchase` TIDAK menemukan `createPurchaseDraft` |
| `-m N` | batasi hasil | jangan biarkan keluaran ter-truncate di tengah |
| `-L` | bukti berkas TIDAK memuat pola | — |
| `--include` | batasi ekstensi | jangan kalau ragu: `*.ts` melewatkan `*.tsx` |
| `--exclude-dir` | buang sampah (bila alatnya tak baca `.gitignore`) | — |

## Protokol Kosong (wajib sebelum bilang "tidak ada")

Grep kosong = **"belum ditemukan"**, BUKAN **"tidak ada"**. Sebelum menyimpulkan, coba berurutan:

1. Pastikan alamatnya ada (`ls`, `git ls-files`).
2. Ulang tanpa `-w`.
3. Ulang dengan `-i` (khusus teks) atau ganti ejaan/sinonim.
4. **Cari nama FUNGSI/kelas/kolom, bukan nama FITUR.** Nama fitur hidup di kepala user; kode punya nama sendiri.
5. Perluas cakupan (folder lain, tanpa `--include`).

Maksimal 2 putaran. Tetap kosong → laporkan pola + cakupan + yang sudah dicoba. Jangan menebak.

## Larangan baca utuh

- **Di atas 500 KB jangan dibaca utuh.** Biasanya kena: `DECISIONS.md`, `CHANGELOG.md`, dump/HTML hasil build; `BACKLOG.md` cukup bagian Inbox. **Ukur sendiri** (`wc -c`) — jangan hafal daftarnya.
- Berkas >500 baris: cari dulu barisnya, baru baca rentangnya.
- Biner/xlsx/pdf. Dan `.env`/secret: **jangan `cat`/Read sama sekali** (aturan `CLAUDE.md`).
- **Jangan menyimpulkan dari keluaran yang dipotong `tail`/`head`.** Preseden nyata: "akun X belum ada" — ternyata ada, barisnya terbuang `tail -16`. Perkecil POLANYA, jangan potong HASILNYA.

## Batch & cache

- Tiap putaran tambahan mengirim ulang seluruh percakapan (lihat langkah 5) — itu biaya terbesarnya.
- Jangan edit `CLAUDE.md` atau berkas skill di tengah tugas (merusak prefix cache).
- Topik berganti total → mulai tugas/sesi baru, jangan bawa riwayat.

## Laporan (3 baris, bisa diaudit)

```
Cari: `pola` di `cakupan` → N berkas / M baris
Baca: berkas:12-40 · berkas2:88
Simpulan: ...
```

## Batas

Hemat token TIDAK boleh memotong verifikasi, peringatan keamanan, atau konfirmasi hal sulit
dibalik. Setiap klaim tentang kode wajib menyebut `berkas:baris`. Kalau tidak ada bukti, tulis
"belum ditemukan" — bukan kalimat yang terdengar yakin.

**Tak perlu dipakai** untuk pertanyaan tentang satu berkas yang sudah diketahui, atau edit kecil
di berkas yang sudah dibuka.
