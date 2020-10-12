let
  sources = import ./nix/sources.nix;
in
  {pkgs ? import sources.nixpkgs {} }:

  pkgs.mkShell {
    buildInputs = with pkgs; [
      ghc
      cabal-install
      ormolu
      hlint
      ghcid
      niv
    ];
  }
