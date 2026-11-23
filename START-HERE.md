# START HERE — Prompt Siap-Tempel

> Cara pakai: buka Claude Code di folder proyek → **copy-paste salah satu blok di bawah**. Selesai — AI yang memimpin sisanya.
> **Proyek baru** → PROMPT AWAL. **Melanjutkan kerja** → PROMPT LANJUTAN (perbarui bloknya tiap fase berubah — ritual `/handoff` mengingatkan ini). **Proyek berjalan mengadopsi pack** → PROMPT ADOPSI.

---

## 🚀 PROMPT AWAL — proyek baru (paste sekali di sesi pertama)

```
Kita mulai PROYEK BARU memakai starterpack ini. KAMU yang memimpin prosesnya dari awal —
saya cukup menjawab pertanyaan. Patuhi CLAUDE.md (invariants + dua mode + daur hidup catatan).

LANGKAH 1 — SETUP (kerjakan langsung tanpa bertanya; lapor ringkas):
- Cek amunisi: skill tersedia (impeccable, taste-skill, gsap-*, ponytail,
  smart, short, deploy, sync, handoff, graphify) + MCP aktif (context7). `deploy` &
  `sync` masih TEMPLATE — isi `{placeholder}`-nya saat infra jelas, atau hapus bila belum ada
  production. Yang mati → beri tahu cara
  mengaktifkannya, jangan memblokir proses. JANGAN mengandalkan nama skill bawaan tanpa mengecek
  ia ada di sesi ini — daftarnya berubah antar-versi.
- Sesuaikan `.claude/launch.json` (perintah dev + port proyek) supaya preview browser bisa dipakai;
  cek juga deny-list di `.claude/settings.json` masuk akal untuk stack ini.
- Cek monitoring biaya: codeburn siap (`npx codeburn --version`). Zero-install via npx (butuh
  Node >=22.13) — kalau Node ada, codeburn langsung bisa dipakai; tawarkan `npm i -g codeburn`
  untuk perintah tetap. Machine-global (baca sesi SEMUA proyek dari ~/.claude) → cukup tersedia
  sekali di mesin, tak perlu dipasang ulang per proyek. Detail → docs/companion-tools.md.
  Node tak ada / codeburn gagal → beri tahu, jangan memblokir proses.
- Catatan (BACKLOG.md, DECISIONS.md, dll.) masih template — kamu yang mengisinya seiring proses.

LANGKAH 2 — WAWANCARA (Mode A; WAJIB 1 pertanyaan per giliran, pilihan ganda + "Other"):
- Mulai dari yang paling menentukan: proyek ini untuk siapa & masalah apa yang diselesaikan.
- Tiap jawaban langsung dicatat ke CLIENT-PROFILE.md / PROBLEM-GOAL.md / DECISIONS.md
  (label FAKTA vs ASUMSI). Setelah cukup jelas → isi {NAMA PROYEK} + "Status kini" di CLAUDE.md,
  susun FEATURE-SCOPE.md + features/<nama>.md, lalu ajak saya masuk ke prototype.

LANGKAH 3 — PROTOTYPE & BUILD (pakai amunisi design secara aktif):
- Masuk fase build → jalankan /impeccable init SEKALI di awal, lalu craft/critique/audit/polish.
- Arah visual → taste-skill · animasi → skill gsap-*.

ATURAN KENDALI:
- Default: KAMU yang menyetir — tentukan sendiri langkah berikutnya sesuai metode & kebutuhan,
  tanpa menunggu perintah.
- Begitu saya memberi instruksi langsung / mengambil alih arah → ikuti saya; kembali menyetir
  saat saya mempersilakan atau tidak memberi arah.
- Hal sulit dibalik (data/biaya/keamanan/deploy/publikasi) → SELALU konfirmasi dulu.
- Tutup tiap sesi dengan /handoff.

Mulai sekarang: laporkan hasil setup dalam beberapa baris, lalu ajukan PERTANYAAN PERTAMAMU.
```

---

## ▶️ PROMPT LANJUTAN — {nama fase/fokus, mis. "Build fitur X"} (perbarui tiap fase)

```
Kita lanjutkan proyek {NAMA PROYEK} — {fase/fokus sesi ini}. KAMU yang memimpin (aturan kendali
sama seperti biasa: kamu menyetir, saya bisa ambil alih kapan saja; hal sulit dibalik = konfirmasi).

Baca seperlunya (hemat token, urut):
1. CLAUDE.md (auto-load) — patuhi "Cara kerja" + lihat "Status kini"
2. BACKLOG.md (antrian kerja)
3. {berkas spesifik fase ini — mis. features/<fitur>.md, DECISIONS.md entri terkait, docs/<topik>.md}

Mode {A/B}. Catat keputusan ke DECISIONS.md, progress ke features/<nama>.md.

Konteks: {2–4 baris kondisi terkini — apa yang sudah jadi & terverifikasi, apa yang belum,
jebakan yang harus dihindari}.

Mulai dengan: {mis. "konfirmasi singkat kondisi terkini, lalu lanjutkan item teratas BACKLOG;
tunjukkan rencana ringkas dulu sebelum eksekusi"}.
```

---

## 🔁 PROMPT ADOPSI — proyek berjalan mengadopsi starterpack terkini (paste sekali)

> Untuk proyek yang sudah jalan: dulu di-seed dari starterpack versi lama, ATAU belum pernah pakai starterpack. Sumber kebenaran = folder starterpack master terkini (tak ada catatan versi; folder itu sendiri acuannya).

```
Proyek ini SUDAH BERJALAN. Starterpack terkini ada di: {path folder _starterpack master}.

Tugas: SINKRONKAN lapisan METODE/scaffolding saja (invariant CLAUDE.md, blok prompt
START-HERE.md, template & isi docs/, .claude/skills, .claude/settings.json, scripts/README.md,
.gitignore) — BUKAN konten proyek.

Aturan wajib:
- Konten proyek = READ-ONLY: "Status kini", nama proyek, DECISIONS.md, BACKLOG.md,
  features/, CLIENT-PROFILE, PROBLEM-GOAL, kode. Jangan diubah/ditimpa/dihapus.
- Tambah hanya yang BELUM ADA — file baru MAUPUN baris/seksi yang hilang di dalam
  file yang sudah ada (sisip bedah; mis. sisipkan 1 invariant baru ke CLAUDE.md
  proyek). JANGAN pernah menyalin file utuh menimpa file yang sudah terisi.

Langkah:
1. Bandingkan kedua folder → susun DAFTAR SELISIH lapisan-metode.
2. Tampilkan RENCANA (file/baris apa yang akan ditambah) → TUNGGU konfirmasi saya.
3. Setelah saya setuju: terapkan aditif, lalu catat aksi sync ini ke DECISIONS.md proyek.
```

---

### Skala ke multi-surface / multi-proyek
Kalau proyek tumbuh jadi beberapa **surface** (app · dashboard · admin · POS) atau beberapa **proyek** di bawah 1 klien/grup:
- **1 blok prompt per jenis sesi** di file ini — tiap blok hanya menyuruh baca berkas surface/proyeknya (jangan muat surface lain; hemat token).
- **Aturan sesi paralel:** tiap sesi hanya menyentuh folder/berkas miliknya; berkas **bersama** (profil grup, DECISIONS level-atas, design-tokens) diubah hanya bila benar fakta bersama + dicatat.
- Multi-proyek penuh → restrukturisasi: root = otak grup (`CLAUDE.md`, `GROUP-PROFILE.md`, `DECISIONS.md` level-grup) + `projects/<nama>/` masing-masing berisi set dokumen starterpack sendiri.
