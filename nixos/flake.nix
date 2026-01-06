{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = [
      (final: prev: {
        yubikey-agent = prev.yubikey-agent.overrideAttrs (old: {
          src = final.fetchFromGitHub {
            owner = "robbiev";
            repo = "yubikey-agent";
            rev = "241d24f8cbc130a3fa74f352680362c3e49461eb";
            sha256 = "sha256-uST/hgf8OjmK21YQpO9rXwPrvjI7VZMJB/iY91ATOv0=";
          };
          vendorHash = "sha256-JMDuPzIIdr5dL/e02DGt8GlaH2jq2U2w5GbTd95Qb1Q=";
        });
      })
      # Patch xpadneo until this issue is fixed: https://github.com/NixOS/nixpkgs/issues/467164
      # (final: prev: {
      #   linuxPackages_latest = prev.linuxPackages_latest.extend (lfinal: lprev: {
      #     xpadneo = lprev.xpadneo.overrideAttrs (old: {
      #       patches =
      #         (old.patches or [])
      #         ++ [
      #           (prev.fetchpatch {
      #             url = "https://github.com/orderedstereographic/xpadneo/commit/233e1768fff838b70b9e942c4a5eee60e57c54d4.patch";
      #             hash = "sha256-HL+SdL9kv3gBOdtsSyh49fwYgMCTyNkrFrT+Ig0ns7E=";
      #             stripLen = 2;
      #           })
      #         ];
      #     });
      #   });
      # })
    ];
  in {
    nixosConfigurations.neo = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        {nixpkgs.overlays = overlays;}
      ];
      specialArgs = {
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      };
    };
  };
}
