{
  inputs = {
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.pre-commit-hooks-nix.flakeModule ];

      systems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { pkgs, config, ... }: {
        devShells.default = pkgs.mkShellNoCC {
          inherit (config.pre-commit.devShell) shellHook;
          packages = [ pkgs.nixfmt ];
        };

        pre-commit.settings.hooks.nixfmt.enable = true;

        formatter = pkgs.nixfmt;
      };
    };
}
