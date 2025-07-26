{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.neo = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
      ];
      specialArgs = {
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      };
    };
  };
}
