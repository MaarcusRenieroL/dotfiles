#!/usr/bin/env bash
# Setup SSH key for GitHub authentication
set -euo pipefail

DOTFILES="${DOTFILES:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export DOTFILES
# shellcheck source=scripts/lib.sh
source "$DOTFILES/scripts/lib.sh"

SSH_KEY="$HOME/.ssh/id_ed25519"
SSH_DIR="$HOME/.ssh"

hr "SSH Key Setup"

# Create .ssh directory if it doesn't exist
if [ ! -d "$SSH_DIR" ]; then
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
  ok ".ssh directory created"
fi

# Check if SSH key already exists
if [ -f "$SSH_KEY" ]; then
  ok "SSH key already exists at $SSH_KEY"
else
  info "Generating new SSH key..."
  ssh-keygen -t ed25519 -C "maarcusreniero.l@gmail.com" -f "$SSH_KEY" -N ""
  ok "SSH key generated"
fi

# Ensure ssh-agent is running and add key
eval "$(ssh-agent -s)" > /dev/null 2>&1 || true

# Add key to ssh-agent (macOS specific config for persistent passphrase)
cat > "$SSH_DIR/config" <<EOF
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
ok "SSH config created"

ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || ssh-add "$SSH_KEY"
ok "SSH key added to ssh-agent"

# Display public key
hr "GitHub Setup"
info "Copy the SSH public key below and add it to GitHub:"
info "https://github.com/settings/keys"
echo ""
cat "$SSH_KEY.pub"
echo ""
ok "SSH setup complete!"
