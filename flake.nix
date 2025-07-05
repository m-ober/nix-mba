{
  description = "nikki's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nix-darwin,
    ...
  }: let
    configuration = {
      config,
      pkgs,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        bat
        cargo
        ffmpeg
        fzf
        git
        nixos-rebuild
        rustc
        wget
        yt-dlp
      ];

      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;

      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 6;

      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;

      security.pam.services.sudo_local.touchIdAuth = true;

      system.primaryUser = "mober";

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          cleanup = "none"; # TODO change to "zap" after migration
          upgrade = true;
        };
        brews = [
          "btop"
        ];
        casks = [
        ];
        caskArgs = {
          no_quarantine = true;
        };
      };
    };
  in {
    darwinConfigurations."mba" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
      ];
    };
  };
}
