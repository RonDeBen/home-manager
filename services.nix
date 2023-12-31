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
}
