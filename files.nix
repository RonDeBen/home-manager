{ pkgs, ... }: {
  home.file = {
    # A script for recommending installing of docker
    "install-docker" = {
      executable = true;
      target = ".local/bin/install-docker.sh";
      text = ''
        #!${pkgs.bash}/bin/bash

        if [ -x "$(command -v docker)" ]; then
          ${pkgs.gum}/bin/gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Awesome, Docker is already installed!"
        else
          ${pkgs.gum}/bin/gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Installing Docker"

          cd /tmp
          ${pkgs.curl}/bin/curl -fsSL https://get.docker.com -o get-docker.sh
          SUDO_ASKPASS=~/.local/bin/gum-askpass.sh sudo -A sh ./get-docker.sh
          rm -f ./get-docker.sh

          echo "Adding user to docker group (log out/in after)…"
          sudo groupadd docker 2>/dev/null || true
          sudo usermod -aG docker "$USER"

          ${pkgs.gum}/bin/gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Logout to complete the installation."
        fi
      '';
    };

    # A script to install k3s which is connected to your local docker
    "install-k3s" = {
      executable = true;
      target = ".local/bin/install-k3s.sh";
      text = ''
        #!${pkgs.bash}/bin/bash
        if ! [ -x "$(command -v docker)" ]; then
          install-docker.sh
        fi

        if [ -x "$(command -v k3s)" ]; then
          ${pkgs.gum}/bin/gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Updating k3s"
        else
          ${pkgs.gum}/bin/gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Installing k3s"
        fi

        ${pkgs.curl}/bin/curl -sfL https://get.k3s.io | sh -s - --docker
      '';
    };

    "gum-test" = {
      executable = true;
      target = ".local/bin/gum-spinners.sh";
      text = ''
        #!${pkgs.bash}/bin/bash
        ${pkgs.gum}/bin/gum spin -s line --title "line" -- sleep 1
        ${pkgs.gum}/bin/gum spin -s dot --title "dot" -- sleep 1
        ${pkgs.gum}/bin/gum spin -s minidot --title "minidot" -- sleep 1
        ${pkgs.gum}/bin/gum spin -s jump --title "jump" -- sleep 1
        ${pkgs.gum}/bin/gum spin -s pulse --title "pulse" -- sleep 1
        ${pkgs.gum}/bin/gum spin -s points --title "points" -- sleep 1
        ${pkgs.gum}/bin/gum spin -s globe --title "globe" -- sleep 1
        ${pkgs.gum}/bin/gum spin -s moon --title "moon" -- sleep 1
        ${pkgs.gum}/bin/gum spin -s monkey --title "monkey" -- sleep 1
        ${pkgs.gum}/bin/gum spin -s meter --title "meter" -- sleep 1
        ${pkgs.gum}/bin/gum spin -s hamburger --title "hamburger" -- sleep 1
      '';
    };

    # =========================
    # Adobe VPN (GlobalProtect)
    # =========================

    # Per-user openconnect config (Adobe)
    "openconnect-config" = {
      target = ".config/openconnect/config";
      text = ''
        # ~/.config/openconnect/config
        protocol gp
        server vpn.adobe.com
        syslog
        timestamp
        background
        pid-file /tmp/openconnect-vpn

        # After your first successful connection you can pin the server cert:
        # servercert sha256:AA:BB:CC:…  # paste the fingerprint shown by openconnect

        # If you MUST pin a specific gateway instead of the portal:
        # usergroup gateway
        # authgroup "Gateway Name"
      '';
    };

    # gum-based sudo askpass helper
    "askpass" = {
      executable = true;
      target = ".local/bin/gum-askpass.sh";
      text = ''
        #!${pkgs.bash}/bin/bash
        exec ${pkgs.gum}/bin/gum input --placeholder "sudo password for $USER..." --password
      '';
    };

    # Connect to Adobe VPN (password/MFA in terminal)
    "vpn-connect" = {
      executable = true;
      target = ".local/bin/vpn-connect.sh";
      text = ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        ${pkgs.gum}/bin/gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Connecting to the Adobe VPN…"

        # Gracefully terminate any existing openconnect
        if pgrep -x openconnect >/dev/null 2>&1; then
          SUDO_ASKPASS="$HOME/.local/bin/gum-askpass.sh" sudo -A killall -SIGINT openconnect || true
          sleep 1
        fi

        export HOME="/home/$USER"
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8

        TARGET="${
          "1:-"
        }"   # optional: pass a gateway IP/host to override the portal

        if [ -x "$(command -v nscd)" ]; then
          # Use this if nscd is installed; drop privileges after connect
          if [ -n "$TARGET" ]; then
            SUDO_ASKPASS="$HOME/.local/bin/gum-askpass.sh" sudo -A ${pkgs.openconnect}/bin/openconnect \
              --protocol=gp --config "$HOME/.config/openconnect/config" -u "$USER" --setuid="$USER" "$TARGET"
          else
            SUDO_ASKPASS="$HOME/.local/bin/gum-askpass.sh" sudo -A ${pkgs.openconnect}/bin/openconnect \
              --protocol=gp --config "$HOME/.config/openconnect/config" -u "$USER" --setuid="$USER"
          fi
          ${pkgs.gum}/bin/gum spin -s monkey --title "Restarting nscd" -- sudo systemctl restart nscd
        else
          # If nscd is not installed (common), run without --setuid and restart sssd if present
          if [ -n "$TARGET" ]; then
            SUDO_ASKPASS="$HOME/.local/bin/gum-askpass.sh" sudo -A ${pkgs.openconnect}/bin/openconnect \
              --protocol=gp --config "$HOME/.config/openconnect/config" -u "$USER" "$TARGET"
          else
            SUDO_ASKPASS="$HOME/.local/bin/gum-askpass.sh" sudo -A ${pkgs.openconnect}/bin/openconnect \
              --protocol=gp --config "$HOME/.config/openconnect/config" -u "$USER"
          fi
          ${pkgs.gum}/bin/gum spin -s monkey --title "Restarting sssd" -- sudo systemctl restart sssd || true
        fi

        ${pkgs.gum}/bin/gum style --border normal --margin "1" --padding "1 2" --border-foreground 41 "VPN should be up."
      '';
    };

    "vpn-disconnect" = {
      executable = true;
      target = ".local/bin/vpn-disconnect.sh";
      text = ''
        #!${pkgs.bash}/bin/bash
        ${pkgs.gum}/bin/gum style --border normal --margin "2" --padding "1 2" --border-foreground 212 "Disconnecting from Adobe VPN…"

        if pgrep -x openconnect >/dev/null 2>&1; then
          ${pkgs.gum}/bin/gum spin -s globe --title "Disconnecting VPN" -- sudo killall -SIGINT openconnect
          SUDO_ASKPASS="$HOME/.local/bin/gum-askpass.sh" sudo -A true

          if [ -x "$(command -v nscd)" ]; then
            ${pkgs.gum}/bin/gum spin -s dot --title "Resetting nscd" -- sudo systemctl restart nscd
          else
            ${pkgs.gum}/bin/gum spin -s dot --title "Resetting sssd" -- sudo systemctl restart sssd || true
          fi
        else
          echo "No openconnect process found."
        fi
      '';
    };
  };
}

