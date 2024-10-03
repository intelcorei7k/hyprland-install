#!/bin/bash
# Hyprland Packages #

# edit your packages desired here.

# add packages wanted here
Extra=(

)

hypr_package=(
  aylurs-gtk-shell
  cliphist
  curl
  hyprshot
  gvfs
  gvfs-mtp
  qview
  inxi
  alacritty
  kvantum
  vim
  jq
  network-manager-applet
  pamixer
  pavucontrol
  pipewire-alsa
  playerctl
  polkit-gnome
  qt5ct
  qt6ct
  qt6-svg
  rofi-wayland
  swaync
  swww
  waybar
  wget
  wl-clipboard
  wlogout
  xdg-user-dirs
  xdg-utils
  yad
)

# the following packages can be deleted. however, dotfiles may not work properly
hypr_package_2=(
  brightnessctl
  btop
  fastfetch
  mpv
  mpv-mpris
  vlc
  nvtop
  nwg-look
  yt-dlp
  wine
  rust
  go
  p7zip
  librewolf-bin
  vesktop
  steam
  piper
  gedit
)

# List of packages to uninstall as it conflicts with swaync and rofi-wayland
uninstall=(
  dunst
  mako
  wallust-git
)

# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_hypr-pkgs.log"

# uninstalling conflicting packages
# Initialize a variable to track overall errors
overall_failed=0

printf "\n%s - Removing Mako and Dunst as they conflict with swaync \n" "${NOTE}"
for PKG in "${uninstall[@]}"; do
  uninstall_package "$PKG" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    # Track if any uninstallation failed
    overall_failed=1
  fi
done

if [ $overall_failed -ne 0 ]; then
  echo -e "${ERROR} Some packages failed to uninstall. Please check the log."
fi


# Installation of main components
printf "\n%s - Installing hyprland packages.... \n" "${NOTE}"

for PKG1 in "${hypr_package[@]}" "${hypr_package_2[@]}" "${Extra[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 Package installation failed, Please check the installation logs"
    exit 1
  fi
done

clear
