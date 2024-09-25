{
  description = "Parametric version of the 3d printed cat ears often seen at CCC events.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        name = "parametric-cat-ears";
        packages.default = pkgs.stdenv.mkDerivation {
          name = "cat-ears";
          src = ./.;
          nativeBuildInputs = [ pkgs.openscad ];
          buildPhase = ''
            openscad -o cat-ears.stl ./cat-ears.scad
          '';
          installPhase = ''
            mkdir -p $out
            cp cat-ears.stl $out/
          '';
        };
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.openscad
            pkgs.clang-tools # For formatting the scad file
          ];
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
