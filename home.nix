{ config, pkgs, ... }:
let
  inherit (config.lib) dag;
in {
  nixpkgs.config.allowUnfree = true;

  # Required to get the fonts installed by home-manager to be picked up by OS.
  fonts.fontconfig.enable = true;

  # See https://discourse.nixos.org/t/home-manager-installed-apps-dont-show-up-in-applications-launcher/8523/2.
  targets.genericLinux.enable = true;

  # Add manual for home manager
  # Access from `home-manager-help`
  manual = {
    html.enable = true;
    manpages.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "ron.debenedetti";
    homeDirectory = "/home/ron.debenedetti/";
    sessionPath = [ "/opt/firefox" ];
  };
  home.sessionVariables = {
    # BROWSER = "/usr/bin/firefox -new-tab";
    BROWSER = "/usr/bin/firefox";
    EDITOR = "nvim";
  };

  # home.sessionVariables = {
  #   DISPLAY_MANAGER_SESSION = "none+i3";
  # };

  # home.activation.setXDGbrowser = dag.entryBefore [ "linkGeneration" ] ''
  #    xdg-settings set default-web-browser firefox.desktop
  # '';

  # home.activation.setXDGbrowser = let
  #   script = ''
  #     unset BROWSER
  #     ${pkgs.xdg-utils}/bin/xdg-settings set default-web-browser firefox.desktop
  #   '';
  # in dag.entryBefore [ "linkGeneration" ] script;

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  imports = [ ./files.nix ./packages.nix ./services.nix ./programs.nix ];
}
