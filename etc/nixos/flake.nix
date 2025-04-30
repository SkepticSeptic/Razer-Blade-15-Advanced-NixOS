{
  description = "NixOS config with razer-laptop-control";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    razerdaemon.url = "path:./external/razer-laptop-control";
  };

  outputs = { self, nixpkgs, flake-utils, razerdaemon, ... }@inputs: {
    nixosConfigurations = {
      theDevil = let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ ... }@args:
            import ./configuration.nix (
              args // {
                inherit inputs pkgs;
              }
            )
          )
          razerdaemon.nixosModules.default
        ];
      };
    };
  };
}
