{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { nixpkgs, ... }@ inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
      {
        nixosConfigurations = {
          nixos = nixpkgs.lib.nixosSystem {
            modules = [
              ./nixos/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  extraSpecialArgs = { inherit inputs; };
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.jasonmj.imports = [./home-manager/home.nix];
                };
              }
              inputs.xremap-flake.nixosModules.default
              {
                services.xremap = {
                  config = (import ./nixos/modules/xremap/default.nix { inherit pkgs; });
                  serviceMode = "user";
                  userName = "jasonmj";
                  withWlroots = true;
                };
              }
            ];
          };
        };
      };
}
