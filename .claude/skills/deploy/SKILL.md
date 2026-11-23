---
name: deploy
description: Deploy kode proyek ini ke production dengan prosedur baku (pre-flight → build → transfer/publish → verify → rollback siap → catat). Pakai saat user minta "deploy ke prod", "push ke prod", atau "rilis ke production". Code-only; migrasi DB & mutasi data = langkah terpisah dengan izin eksplisit.
---

# Deploy ke Production

> **TEMPLATE — isi dulu sebelum dipakai.** Saat proyek sudah punya target deploy nyata, tulis prosedur detailnya di `docs/deploy.md`, lalu ganti semua `{placeholder}` di bawah. Skill ini menjaga *urutan & rambu keselamatan*; detail perintah milik tiap proyek. Aturan eksekusi umum (pipe safety, verify artefak berubah, secrets, batas resource server) → `docs/technical-rules.md`.

**Arsitektur (isi):** {stack & alur, mis: "Caddy → Next.js (Docker) → Postgres di VPS" / "Vercel" / "Netlify" / "shared hosting"}. Target: `{host/SSH alias/platform}`.

## 0. Pre-flight (WAJIB — jangan skip)
1. **Konfirmasi ke user** sebelum mulai (deploy = outward-facing, sulit dibalik).
2. **Cek jam sibuk:** kalau ada jam operasional/traffic tinggi ({isi, mis: 11:00–22:00 WIB}), STOP & tanya urgensi.
3. **Tentukan commit:** biasanya HEAD. Pastikan working tree bersih. `git rev-parse --short HEAD`.
4. **Code-only?** Kalau ada perubahan schema/migrasi DB → itu langkah TERPISAH dengan izin eksplisit user. Default asumsikan code-only.
5. **Sync/backup:** pastikan ada backup atau snapshot state prod sebelum mulai ({isi caranya}).

## 1. Build — **di mesin lokal, JANGAN di server**
```bash
{perintah build — mis: docker build --platform linux/amd64 -t {image}:latest . > /tmp/build.log 2>&1; echo "EXIT=$?" >> /tmp/build.log}
```
- **Build di server = OOM** kalau RAM/swap-nya pas-pasan (VPS kecil biasanya tanpa swap). Build lokal, kirim hasilnya.
- Build lama → jalankan di background, **redirect ke berkas log** (jangan `| tail` — pipa menyembunyikan kode keluar), lalu verifikasi `EXIT=0` **dan** nama artefak yang keluar.
- Arsitektur target ≠ arsitektur laptop → **pin platformnya** ({mis. `--platform linux/amd64`} di Mac ARM). Peringatan platform-pin & "secrets in ENV" biasanya benign — baca, jangan abaikan buta.

## 2. Transfer / Publish
```bash
{perintah transfer — mis: docker save | gzip → scp / git push / vercel deploy --prod}
```
Artefak besar (ratusan MB, terus membesar — **ukur sendiri**) → jalankan di background. **Uji
integritas di tujuan** sebelum dipakai ({mis. `gzip -t`}): transfer lewat pipa ssh bisa memotong
berkas diam-diam tanpa error.
⚠️ **Berkas konfigurasi di server bisa versi LAMA.** Image baru + `.env` benar ≠ fitur hidup:
kalau konfigurasi server tak menyebut variabelnya, variabel itu tak pernah sampai — nol error,
fiturnya diam-diam mati. **`diff` konfigurasi server vs lokal SEBELUM mengaktifkan.**

## 3. Aktifkan versi baru + siapkan rollback
- **Sebelum** mengganti versi live, tandai versi lama sebagai target rollback ({mis: `docker tag {image}:latest {image}:previous` / catat deployment-id sebelumnya}).
- Aktifkan versi baru: `{perintah — mis: docker compose up -d --no-build app}`.

## 4. Verify
- Cek semua endpoint/halaman utama balas **200**: `{daftar URL}`.
- 🪤 **307/302 BUKAN bukti halaman hidup** — itu lemparan login/redirect. Yang perlu dibuktikan hidup, buktikan di halaman aslinya (sesudah login), bukan dari kode status pengalihan.
- **Buktikan versi yang JALAN = versi baru**, bukan cuma "perintahnya exit 0": {mis. `docker inspect <container> --format "{{.Image}}"` = ID image baru / bandingkan hash-versi yang dilayani}.
- Cek log bersih ({perintah log}).
- **Uji panggil fiturnya sungguhan** kalau deploy ini membawa integrasi/env baru — "env ada" bukan bukti.
- **Data sanity** (code-only → data harus identik dengan snapshot pre-deploy): {query/count tabel penting}.

## 5. Cleanup
Hapus artifact transfer di server & lokal; JANGAN hapus versi rollback. Cek disk masih longgar.
⚠️ Perintah bersih-bersih yang menyapu **semua** yang tak terpakai ({mis. `docker system prune -a`}) **ikut menghapus target rollback**. Pakai yang sempit saja ({mis. `docker image prune -f`}).

## 6. Catat
- Tambah entri ke `CHANGELOG.md` (tanggal · commit · ringkasan · rollback target · backup).
- Keputusan baru → `DECISIONS.md`.
- JANGAN auto-commit/push tanpa diminta user.

## Rollback (kalau verify gagal)
```bash
{perintah kembali ke versi sebelumnya}
```

## Jangan
- Jangan deploy tanpa konfirmasi user. Jangan hapus target rollback. Jangan sentuh data prod (replay/wipe/migrasi) tanpa izin eksplisit. Jangan deploy di jam sibuk tanpa izin.
- Jangan build di server. Jangan pipa keluaran build ke `| tail`. Jangan menyalin bulat-bulat berkas konfigurasi repo ke server kalau yang di server **bukan** subset-nya — bisa mematikan bagian yang tak disebut repo (preseden: blok domain utama hilang → situs mati). Tambah bloknya saja, validasi, reload.
