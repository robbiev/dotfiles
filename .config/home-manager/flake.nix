{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-25-05.url = "github:nixos/nixpkgs/nixos-25.05";

    ghostty.url = "github:ghostty-org/ghostty";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure home-manager uses the same nixpkgs as the main flake
    };
  };
  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-25-05,
    home-manager,
    ghostty,
    ...
  }: let
    username = "robbiev";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    pkgs-25-05 = import nixpkgs-25-05 {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    homeConfigurations = {
      "${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
          }
        ];
        extraSpecialArgs = {
          inherit pkgs-unstable;
          inherit pkgs-25-05;
          inherit ghostty;
        };
      };
    };
  };
}
