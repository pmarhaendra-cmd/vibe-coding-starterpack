# docs/

Dokumen teknis Mode B (arsitektur, setup, integrasi). Buat sesuai kebutuhan.
Jangan isi dengan asumsi — diskusikan & putuskan dulu.

Sudah ada:
- `technical-rules.md` — aturan eksekusi teknis (pipe safety, secrets, verify hasil) + **§Gerbang mutu** (satu perintah agregat + `guard-*`) + **§Hemat token** (ringkasan skill `/smart`) + **§Pola LLM yang dijaga** (13 pola; `CLAUDE.md` cuma memuat 4 terparah) + **§Jebakan mahal** (gejala → obat, dari proyek nyata). Bagian "Umum" langsung berlaku.
- `companion-tools.md` — tool pendamping (codeburn = monitoring biaya; caveman).
- `deploy.md` — runbook rilis per-proyek (template; isi saat ada target deploy nyata). Dipakai skill `/deploy`.
- `multi-llm.md` — protokol >1 LLM bergantian (hapus bila 1 LLM).
- `handoff-checklist.md` — ritual tutup sesi versi manual (untuk LLM non-Claude).
