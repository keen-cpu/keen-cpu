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

        lib = pkgs.lib;

      in
      {
        devShells.default = pkgs.mkShell (
          let
            pre-commit-bin = "${lib.getBin pkgs.pre-commit}/bin/pre-commit";
          in
          {
            packages = with pkgs; [
              black
              glibcLocales
              mdformat
              pre-commit
              ruff
              scons
              shfmt
              toml-sort
              treefmt2
              verible
              verilator
              yamlfmt
            ];

            shellHook = ''
              ${pre-commit-bin} install --allow-missing-config > /dev/null
            '';
          }
        );

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
