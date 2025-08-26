{ config, lib, pkgs, ... }:

{
  # wayland.windowManager.sway = {
  #   # package = pkgs.nixGLWrap pkgs.sway;
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  #   systemd.enable = true;

  #   config = {
  #     modifier = "Mod4";
  #     terminal = "alacritty";
  #     menu = "wofi --show drun";

  #     input."*" = {
  #       xkb_layout = "us";
  #       repeat_delay = "300";
  #       repeat_rate = "50";
  #     };

  #     bars = [{ command = "waybar"; }];

  #     keybindings = {
  #       "${config.wayland.windowManager.sway.config.modifier}+t" =
  #         "exec ${config.wayland.windowManager.sway.config.terminal}";

  #       "${config.wayland.windowManager.sway.config.modifier}+d" =
  #         "exec ${config.wayland.windowManager.sway.config.menu}";

  #       "${config.wayland.windowManager.sway.config.modifier}+Shift+e" =
  #         "exec swaymsg exit";

  #       "${config.wayland.windowManager.sway.config.modifier}+Shift+c" =
  #         "reload";
  #     };

  #   };
  # };

  # home.sessionVariables = {
  #   XCURSOR_THEME = "Adwaita";
  #   XCURSOR_SIZE = "24";
  # };

  home.packages = with pkgs; [
    waybar
    wofi
    mako
    polkit
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    grim
    slurp
    wl-clipboard
    swaybg
    mesa
    libglvnd
    vulkan-tools
    intel-media-driver
    libva-utils
    swayidle
    swaylock
    # xkeyboard-config
    libinput
    # xorg-wayland
    foot # terminal for sway
  ];

}
