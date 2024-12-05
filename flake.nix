{
  # This is a template created by `hix init`
  inputs.haskellNix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.follows = "haskellNix/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    haskellNix,
  }: let
    supportedSystems = [
      "x86_64-linux"
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      overlays = [
        haskellNix.overlay
        (final: prev: {
          hixProject = final.haskell-nix.hix.project {
            src = ./.;
            evalSystem = "x86_64-linux";
          };
        })
      ];
      pkgs = import nixpkgs {
        inherit system overlays;
        inherit (haskellNix) config;
      };
      flake = pkgs.hixProject.flake {};
    in
      flake
      // {
        legacyPackages = pkgs;

        packages = flake.packages // {default = flake.packages."byebye:exe:byebye";};
      })
    // {
      # NixOS module for system-wide installation
      nixosModules.byebye = {
        config,
        lib,
        pkgs,
        ...
      }:
        with lib; {
          options.programs.byebye = {
            enable = mkEnableOption "ByeBye logout utility";

            package = mkOption {
              type = types.package;
              default = self.packages.x86_64-linux.default;
              description = "ByeBye package to use";
            };
          };

          config = mkIf config.services.byebye.enable {
            environment.systemPackages = [self.packages.x86_64-linux.default];
          };
        };

      # --- Flake Local Nix Configuration ----------------------------
      nixConfig = {
        # This sets the flake to use the IOG nix cache.
        # Nix should ask for permission before using it,
        # but remove it here if you do not want it to.
        extra-substituters = ["https://cache.iog.io"];
        extra-trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
        allow-import-from-derivation = "true";
      };
    };
}
