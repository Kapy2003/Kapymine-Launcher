<img src="https://raw.githubusercontent.com/Kapy2003/Kapymine-Launcher/refs/heads/main/kapymine.png" alt="Kapymine Launcher Icon" width="100" />

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

✅ Automatically fetches the latest Minecraft version from [PrismLauncher By Diegiwg](https://github.com/Diegiwg/PrismLauncher-Cracked)<br>
✅ Creates PrismLauncher-compatible instances  
✅ Offline account setup for quick testing  
✅ Zenity-based graphical menus:<br>
✅ Supports uninstall via a dedicated script  

---

## 📂 Project Structure

```
Kapymine-Launcher/
├── kapymine-launcher.sh # Main launcher script
├── uninstall.sh # Uninstaller script
├── install.sh # Installer script
├── kapymine.png # Icon
└── README.md # This file
```

---

## 💻 Installation

1. **Installation**

```bash
pacman -S --needed git base-devel
git clone https://github.com/Kapy2003/kapymine-Launcher.git --depth 1
cd kapymine-Launcher
./install.sh
```

2. **Uninstallation**

```bash
cd kapymine-Launcher
./uninstall.sh
```

3. **Dependencies**

#### Arch:
```bash
sudo pacman -S jq zenity
```

#### Debian/Ubuntu:
```bash
sudo apt install jq zenity
```
