{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:guibou/nixGL";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixgl, ... }:
    let
      system = "x86_64-linux";

      overlays = [
        (final: prev: {
          alacritty =
            (nixpkgs-unstable.legacyPackages.${final.system}).alacritty;
        })
      ];

      pkgs = import nixpkgs {
        inherit system;
        overlays = overlays;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations."rondeben" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit nixgl; # you already use this for nixGLWrap
            inherit nixpkgs-unstable; # optional: expose it to modules too
          };

          modules = [
            ./home.nix
            ./programs.nix
            ./files.nix
            ./packages.nix
            ./services.nix
            ./sway.nix

            {
              home.username = "rondeben";
              home.homeDirectory = "/home/rondeben";
              home.stateVersion = "24.05";
              targets.genericLinux.enable = true;
              # allowUnfree set above at pkgs import (best place)
              home.sessionPath = [ "$HOME/.local/share/bob/nvim-bin" ];
            }
          ];
        };
    };
}

