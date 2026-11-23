# Manifest Akses & Kredensial

Indeks kredensial proyek — **TANPA nilai rahasia** (file ini boleh di-commit). Nilai asli **hanya** di `access/secrets/` (gitignored), keyring, atau `.env` yang di-handle user sendiri. Jangan pernah menaruh secret di sini, di dokumen lain, di memory, atau di commit. (Aturan penanganan secret → `docs/technical-rules.md`.)

| Layanan | Untuk apa | Lokasi nilai | Owner | Catatan |
|---|---|---|---|---|
| {GitHub} | {host repo privat} | {gh CLI keyring} | {user} | {sudah login} |
| {API X} | {fungsi} | {.env / secrets/} | {user} | {cara generate: mis. `openssl rand -hex 32`} |
