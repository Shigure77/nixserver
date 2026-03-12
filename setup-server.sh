#!/usr/bin/env bash
# setup-server.sh — Replicates nixserver config without Nix (Raspberry Pi / Debian).
# Run as root or with sudo. Configures: Docker, NFS client, OpenSSH, packages,
# optional user, and user-level git/bash/Oh My Posh (Gruvbox Dark).

set -euo pipefail

# --- Config (edit these) ---
USERNAME="${SETUP_USER:-keion}"
GIT_NAME="${GIT_USER_NAME:-Keion}"
GIT_EMAIL="${GIT_USER_EMAIL:-you@example.com}"

# --- Helpers ---
log() { echo "[setup] $*"; }
die() { log "ERROR: $*"; exit 1; }

# Require root
if [[ $(id -u) -ne 0 ]]; then
  die "Run as root or with sudo"
fi

# Prefer apt (Debian / Raspberry Pi OS)
if command -v apt-get &>/dev/null; then
  PKG_UPDATE='apt-get update -qq'
  PKG_INSTALL='apt-get install -y -qq'
  PKG_AVAILABLE() { dpkg-query -W -f '${Status}' "$1" 2>/dev/null | grep -q 'install ok installed'; }
elif command -v dnf &>/dev/null; then
  PKG_UPDATE='dnf check-update -q || true'
  PKG_INSTALL='dnf install -y -q'
  PKG_AVAILABLE() { rpm -q "$1" &>/dev/null; }
else
  die "Unsupported package manager (apt or dnf required)"
fi

# --- System packages ---
log "Installing system packages..."
$PKG_UPDATE
$PKG_INSTALL \
  btop \
  wget \
  psmisc \
  pciutils \
  nfs-common \
  openssh-server \
  ca-certificates \
  curl \
  gnupg

# Docker (Debian/Raspberry Pi OS)
if ! command -v docker &>/dev/null; then
  log "Installing Docker..."
  if command -v apt-get &>/dev/null; then
    install -d -m 0755 /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "${VERSION_CODENAME:-bookworm}") stable" \
      > /etc/apt/sources.list.d/docker.list
    apt-get update -qq
    $PKG_INSTALL docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  else
    $PKG_INSTALL docker docker-compose-plugin || true
  fi
else
  log "Docker already installed"
fi

# Optional: docker-compose standalone (if not using plugin)
if ! docker compose version &>/dev/null; then
  $PKG_INSTALL docker-compose 2>/dev/null || true
fi

# Optional CLI tools (install if in repos)
for pkg in yazi duf fastfetch; do
  if ! command -v "$pkg" &>/dev/null; then
    $PKG_INSTALL "$pkg" 2>/dev/null || log "Optional $pkg not installed (not in repos)"
  fi
done

# --- Docker: enable on boot ---
log "Enabling Docker on boot..."
systemctl enable --now docker.service 2>/dev/null || true

# --- NFS client ---
log "Enabling NFS client..."
systemctl enable --now rpcbind 2>/dev/null || true
# nfs-common provides mount.nfs; no extra service needed on Debian

# --- OpenSSH ---
log "Configuring OpenSSH..."
sshd_config=/etc/ssh/sshd_config
if [[ -f "$sshd_config" ]]; then
  if grep -q '^#*PermitRootLogin' "$sshd_config"; then
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin prohibit-password/' "$sshd_config"
  else
    echo "PermitRootLogin prohibit-password" >> "$sshd_config"
  fi
  systemctl enable --now ssh 2>/dev/null || systemctl enable --now sshd 2>/dev/null || true
  log "OpenSSH enabled (PermitRootLogin prohibit-password)"
else
  log "OpenSSH config not found; ensure sshd is enabled manually"
fi

# --- Firewall: allow SSH (if ufw present) ---
if command -v ufw &>/dev/null; then
  ufw allow ssh 2>/dev/null || true
  log "UFW: ssh allowed (run 'ufw enable' if you use it)"
fi

# --- User ---
if ! id "$USERNAME" &>/dev/null; then
  log "Creating user $USERNAME..."
  useradd -m -s /bin/bash -c "Server admin" "$USERNAME"
  log "Set password for $USERNAME:"
  passwd "$USERNAME"
else
  log "User $USERNAME already exists"
fi

# Groups: sudo/wheel, docker, and network (Raspberry Pi often uses NetworkManager or no NM)
for grp in sudo wheel docker; do
  if getent group "$grp" &>/dev/null; then
    usermod -aG "$grp" "$USERNAME" 2>/dev/null || true
  fi
done
if getent group networkmanager &>/dev/null; then
  usermod -aG networkmanager "$USERNAME" 2>/dev/null || true
fi

# --- User-level config (run as that user) ---
USER_HOME=$(eval echo "~$USERNAME")
if [[ ! -d "$USER_HOME" ]]; then
  USER_HOME="/home/$USERNAME"
fi

# Git config
log "Configuring git for $USERNAME..."
sudo -u "$USERNAME" git config --global user.name "$GIT_NAME" 2>/dev/null || true
sudo -u "$USERNAME" git config --global user.email "$GIT_EMAIL" 2>/dev/null || true
sudo -u "$USERNAME" git config --global init.defaultBranch main 2>/dev/null || true
sudo -u "$USERNAME" git config --global pull.rebase false 2>/dev/null || true

# Bash: fastfetch on interactive login
log "Configuring bash (fastfetch on login)..."
bashrc="$USER_HOME/.bashrc"
touch "$bashrc"
chown "$USERNAME:$(id -gn "$USERNAME")" "$bashrc"
if ! grep -q 'fastfetch' "$bashrc" 2>/dev/null; then
  cat >> "$bashrc" << 'BASHRC'

# setup-server: fastfetch on interactive shell
if command -v fastfetch &>/dev/null && [[ -t 0 ]]; then
  fastfetch
fi
BASHRC
  log "Added fastfetch to $bashrc"
fi

# Oh My Posh (Gruvbox Dark)
if ! sudo -u "$USERNAME" test -x "$USER_HOME/.local/bin/oh-my-posh" 2>/dev/null; then
  log "Installing Oh My Posh for $USERNAME..."
  install -d -o "$USERNAME" -g "$(id -gn "$USERNAME")" "$USER_HOME/.local/bin"
  OMP_URL="https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm64"
  if [[ "$(uname -m)" == "x86_64" ]]; then
    OMP_URL="https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64"
  fi
  wget -q -O "$USER_HOME/.local/bin/oh-my-posh" "$OMP_URL" && chmod +x "$USER_HOME/.local/bin/oh-my-posh" && chown "$USERNAME:$(id -gn "$USERNAME")" "$USER_HOME/.local/bin/oh-my-posh" || log "Oh My Posh download failed (check arch)"
fi

# Oh My Posh: enable and set Gruvbox theme in bashrc
if [[ -x "$USER_HOME/.local/bin/oh-my-posh" ]]; then
  if ! grep -q 'oh-my-posh' "$bashrc" 2>/dev/null; then
    cat >> "$bashrc" << 'OMP'

# setup-server: Oh My Posh (Gruvbox Dark)
if [[ -x "$HOME/.local/bin/oh-my-posh" ]]; then
  eval "$("$HOME/.local/bin/oh-my-posh" init bash --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/gruvbox.omp.json")"
fi
export COLORFGBG="15;235"
OMP
    chown "$USERNAME:$(id -gn "$USERNAME")" "$bashrc"
    log "Oh My Posh (gruvbox) added to $bashrc"
  fi
fi

# Optional: JetBrains Mono Nerd Font (user-level)
FONT_DIR="$USER_HOME/.local/share/fonts"
if [[ ! -d "$FONT_DIR" ]]; then
  install -d -o "$USERNAME" -g "$(id -gn "$USERNAME")" "$FONT_DIR"
fi
if ! sudo -u "$USERNAME" test -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" 2>/dev/null; then
  if command -v unzip &>/dev/null; then
    log "Downloading JetBrains Mono Nerd Font..."
    tmpfont=$(mktemp -d)
    if wget -q "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -O "$tmpfont/JBM.zip"; then
      unzip -o -q -d "$FONT_DIR" "$tmpfont/JBM.zip" '*.ttf' 2>/dev/null || true
      chown -R "$USERNAME:$(id -gn "$USERNAME")" "$FONT_DIR" 2>/dev/null || true
      log "Fonts in $FONT_DIR (use in terminal preferences)"
    fi
    rm -rf "$tmpfont"
  else
    log "Skipping Nerd Font (install unzip to enable)"
  fi
fi

# --- Done ---
log "Done. Log in as $USERNAME to use Docker and new shell theme."
log "Edit git email: sudo -u $USERNAME git config --global user.email 'your@email.com'"
