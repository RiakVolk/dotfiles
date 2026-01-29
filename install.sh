#!/usr/bin/env bash
set -Eeuo pipefail

### =========================
### CONFIG
### =========================
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

PACMAN_PKGS=(
  # Core
  git
  neovim
  tmux
  bash
  ripgrep
  xdg-utils

  # Wayland / Hyprland stack
  hyprland
  xorg-xwayland
  wayland
  wayland-protocols
  xdg-desktop-portal-hyprland

  # UI tools
  waybar
  rofi
  alacritty

  # File manager
  nemo
  gvfs
  gvfs-mtp

  # Audio (minimal, safe)
  pipewire
  pipewire-pulse
  wireplumber

  # Utils
  fastfetch
)

### =========================
### FUNCTIONS
### =========================
msg() { printf "\n\033[1;32m==> %s\033[0m\n" "$1"; }
err() {
  printf "\n\033[1;31mERROR: %s\033[0m\n" "$1"
  exit 1
}

need_cmd() {
  command -v "$1" &>/dev/null || err "Required command '$1' not found"
}

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
  fi
}

### =========================
### PRE-FLIGHT CHECKS
### =========================
msg "Running pre-flight checks"

need_cmd sudo
need_cmd pacman
need_cmd git

if [ "$EUID" -eq 0 ]; then
  err "Do NOT run this script as root"
fi

### =========================
### SYSTEM UPDATE
### =========================
msg "Updating system"
sudo pacman -Syu --noconfirm

### =========================
### PACKAGE INSTALL
### =========================
msg "Installing required packages only"

sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

### =========================
### CONFIG BACKUP
### =========================
msg "Backing up existing configs (if any)"

backup_if_exists "$CONFIG_DIR/hypr"
backup_if_exists "$CONFIG_DIR/waybar"
backup_if_exists "$CONFIG_DIR/rofi"
backup_if_exists "$CONFIG_DIR/alacritty"
backup_if_exists "$CONFIG_DIR/fastfetch"
backup_if_exists "$CONFIG_DIR/tmux"
backup_if_exists "$CONFIG_DIR/nvim"
backup_if_exists "$HOME/.bashrc"
backup_if_exists "$HOME/.tmux.conf"

### =========================
### COPY CONFIGS
### =========================
msg "Deploying configs"

mkdir -p "$CONFIG_DIR"

[ -d hypr ] && cp -r hypr "$CONFIG_DIR/"
[ -d waybar ] && cp -r waybar "$CONFIG_DIR/"
[ -d rofi ] && cp -r rofi "$CONFIG_DIR/"
[ -d alacritty ] && cp -r alacritty "$CONFIG_DIR/"
[ -d fastfetch ] && cp -r fastfetch "$CONFIG_DIR/"
[ -d tmux ] && cp -r tmux "$CONFIG_DIR/"

[ -f bash/bashrc ] && cp bash/bashrc "$HOME/.bashrc"
[ -f tmux/tmux.conf ] && cp tmux/tmux.conf "$HOME/.tmux.conf"

### =========================
### LAZYVIM INSTALL
### =========================
msg "Installing LazyVim"

LAZYVIM_DIR="$CONFIG_DIR/nvim"

git clone https://github.com/LazyVim/starter "$LAZYVIM_DIR"
rm -rf "$LAZYVIM_DIR/.git"

### =========================
### FINAL CHECKS
### =========================
msg "Verifying installs"

need_cmd nvim
need_cmd tmux
need_cmd hyprland
need_cmd rofi
need_cmd waybar
need_cmd alacritty
need_cmd nemo

### =========================
### DONE
### =========================
msg "Installation completed successfully"

echo
echo "Backups (if any) stored in:"
echo "  $BACKUP_DIR"
echo
echo "Next steps:"
echo "  1. Log into Hyprland"
echo "  2. Run: nvim   (LazyVim will install plugins)"
echo "  3. Check RAM with: free -m"
echo
