let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  compilerVersion = "ghc884";
  compiler = pkgs.haskell.packages."${compilerVersion}";
  pkg = compiler.developPackage {
    root = ./.;
    source-overrides = {};
    modifier = drv:
      pkgs.haskell.lib.addBuildTools drv (with pkgs.haskellPackages;
        [ cabal-install
          ghcid
          ormolu
          hlint
        ]);
  };
  buildInputs = [ pkgs.zlib ];
in pkg.overrideAttrs(attrs: {
  builldInputs = attrs.buildInputs ++ buildInputs;
})
