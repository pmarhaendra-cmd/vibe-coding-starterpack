---
name: sync
description: Samakan lokal dengan production 1:1 — data DB + berkas unggahan ditarik dari prod, lalu DIBUKTIKAN sama lewat perbandingan jumlah baris tiap tabel. Pakai saat user bilang "/sync", "samakan local dengan prod", "tarik data prod", atau sebelum kerja/uji yang butuh data nyata. DESTRUKTIF ke lokal; prod hanya DIBACA.
---

# /sync — Samakan Lokal dengan Prod

> **TEMPLATE — isi dulu sebelum dipakai.** Tulis skrip & perintah nyata proyek ini, lalu ganti semua
> `{placeholder}`. Skill ini menjaga *urutan & rambu keselamatan*; perintahnya milik tiap proyek.
> Hapus skill ini kalau proyek belum punya production. Aturan eksekusi umum → `docs/technical-rules.md`.

**Prod = source of truth data.** Sesudah skill ini selesai, lokal 1:1 dengan prod — **dan itu dibuktikan, bukan diumumkan.**

⚠️ **Prod hanya DIBACA** (dump + salin berkas). Tak ada satu pun tulisan ke prod, jadi aturan
"jangan deploy di jam sibuk" TIDAK berlaku di sini. Yang hancur adalah **DB lokal**.

## Yang disamakan — dan yang sengaja TIDAK

| | |
|---|---|
| **Data DB** | ✅ seluruh tabel |
| **Berkas unggahan** (foto/lampiran/bukti) | ✅ — **wajib, bukan opsional.** Baris DB cuma menyimpan JALUR-nya; sync DB saja = ratusan gambar mati di layar |
| **Data pribadi/percakapan** `{isi tabelnya, mis. chat/pesan}` | ❌ bila memuat gaji, nomor telepon, urusan pribadi — struktur tabel ikut, isinya tidak. _(rujuk keputusan privasi proyek)_ |
| **KODE** | ❌ **jangan pernah.** Lokal biasanya beberapa commit DI DEPAN prod; menyamakan kode = membuang kerja yang belum dirilis. Yang benar: **laporkan jaraknya**, jangan tutup |
| **`.env` lokal** | ❌ kredensial & URL DB lokal sendiri |
| **Schema** | ✅ prod dulu, lalu `{perintah push schema}` menambahkan perubahan lokal yang belum dirilis → lokal = prod + schema belum-deploy. Ini **disengaja**: verifikasi melaporkan "tabel hanya ada di lokal" sebagai kabar biasa, bukan kegagalan |

## Langkah

**0. Pra-terbang.**
- Runtime lokal hidup? (`{mis. docker info}`) Kalau tidak: `{skrip nyalakan lokal}`.
- Prod terjangkau? Skrip WAJIB **BERHENTI sebelum menyentuh DB lokal** kalau tidak.
- **Beri tahu user apa yang akan hilang.** Data yang cuma ada di lokal (jejak uji, percobaan) akan lenyap — **termasuk nilai setelan** yang pernah diubah lokal. Cadangan otomatis ke `{jalur cadangan pra-sync}` — sebut jalurnya di laporan.

**1. Data DB.**
```bash
{perintah sync DB — mis. RESET_CONFIRM=YES bash scripts/sync-db-from-prod.sh}
```
Jangan pipa keluarannya ke `tail`/`head` — **pipa menyembunyikan kode keluar**, dan itulah yang
membuat "✓ synced" tercetak di atas DB yang kosong (preseden nyata → `docs/technical-rules.md`
§Jebakan mahal). Biarkan jalan penuh; skrip wajib punya gerbangnya sendiri: **banding ukuran byte**
kedua sisi sebelum menyentuh tujuan · cek kode keluar tiap langkah · **gerbang isi** pasca-restore
(`count(<tabel inti>) < 1` = BERHENTI).

**2. Berkas unggahan.**
```bash
{perintah sync berkas — mis. bash scripts/sync-uploads-from-prod.sh}
```

**3. Buktikan.**
```bash
{perintah verifikasi — mis. bash scripts/verifikasi-sync.sh}
```
Membandingkan jumlah baris **setiap tabel** di kedua sisi + jumlah berkas, lalu **keluar dengan kode
≠0 kalau ada yang beda**. **Tanpa langkah ini, "sudah sync" cuma klaim.**

**4. Nyalakan ulang server lokal.**
```bash
{perintah nyalakan server lokal}
```
**WAJIB, bukan saran.** DB di bawah kaki server lama baru saja di-drop & dibuat ulang: prosesnya
hidup tapi tak bisa menjawab apa pun. Lebih buruk, server baru bisa diam-diam pindah ke port lain
lalu mati sendiri — user tetap membuka port lama dan melihat halaman mati. Skripnya harus menutup
server lama sendiri. _(Dan jangan jalankan server dev sebagai proses latar sesi AI — ia mati saat
sesi ditutup; `docs/technical-rules.md` §Jebakan mahal.)_

**5. Lapor ke user** (ringkas, lihat `/short`):
- hasil verifikasi — **angka**, bukan "sudah sinkron";
- apa yang bertambah (mis. "188 transaksi, 2.642 pergerakan stok");
- **jarak kode**: `git log --oneline <commit-prod>..HEAD | wc -l` → "lokal N commit di depan prod, belum dirilis". Commit prod ada di `CHANGELOG.md` baris teratas;
- jalur cadangan pra-sync;
- **nilai setelan yang perlu diperiksa ulang** (lihat Jangan di bawah).

## Jangan
- **Jangan menyentuh skrip sync untuk rapi-rapi.** Tiap gerbang di dalamnya dibayar dengan satu insiden. Fitur baru → skrip baru di sebelahnya.
- **Jangan percaya verifikator yang cuma membaca header.** `pg_restore --list` pada dump format custom hanya membaca daftar isi di awal berkas → **lolos walau bagian datanya terpotong**. Yang bisa dipercaya: **ukuran byte** kedua sisi.
- **Jangan asumsikan setelan lokal masih ada.** Sync mengganti SELURUH DB lokal, termasuk nilai setelan yang pernah diputuskan user. **Sesudah tiap sync: periksa ulang, jangan asumsikan.**
- **Jangan jalankan dua dev server paralel** di satu folder — saling menimpa direktori build.
- **Jangan samakan kode dengan prod.** Lihat tabel di atas.
