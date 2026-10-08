#!/usr/bin/env bash
# Public keys live in dotfiles/keys. Private keys stay in ~/.ssh and ~/.gnupg.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$root/keys" "$HOME/.ssh"

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N "" -C "bxrne@nixbook"
fi
cp "$HOME/.ssh/id_ed25519.pub" "$root/keys/id_ed25519.pub"

if ! gpg --list-secret-keys "adamrbyrne@gmail.com" >/dev/null 2>&1; then
  gpg --batch --pinentry-mode loopback --passphrase '' \
    --quick-generate-key "bxrne (nixbook) <adamrbyrne@gmail.com>" ed25519 sign never
fi
gpg --armor --export "adamrbyrne@gmail.com" > "$root/keys/gpg-nixbook.pub"

echo "SSH:  $(cat "$root/keys/id_ed25519.pub")"
echo "GPG:  $(gpg --list-secret-keys --keyid-format=long adamrbyrne@gmail.com | awk '/^sec/ {print $2}')"
echo
echo "Upload (SSH was added by \`gh auth login\`; GPG needs write:gpg_key):"
echo "  gh auth refresh -h github.com -s write:gpg_key"
echo "  gh ssh-key add $root/keys/id_ed25519.pub --title nixbook"
echo "  gh gpg-key add $root/keys/gpg-nixbook.pub"
