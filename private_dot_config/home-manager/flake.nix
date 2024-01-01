{
  description = "Home Manager configuration of n16hth4wk";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    overlays = [
      neovim-nightly-overlay.overlay
    ];
  in {
    homeConfigurations."n16hth4wk" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        (_: {
          nixpkgs.overlays = overlays;
          nixpkgs.config.allowUnfreePredicate = _:true;
        })

        ./home.nix
      ];
    };
  };
}
