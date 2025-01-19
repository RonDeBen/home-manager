{ pkgs, ... }: {
  home.file = {
    # A script for recommending installing of docker
    "install-docker" = {
      executable = true;
      target = ".local/bin/install-docker.sh";
      text = ''
        #!${pkgs.bash}/bin/bash

        if [ -x "$(command -v docker)" ]
        	then

        	${pkgs.gum}/bin/gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Awesome Docker is already installed!!!"

        else

        	${pkgs.gum}/bin/gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Installing Docker"

        	cd /tmp
        	${pkgs.curl}/bin/curl -fsSL https://get.docker.com -o get-docker.sh
        	ls get-docker.sh
        	SUDO_ASKPASS=~/.local/bin/gum-askpass.sh sudo -A sh ./get-docker.sh
        	rm ./get-docker.sh

        	echo Adding user to docker group
        	sudo groupadd docker
        	sudo usermod -aG docker $USER

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

        if ! [ -x "$(command -v docker)" ]
        	then
        	docker-install.sh
        fi

        if ! [ -x "$(command -v k3s)" ]
        	then

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

        ${pkgs.gum}/bin/gum spin -s line --title "line" -- sleep 3
        ${pkgs.gum}/bin/gum spin -s dot --title "dot" -- sleep 3
        ${pkgs.gum}/bin/gum spin -s minidot --title "minidot" -- sleep 3
        ${pkgs.gum}/bin/gum spin -s jump --title "jump" -- sleep 3
        ${pkgs.gum}/bin/gum spin -s pulse --title "pulse" -- sleep 3
        ${pkgs.gum}/bin/gum spin -s points --title "points" -- sleep 3
        ${pkgs.gum}/bin/gum spin -s globe --title "globe" -- sleep 3
        ${pkgs.gum}/bin/gum spin -s moon --title "moon" -- sleep 3
        ${pkgs.gum}/bin/gum spin -s monkey --title "monkey" -- sleep 3
        ${pkgs.gum}/bin/gum spin -s meter --title "meter" -- sleep 3
        ${pkgs.gum}/bin/gum spin -s hamburger --title "hamburger" -- sleep 3
      '';

    };

    "vpn-connect" = {
      executable = true;
      target = ".local/bin/vpn-connect.sh";
      text = ''
        #!${pkgs.bash}/bin/bash

        ${pkgs.gum}/bin/gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Connecting to the Praeses VPN.."

        OPENCONNECT_PID=$(pidof openconnect)
        if [ "$OPENCONNECT_PID" != "" ]; then
          # Gracefully terminate any existing openconnect process
          SUDO_ASKPASS=~/.local/bin/gum-askpass.sh sudo -A killall -SIGINT openconnect
        fi

        # Ensure the script uses the correct HOME directory
        export HOME=/home/$USER

        if [ -x "$(command -v nscd)" ]; then
          # Use this if nscd is installed
          SUDO_ASKPASS=~/.local/bin/gum-askpass.sh sudo -A ${pkgs.openconnect}/bin/openconnect --config $HOME/.config/openconnect/config -u "$USER" --setuid="$USER"
          ${pkgs.gum}/bin/gum spin -s monkey --title "Resetting NSCD" -- sudo systemctl restart nscd
        else
          # Use this if nscd is not installed
          SUDO_ASKPASS=~/.local/bin/gum-askpass.sh sudo -A ${pkgs.openconnect}/bin/openconnect --config $HOME/.config/openconnect/config
          ${pkgs.gum}/bin/gum spin -s monkey --title "Resetting SSSD" -- sudo systemctl restart sssd
        fi

        # Fix locale issues
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
      '';
    };

    "vpn-disconnect" = {
      executable = true;
      target = ".local/bin/vpn-disconnect.sh";
      text = ''
        #!${pkgs.bash}/bin/bash

        ${pkgs.gum}/bin/gum style --border normal --margin "2" --padding "1 2" --border-foreground 212 "Disconnecting from the Praeses VPN.."

        OPENCONNECT_PID=$(pidof openconnect)
        if [ "$OPENCONNECT_PID" != "" ]
        	then
        	${pkgs.gum}/bin/gum spin -s globe --title "Disconnecting from vpn" -- sudo killall -SIGINT openconnect
        	SUDO_ASKPASS=~/.local/bin/gum-askpass.sh sudo -A echo ""

        	if [ -x "$(command -v nscd)" ]
        		then
        		${pkgs.gum}/bin/gum spin -s dot --title "Reseting NSCD" -- sudo systemctl restart nscd
        		else
        		${pkgs.gum}/bin/gum spin -s dot --title "Reseting SSSD" -- sudo systemctl restart sssd
        	fi
        fi
      '';
    };

    # Standard config for vpn
    "openconnect-config" = {
      target = ".config/openconnect/config";
      text = ''
        pid-file /tmp/openconnect-vpn
        server vpn.praeses.com
        syslog
        timestamp
        background
        protocol gp
      '';

    };

    "askpass" = {
      executable = true;
      target = ".local/bin/gum-askpass.sh";
      text = ''
        #!${pkgs.bash}/bin/bash

        ${pkgs.gum}/bin/gum input --placeholder "sudo password for $USER..." --password
      '';
    };

    "zellij-attach-session" = {
      executable = true;
      target = ".local/bin/session-attach.sh";
      text = ''
        #!${pkgs.bash}/bin/bash

        SESSION=$(${pkgs.zellij}/bin/zellij list-sessions | ${pkgs.gum}/bin/gum filter --placeholder 'Pick session...')

        echo attching to $SESSION

        S=$(echo $SESSION | cut -d " " --fields 1)
        exec ${pkgs.zellij}/bin/zellij attach $S
      '';
    };

    "zellij-delete-session" = {
      executable = true;
      target = ".local/bin/session-delete.sh";
      text = ''
        #!${pkgs.bash}/bin/bash


        SESSION=$(${pkgs.zellij}/bin/zellij list-sessions | ${pkgs.gum}/bin/gum filter --placeholder 'Pick session to remove...')

        echo removing $SESSION

        echo $SESSION | cut -d " " --fields 1 | xargs ${pkgs.zellij}/bin/zellij delete-session
      '';
    };

    "k8s-praeses-dns" = {
      executable = true;
      target = ".local/bin/install-k8s-praeses-dns.sh";
      text = ''
        #!${pkgs.bash}/bin/bash

        if ! ${pkgs.kubectl}/bin/kubectl get namespace default > /dev/null 2>&1
        	then

        	${pkgs.gum}/bin/gum style --border normal --margin "2" --padding "1 2" --border-foreground 212 "You are not connected to a k8s cluster"
        	exit 1
        fi

        ${pkgs.gum}/bin/gum style --border normal --margin "2" --padding "1 2" --border-foreground 212 "You are connected to" "$(${pkgs.kubectl}/bin/kubectl get nodes)"

        if ${pkgs.gum}/bin/gum confirm "Apply Praeses DNS to this cluster?"
        	then

        	${pkgs.kubectl}/bin/kubectl apply -f ~/.config/k8s/praeses-dns.yaml
        	${pkgs.kubectl}/bin/kubectl rollout restart deployment/coredns --namespace kube-system
        fi
      '';
    };

    "k8s-praeses-dns-yaml" = {
      target = ".config/k8s/praeses-dns.yaml";
      text = ''
        apiVersion: v1
        kind: ConfigMap
        metadata:
          name: coredns-custom
          namespace: kube-system
        data:
          praeses.server: |
            praeses.com {
              forward . 192.168.100.7 192.168.100.23
            }
      '';
    };
  };

}
