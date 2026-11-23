#!/bin/sh
# Jalankan SEKALI tepat setelah clone/unduh starterpack ini:  sh scripts/mulai.sh
# Memutus riwayat Git template, memasang .gitignore proyek (catatan .md jadi lokal), lalu git init baru.
set -e
cd "$(dirname "$0")/.."
[ -f .gitignore.proyek ] || { echo "Sudah pernah dijalankan (.gitignore.proyek tidak ada). Berhenti."; exit 1; }
rm -rf .git
mv .gitignore.proyek .gitignore
git init -q
echo "Siap. Catatan .md kini lokal (di luar Git). Lanjut: buka Claude Code, tempel PROMPT AWAL dari START-HERE.md."
