# Companion Tools

Tool pendamping di luar amunisi utama (skill + MCP). Dicek di `START-HERE.md` LANGKAH 1.
Ringkas: **codeburn = pakai (monitoring biaya)** · **caveman = sudah digantikan house-rule**.

---

## codeburn — DISARANKAN (monitoring biaya AI)

Melihat ke mana biaya & token AI-coding pergi, dipecah per **tool / model / proyek / task** (32 tool: Claude Code, Codex, Cursor, dll.). Mendukung langsung invariant **Hemat token**.

**Sifat:**
- **Zero-install** — `npx codeburn` langsung jalan (butuh Node >=22.13). Untuk perintah tetap: `npm i -g codeburn`.
- **Read-only & local-first** — hanya membaca file sesi yang sudah ada di disk (`~/.claude` dll.). Tanpa API key, tanpa kirim data keluar (akses jaringan hanya untuk harga model & kurs).
- **Machine-global** — membaca sesi SEMUA proyek sekaligus. Cukup tersedia sekali di mesin; **tidak** dipasang per-proyek dan **tidak** dibundel ke dalam repo starterpack.
- **Tidak mengubah perilaku AI** — murni observability, nol risiko ke alur kerja.

**Pakai:**
```bash
npx codeburn                 # dashboard interaktif (7 hari terakhir)
codeburn overview            # ringkasan bulan ini, tabel siap-paste
codeburn overview -p all     # semua waktu
codeburn optimize            # cari pola pemborosan token (30 hari)
codeburn optimize --provider claude
```
Opsional: `codeburn guard install` memasang budget-cap + statusline ke `.claude/settings.json` (opt-in; aman berdampingan dengan hook lain).

---

## caveman — SUDAH DIGANTIKAN house-rule (jangan pasang plugin)

Caveman = plugin yang bikin agent menjawab ringkas ("caveman-speak") demi hemat output token. **Kita ambil filosofinya, bukan plugin-nya** — lihat invariant **"Gaya output"** di `CLAUDE.md`.

**Alasan tidak memasang plugin:**
- **Global & auto-on** — plugin Claude Code tinggal di `~/.claude`, ON otomatis di SEMUA proyek dari pesan pertama. Bukan yang kita mau untuk kerja hadap-klien.
- **Tidak portabel** — plugin tak ikut saat repo di-clone; house-rule di `CLAUDE.md` ikut.
- **Bisa bentrok gaya** — aturan persistensi caveman menabrak invariant komunikasi (Bahasa Indonesia + pilihan ganda + kejelasan hadap-user).

House-rule "Gaya output" memberi manfaatnya **tanpa** efek global itu: SEMUA narasi proses AI ringkas ala caveman (mode apa pun); yang tetap kalimat penuh hanya pertanyaan/keputusan/warning/penjelasan yang user butuhkan. Kalau suatu saat benar-benar mau plugin-nya: pasang manual di luar repo (`curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash`) — tapi untuk starterpack tidak diperlukan.
