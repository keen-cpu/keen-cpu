{
  description = "keen-cpu: base risc-v processor";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:

      let
        pkgs = import inputs.nixpkgs {
          inherit system;
        };

      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            toml-sort
            treefmt2
          ];
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
