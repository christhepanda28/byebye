{pkgs, ...}: {
  name = "byebye";
  compiler-nix-name = "ghc983"; # Version of GHC to use
  nixpkgs.overlays = [
    (self: super: {
      haskell-nix =
        super.haskell-nix
        // {
          extraPkgconfigMappings =
            super.haskell-nix.extraPkgconfigMappings
            // {
              # String pkgconfig-depends names are mapped to lists of Nixpkgs
              # package names
              "glib" = ["glib"];
              "gi-gobject" = ["haskellPackages.gi-gobject"];
            };
        };
    })
  ];
  shell.buildInputs = with pkgs; [
    haskellPackages.gi-gobject
    glib
  ];

  shell.nativeBuildInputs = with pkgs; [pkg-config];
  #  crossPlatforms = p:
  #    pkgs.lib.optionals pkgs.stdenv.hostPlatform.isx86_64 ([
  #        p.mingwW64
  #        # p.ghcjs # TODO GHCJS support for GHC 9.2
  #      ]
  #      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
  #        p.musl64
  #      ]);

  # Tools to include in the development shell
  shell.tools.cabal = "latest";
  #shell.tools.hlint = "latest";
  #shell.tools.haskell-language-server = "latest";
}
