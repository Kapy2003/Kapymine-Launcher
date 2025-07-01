#!/bin/bash

# ─── Paths ────────────────────────────────────────────────
PRISM_APPIMAGE="/usr/share/kapymine-launcher/kapymine-launcher.AppImage"
INSTANCES_DIR="$HOME/.local/share/PrismLauncher/instances"
ACCOUNTS_FILE="$HOME/.local/share/PrismLauncher/accounts.json"
PRISM_CONF="$HOME/.local/share/PrismLauncher/prismlauncher.cfg"

# ─── Dependencies Check ───────────────────────────────────
for cmd in zenity jq uuidgen; do
  command -v "$cmd" >/dev/null || {
    zenity --error --text="Missing dependency: $cmd"
    exit 1
  }
done

# ─── Offline Account Setup ────────────────────────
if [ ! -f "$ACCOUNTS_FILE" ] || ! jq -e '.accounts | length > 0' "$ACCOUNTS_FILE" &>/dev/null; then
  username=$(zenity --entry \
    --title="Create Offline Account" \
    --text="Enter a Minecraft username:")

  if [[ $? -ne 0 || -z "$username" ]]; then
    echo "User cancelled account creation or entered nothing."
    exit 0
  fi

  uuid=$(echo -n "OfflinePlayer:$username" | md5sum | cut -d' ' -f1)
  client_token=$(uuidgen | tr -d '-')
  iat=$(date +%s)

  new_account=$(jq -n \
    --arg uuid "$uuid" \
    --arg username "$username" \
    --arg ctoken "$client_token" \
    --argjson iat "$iat" \
    '{
      active: true,
      profile: {
        capes: [],
        id: $uuid,
        name: $username,
        skin: { id: "", url: "", variant: "" }
      },
      type: "Offline",
      ygg: {
        extra: { clientToken: $ctoken, userName: $username },
        iat: $iat,
        token: "0"
      }
    }')

  mkdir -p "$(dirname "$ACCOUNTS_FILE")"
  [[ ! -s "$ACCOUNTS_FILE" ]] && echo '{"accounts":[],"formatVersion":3}' > "$ACCOUNTS_FILE"

  tmp=$(mktemp)
  jq '.accounts |= map(.active = false)' "$ACCOUNTS_FILE" > "$tmp" && mv "$tmp" "$ACCOUNTS_FILE"

  tmp=$(mktemp)
  jq --argjson new "$new_account" '.accounts += [$new]' "$ACCOUNTS_FILE" > "$tmp" && mv "$tmp" "$ACCOUNTS_FILE"
fi

# ─── Main Menu ────────────────────────────────────
while true; do
  mapfile -t versions < <(
    find "$INSTANCES_DIR" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf "%f\n"
  )

  #if [ ${#versions[@]} -eq 0 ]; then
  #  zenity --info --title="No Versions Found" \
  #    --text="No Minecraft versions found in:\n$INSTANCES_DIR\n\nOpening Prism Launcher..."
  #  "$PRISM_APPIMAGE" &
  #  inotifywait -e create -m "$INSTANCES_DIR" |
  #  while read -r _ _ file; do
  #    [ -d "$INSTANCES_DIR/$file" ] && break
  #  done
  #  exit 0
  #fi

# ─── Vanilla Instance Build ────────────────────────────────────

if [ ${#versions[@]} -eq 0 ]; then
  latest_version=$(curl -s https://piston-meta.mojang.com/mc/game/version_manifest_v2.json | jq -r '.latest.release')

  if [ -z "$latest_version" ]; then
    exit 1
  fi

  instance_dir="$INSTANCES_DIR/$latest_version-latest"
  mkdir -p "$instance_dir"

  # Create prismlauncher.cfg if not exists
  if [ ! -f "$PRISM_CONF" ]; then
    cat > "$PRISM_CONF" <<EOF
[General]
BackgroundCat=teawie
CloseAfterLaunch=true
TheCat=true
ToolbarsLocked=true
StatusBarVisible=false
ApplicationTheme=dark
IconTheme=pe_colored
Language=en_US
QuitAfterGameStop=true
EOF
  fi

  # Create instance.cfg
  cat > "$instance_dir/instance.cfg" <<EOF
InstanceType=OneSix
iconkey=default
IntendedVersion=$latest_version
name=$latest_version
EOF

  # Create mmc-pack.json
  cat > "$instance_dir/mmc-pack.json" <<EOF
{
  "components": [
    {
      "cachedName": "Minecraft",
      "cachedRequires": [
        {
          "suggests": "3.3.3",
          "uid": "org.lwjgl3"
        }
      ],
      "cachedVersion": "$latest_version",
      "important": true,
      "uid": "net.minecraft",
      "version": "$latest_version"
    }
  ],
  "formatVersion": 1
}
EOF
fi

# ─── User Input ────────────────────────────────────────────────
  action=$(zenity --question \
    --title="Minecraft Launcher" \
    --text="Choose what to do:" \
    --ok-label="Play / Select Version" \
    --cancel-label="Cancel" \
    --extra-button="Install New Version")

  response=$?

  if [[ "$action" == "Install New Version" ]]; then
    "$PRISM_APPIMAGE" &
    break
  elif [[ $response -eq 0 ]]; then
    mapfile -t versions < <(
      find "$INSTANCES_DIR" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -printf "%f\n"
    )

    selected_version=$(zenity --list \
      --title="Choose Minecraft Version" \
      --column="Available Versions" "${versions[@]}" \
      --height=10 --width=10)

    [ -n "$selected_version" ] && exec "$PRISM_APPIMAGE" -l "$selected_version"
  else
    break
  fi

done

