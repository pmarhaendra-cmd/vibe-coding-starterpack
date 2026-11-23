# Aturan Teknis & Konvensi

Rincian aturan operasi teknis (referensi dari `CLAUDE.md`). Behavioral rules ada di CLAUDE.md; ini detail eksekusi. Bagian **Umum** berlaku universal; bagian lain diisi saat infranya jelas.

## Umum (berlaku semua proyek)
- **Pipe safety:** JANGAN pipe perintah build/panjang ke `| tail`/`| grep` — exit code pipeline = perintah terakhir → build gagal tampak sukses. Pakai `cmd > /tmp/log 2>&1; echo "EXIT=$?"` lalu baca log-nya.
- **Verify hasil, bukan asumsi selesai:** setelah build/deploy, cek artefak benar-benar BERUBAH (hash/timestamp/versi), bukan sekadar "perintah exit 0".
- **QC kode:** tagih tiap "Selesai bila" dengan **menjalankan flow-nya end-to-end** (klik/panggil sungguhan atau skrip uji) — **bukan** "typecheck+lint lulus". Preseden mahal: 3 lubang lolos `tsc`+eslint dan baru ketahuan lewat uji-bantah. Menjelang milestone/merge Mode B: **`/code-review`**. Menyentuh otorisasi/uang atau pra-LIVE: **`/security-review`**. QC design → skill impeccable.
  > ⚠️ **Jangan mengandalkan nama skill tanpa mengeceknya ada.** Daftar skill Claude Code berubah antar-versi (`/verify` pernah ditulis di sini, **tak ada** di versi sekarang). Ragu → cek daftar skill sesi / `/help` dulu. Aturannya tentang **perbuatannya** (jalankan end-to-end), bukan tentang nama perintahnya.
- **Secrets/.env:** user handle sendiri. JANGAN `cat`/Read/Write file secret. Kasih **nama var + cara generate** (mis. `openssl rand -hex 32`); user paste sendiri; verifikasi via test script/endpoint, BUKAN baca file. Indeks kredensial (tanpa nilai) → `access/MANIFEST.md`.
- **Network/SSH gagal:** JANGAN loop retry / diagnostik panjang (apalagi bila server mungkin kehabisan resource). Stop, lapor, ganti strategi.
- **No dev workarounds jadi permanen:** butuh webhook/cron/public URL → siapkan jalur benar (deploy), bukan tambal dev-only (ngrok/polling) yang lalu terlupakan.
- **Jebakan yang ditemukan = langsung dicatat di sini** (1 baris: gejala → fix), supaya sesi berikut tak diagnosa ulang.

## Gerbang mutu — satu perintah, bukan imbauan
Imbauan "jangan lupa cek" kalah oleh sesi yang buru-buru. Bikin **satu perintah agregat** sejak awal proyek, lalu jalankan sebelum menyatakan apa pun SELESAI:
```jsonc
// package.json (contoh — sesuaikan stack)
"scripts": {
  "gerbang": "tsc --noEmit && npm run lint && npm run guard:<x> && npm run design:lint"
}
```
- **Tambah `guard-*` untuk lubang yang typechecker & linter BUTA terhadapnya.** Contoh nyata: `guard-use-server.mjs` menolak ekspor terlarang di berkas `'use server'` — `tsc` + eslint lolos, produksi bocor. Tiap kali ketemu kelas-bug yang lolos gerbang → tulis guard-nya, jangan cuma catat.
- **Baseline JSON untuk aturan yang bertumbuh** (`design-baseline.json` dll.): angka pelanggaran boleh turun, **tak boleh naik**. Ini mencegah "nanti dirapikan" jadi selamanya.
- **Penegak WAJIB ikut Git — termasuk dokumen yang ditegakkannya.** Kalau `design-lint.mjs` ada di Git tapi `DESIGN.md` cuma di laptop, gerbangnya pincang. (Itu satu-satunya pengecualian kebijakan "catatan .md lokal" — lihat `.gitignore`.)
- Skrip taruh di `scripts/` (portabel lintas-LLM — lihat `scripts/README.md`), bukan di dalam skill.

## Hemat token sisi INPUT — cari dulu, baca rentang, batch

Playbook penuh = skill **`/smart`**. Yang wajib diingat tanpa membuka skill-nya:

- **Urutan:** alamat (`ls`/`Glob`) → daftar berkas (`-l`) → hitung (`-c`) → baris (`-n`) → baca **rentang** (`offset`/`limit`) → batch dalam SATU balasan → catat `berkas:baris`.
- **Grep kosong = "belum ditemukan", BUKAN "tidak ada".** Protokol Kosong: cek alamatnya ada · ulang tanpa `-w` · coba `-i`/sinonim · **cari nama FUNGSI/kolom, bukan nama FITUR** · perluas cakupan. Maks 2 putaran, lalu laporkan pola+cakupan+yang sudah dicoba.
- **`-w` hancur di camelCase** (`-w createPurchase` tak menemukan `createPurchaseDraft`); `-i` jangan untuk identifier (besar/kecil huruf itu informasi); `--include '*.ts'` melewatkan `*.tsx`.
- **Berkas >500 KB jangan dibaca utuh** — ukur `wc -c`, jangan hafal daftarnya.
- **Ukur perkakasnya, jangan percaya kebiasaan:** `rg --version; grep --version | head -1`. `rg` baca `.gitignore` sendiri (rantai `--exclude-dir` tak perlu); "grep" di PATH kadang ugrep, bukan BSD grep. {Catat hasil ukuran + tanggalnya di sini.}
- Jangan edit `CLAUDE.md`/berkas skill di tengah tugas — merusak prefix cache.

## Build & deploy — {isi saat infra jelas}
- {platform build & arsitektur target — mis. build di laptop bukan server, flag arsitektur}
- {batas resource server: RAM/disk/swap — apa yang tidak boleh dijalankan di sana}
- {jendela deploy aman + prosedur → skill `/deploy` + `docs/deploy.md`}

## Dev lokal — {isi}
- {cara run + port}
- {jebakan framework yang ditemukan: gejala → fix tanpa diagnosa ulang}

## Design system — {isi saat dikunci; atau tunjuk `DESIGN.md` hasil /impeccable init}
- {font teks/angka · palet & background · aturan komponen (card/hover/spacing) yang berlaku SELURUH app}

## Animasi & transisi (frontend — bila relevan)
- **Transisi antar-halaman/route:** untuk crossfade route & shared-element, pakai **Flip** (gsap-plugins: `Flip.getState()` → ubah layout → `Flip.from()`) atau **View Transitions API** native; di SPA/router jalankan lewat lifecycle (skill gsap-react / gsap-frameworks). *Barba.js tak perlu* — teknik di atas menggantikannya. Panduan altitude motion → skill `/impeccable animate`. (Reduced-motion sudah wajib & auto-enforce oleh impeccable — tak perlu diurus manual.)
- **GSAP ↔ 3D/Canvas (Three.js/Pixi) — ON-DEMAND, jangan pre-install:** starterpack tak membawa skill 3D di depan. **Deteksi dari stack:** bila `three` / `pixi.js` / `@react-three/fiber` muncul di `package.json` atau import → topik ini aktif. Tangani dulu dengan **gsap-core** (`gsap.to(obj.position, {...})`, `gsap.ticker` untuk sinkron render-loop) + **context7** (dok Three.js/Pixi terkini). Tambah skill khusus HANYA bila kompleksitas menuntut — hindari skill jarang-pakai (overhead token; ditandai `codeburn optimize`). Pola sama seperti deteksi platform impeccable (`context.mjs` → web/ios/android).

---

## Pola LLM yang dijaga (daftar panjang — ringkasannya di `CLAUDE.md`)

> Dikumpulkan dari proyek nyata. `CLAUDE.md` cuma memuat 4 yang terparah demi plafon 12.000 char;
> ini daftar utuhnya. **Tiap ketemu pola baru: tambah 1 baris di sini SAAT ITU.**

- Menyimpulkan dari pola **tanpa cek kodenya masih hidup** di tree.
- **"Membetulkan" KODE agar cocok dengan harapan UJI yang keliru** — uji gagal ≠ kode salah.
- Mengubah kerja sendiri jadi **"keputusan user"** (padahal tak butuh keputusan user).
- Mengutip catatan **LAMA** tanpa membaca yang menggantikannya.
- **Menyimpulkan tanpa MENGUKUR** — termasuk dari foto/screenshot.
- **Membunyikan alarm dari SELISIH dua angka yang mekanismenya belum dibaca.** Selisih ≠ bug.
- Meneruskan angka dari sub-agent/alat lain **tanpa membukanya sendiri**.
- Membetulkan **satu salinan** tanpa `grep` salinan lainnya.
- **Mencari lewat NAMA FITUR, bukan nama FUNGSI/kolom.** Nama fitur hidup di kepala user.
- **Menjumlahkan per NAMA padahal dua baris bisa berbagi nama** (preseden: dua item beda jenis, nama sama → alarm palsu).
- **Memotong keluaran dengan `tail`/`head` lalu menyimpulkan seluruhnya** (preseden: "akun X belum ada" — ada, barisnya terbuang `tail -16`). Perkecil POLANYA, jangan potong HASILNYA.
- **Menyimpulkan "formatnya berubah" dari 2 kejadian** (preseden: hari ke-3 normal lagi).
- Menawarkan kerja tambahan / menarasikan sejarah kesalahan sendiri alih-alih mengerjakan yang diminta.

Sebelum menulis "putuskan dulu (user)": **(a)** sudah ada di `DECISIONS.md`? **(b)** user punya info
yang kamu tak punya (uang · hukum · pelanggan · sulit dibalik · apa yang ia lihat)? Kalau (b) tidak →
**kerjamu: pilih, kerjakan, tunjukkan.**

---

## Jebakan mahal (gejala → obat) — dari proyek nyata, jangan diagnosa ulang

> Ini bukan teori. Tiap baris pernah memakan berjam-jam. **Tiap ketemu jebakan baru: tambah 1 baris di sini SAAT ITU.**

- **Deploy bisa gagal SENYAP — "ada" ≠ "bekerja".** Satu berkas konfigurasi tak ikut terkirim (hanya image yang dikirim); env var benar di `.env`, container di-recreate, app hijau — tapi variabelnya **tak pernah sampai** karena konfigurasi di server masih versi lama. Nol error; fiturnya diam-diam mati. **Obat:** `diff` berkas konfigurasi server vs lokal SEBELUM deploy · `--force-recreate` · **uji panggil fiturnya sungguhan** setelah deploy, bukan cek "env ada".
- **Lolos typecheck + lint ≠ benar.** 3 lubang serius lolos `tsc`+eslint, ketahuan cuma lewat uji-bantah (pagar berbasis penanda teks = keamanan semu · konversi satuan gagal senyap · tool warisan menulis data tanpa otorisasi). **Obat:** kode yang menyentuh uang/otorisasi → uji end-to-end + `/security-review`, bukan "build hijau".
- **Pipa menyembunyikan kegagalan — dan `set -e` TIDAK menolong.** `set -e` tak menangkap kegagalan di bagian **non-terakhir** sebuah pipa, jadi langkah yang gagal di tengah lolos tanpa jejak. **Obat:** keluaran ke berkas log + cek kode keluar tiap langkah + HALT eksplisit. Jangan pernah `cmd | tail`.
- **Skrip bisa melapor "✓ sukses" sambil menghancurkan data.** Insiden nyata: skrip men-drop DB lokal, restore GAGAL, lalu tetap mencetak "✓ Local DB synced" — laptop kosong, layar melapor sukses. **Obat wajib di tiap skrip destruktif:** ① banding **ukuran byte** sumber vs hasil **SEBELUM** menyentuh tujuan · ② cek kode keluar tiap langkah (jangan lewat pipa) · ③ **gerbang isi** pasca-restore (mis. `count(<tabel inti>) < 1` = BERHENTI).
- **Alat verifikasi bisa MENIPU; ukuran byte tidak.** `pg_restore --list` pada dump format custom hanya membaca daftar-isi di awal berkas → **LOLOS walau bagian datanya terpotong**. Dan alat yang "command not found" gampang disalahartikan sebagai "berkasnya rusak". **Obat:** percayai ukuran byte kedua sisi, bukan verifikator yang cuma membaca header.
- **Transfer lewat pipa ssh memotong berkas diam-diam.** `ssh host 'dump...' > berkas` menghasilkan berkas lebih kecil daripada di server, tanpa error. **Obat:** tulis ke berkas di server → `scp` → banding ukuran.
- **"Angka akhir benar" ≠ "per-periodenya benar".** Saldo akhir tampak nyaris sempurna karena kesalahan periode A menutupi kesalahan periode B. **Obat:** uji arus **masuk dan keluar terpisah, per periode** — jangan percaya total akhir saja.
- **"Tak ada yang bernominal persis X" ≠ "tak ada datanya".** Pencocokan berbasis angka bikin skrip menulis dobel. **Obat:** cek keberadaan lewat penanda/identitas transaksi, bukan kecocokan nominal.
- **Ubah schema/token → restart dev server.** Client/binding basi bikin SELURUH aksi melempar error yang menyesatkan; token CSS baru juga tak terbaca sampai dev server dimuat ulang. **Obat:** restart dulu sebelum mendiagnosa apa pun.
- **Jangan dua dev server paralel di satu folder** — saling menimpa direktori build → error "module not found" yang palsu. **Obat:** matikan semua → hapus direktori build → jalankan SATU.
- **Dev server yang dinyalakan dari Bash sesi AI = proses ANAK sesi itu.** Sesi ditutup → server mati → user membuka `localhost:<port>` yang kosong, dan menyangka kodenya rusak. **Obat:** jalankan skrip proyek di **tab Terminal user sendiri** (`run_in_terminal`), bukan sebagai proses latar sesi. Ia hidup di shell user, tetap menyala sesudah sesi berakhir, dan user bisa menghentikannya (Ctrl-C). Catatan: peluncur pratinjau (`preview_start`) bisa gagal `EPERM: process.cwd failed ... uv_cwd` kalau proyeknya di folder yang dilindungi privasi OS (mis. di bawah `~/Desktop`) — memberinya izin = mengubah setelan keamanan sistem, itu urusan user.
- **Tanggal "date-only" = tengah malam LOKAL. JANGAN `toISOString()`.** Mengubahnya ke UTC menggeser tanggal satu hari untuk zona timur — fitur bisa gagal SELAMANYA tanpa satu pun pesan galat. **Obat:** satu helper kunci-hari/tanggal-lokal, dipakai di SEMUA tempat; larang `toISOString()` lewat `guard-*`.
- **`<input type="file">`: FileList itu HIDUP.** `tambah(e.target.files); e.target.value = ''` dengan `Array.from(files)` di DALAM updater state → `value=''` mengosongkan objek yang sama sebelum updater jalan → berkas lenyap, uploader mati berhari-hari tanpa galat. **Obat:** salin dulu (`const f = Array.from(e.target.files ?? [])`), baru kosongkan `value`.
- **`git mv` / `git rm` langsung ter-STAGE.** Menyusun beberapa commit sesudahnya (`git add <berkas>` lalu `git commit` tanpa pathspec) membuat commit PERTAMA menelan semua rename/hapus yang sudah ter-stage — **tapi tidak isi berkas yang di-rename**. Hasilnya commit yang tidak kompilasi, dan `git status` sesudahnya tampak normal. **Obat:** ① `git diff --cached --name-only` harus KOSONG sebelum mulai (kalau tidak: `git reset -q`) · ② stage per commit dengan **`git add -A <path…>`** · ③ sebelum push, typecheck **TIAP commit**, bukan HEAD saja (`git worktree add --detach` per hash).
- **Typechecker bisa BUTA ke sebagian repo.** Folder di luar `include` tsconfig (sering `scripts/`) lolos diam-diam — argumen salah baru meledak saat dijalankan. **Obat:** cek cakupan tsconfig; skrip yang MENULIS ke DB jalankan lewat wrapper `.sh`-nya, jangan dipanggil langsung.
- **Tiap perjalanan bolak-balik ke server berharga ~200 ms dan itu tak bisa dikurangi dari sisi kode** — yang bisa dikurangi hanya JUMLAH-nya. Kalau server action sudah memanggil `revalidatePath('<rute halaman ini>')`, jawabannya SUDAH membawa halaman segar: `router.refresh()` sesudahnya = satu perjalanan untuk data yang sudah di tangan; `router.push(X)` + `refresh()` = refresh rute LAMA yang sedang ditinggalkan; `window.location.reload()` = yang termahal (dokumen dibongkar, seluruh JS diunduh ulang — terukur 61 permintaan / 2,7 dtk di dev), biasanya dipakai cuma agar borang kosong — **kosongkan borangnya sendiri**. **Masih dibutuhkan** bila aksinya tak memanggil `revalidatePath`, menyegarkan rute LAIN, atau perubahannya bukan dari server action. 🪤 **Jebakan stub pengalih:** `revalidatePath` yang menunjuk halaman yang kini cuma `redirect()` — alamatnya ada, nol galat, tapi tak ada halaman hidup yang disegarkan. **Periksa rute tujuannya punya halaman, bukan `redirect()`.**
