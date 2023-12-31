{ config, pkgs, callPackage, ... }: {

  # Required for flameshot
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  services = {
    dunst.enable = true;
    lorri.enable = true;
    flameshot.enable = true;
  };

  systemd.user.services.monitor-setup = {
    Unit = {
      Description = "Monitor Setup";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart =
        "${pkgs.coreutils}/bin/bash /home/ron.debenedetti/.local/bin/orient_monitors.sh";
      Type = "oneshot";
      RemainAfterExit = true;
    };
    Install = { WantedBy = [ "default.target" ]; };
  };
}
