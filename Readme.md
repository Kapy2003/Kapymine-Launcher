# Kapymine Launcher

Kapymine Launcher is a simple, user-friendly Bash-based Minecraft launcher wrapper.  
It automates:

- Creating an offline Minecraft account.
- Downloading and launching the latest vanilla Minecraft release.
- Managing multiple installed versions.
- Providing a clean graphical interface via Zenity.

> **Note:** This project is intended for educational and personal use.  

---

## 🚀 Features

✅ Automatically fetches the latest Minecraft version  
✅ Creates PrismLauncher-compatible instances  
✅ Generates `prismlauncher.cfg` if missing  
✅ Offline account setup for quick testing  
✅ Zenity-based graphical menus:
- **Play / Select Version**
- **Install New**
- **Cancel**

✅ Supports uninstall via a dedicated script  

---

## 📂 Project Structure

Kapymine-Launcher/
├── kapymine-launcher.sh # Main launcher script
├── uninstall.sh # Uninstaller script
├── install.sh # Installer script
├── kapymine.png # Icon
└── README.md # This file

---

## 💻 Installation

1. **Clone the repository**

```bash

pacman -S --needed git base-devel
git clone https://github.com/Kapy2003/Kapymine-Launcher.git
cd Kapymine-Launcher
./install.sh

