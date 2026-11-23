# scripts/

**Logika yang harus tahan ganti-LLM & ganti-sesi tinggal di sini** — bukan di dalam skill, bukan di dalam prompt. Skill/mode per-tool cuma pembungkus tipis (lihat `docs/multi-llm.md`). Skrip = satu-satunya lapisan yang bisa *dijalankan* dan *diverifikasi*, bukan sekadar dibaca.

> **Folder ini IKUT GIT** (beda dari catatan `.md` yang lokal) — skrip adalah **penegak aturan**, dan penegak harus ikut ke mesin mana pun repo dipakai.

## Konvensi nama

| Awalan | Untuk apa | Contoh |
|---|---|---|
| `guard-*` | Gerbang mutu: **menolak** kelas-bug yang typechecker & linter buta terhadapnya. Keluar dengan exit code ≠ 0 saat melanggar. | `guard-use-server.mjs` |
| `uji-*` | Uji satu perilaku end-to-end (jalankan flow sungguhan, bukan unit test kosmetik). Dipakai menagih "Selesai bila". | `uji-<fitur>.ts` |
| `sync-*` | Memindahkan data antar-lingkungan. **Destruktif** → wajib 3 pengaman di bawah. | `sync-local-from-prod.sh` |
| `_archive/` | Skrip sekali-pakai yang sudah selesai tugasnya tapi sayang dibuang (jejak audit). | `scripts/_archive/` |
| `_tmp-*` | Skrip coba-coba sesi ini. Hapus atau pindahkan ke `_archive/` saat `/handoff`. | `_tmp-uji-<x>.ts` |

Sambungkan `guard-*` ke satu perintah agregat (`npm run gerbang`) — lihat `docs/technical-rules.md` §Gerbang mutu.

## Wajib untuk skrip destruktif (pelajaran mahal — jangan ditawar)

Skrip pernah men-drop DB lokal, gagal restore, lalu tetap mencetak `✓ synced`. Layar melapor sukses, laptop kosong. Tiga pengaman yang menutupnya:

1. **Banding ukuran byte sumber vs hasil SEBELUM menyentuh tujuan.** Transfer lewat pipa ssh bisa memotong berkas diam-diam. Verifikator yang cuma membaca header (mis. `pg_restore --list` pada dump custom) **LOLOS walau data terpotong** — ukuran byte tidak.
2. **Cek kode keluar tiap langkah, jangan lewat pipa.** `set -e` TIDAK menangkap kegagalan di bagian non-terakhir sebuah pipa. Keluaran → berkas log, lalu `EXIT=$?` diperiksa, lalu HALT.
3. **Gerbang isi pasca-operasi.** Restore bisa "sukses" tapi hanya struktur → `count(<tabel inti>) < 1` = BERHENTI, jangan lapor sukses.

Tambahkan juga: konfirmasi eksplisit (mis. `RESET_CONFIRM=YES`) sebelum langkah yang menghapus.
