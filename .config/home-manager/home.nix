{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "25.05";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    zip
    xz
    unzip
    ripgrep
    fzf
    jq
    git
    tree

    stow # dotfiles

    chromium
    firefox-wayland

    neovim
    ghostty

    signal-desktop
    bitwarden-desktop
    youtube-music

    zig
    zls
    go
    gopls
    stylua
    alejandra
    nodePackages.prettier
    ruff
    rustfmt

    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.config-connector
    ])
  ];

  xdg.desktopEntries = {
    # Signal needs the tray icon to be able to show the window on Wayland
    # (niri), and Electron apps can't correctly infer the password store in
    # niri, as it hard codes allowed XDG_CURRENT_DESKTOP values. So I override
    # the Signal desktop shortcut to add the necessary command line flags.
    signal = {
      name = "Signal";
      type = "Application";
      exec = "${pkgs.signal-desktop}/bin/signal-desktop --use-tray-icon --password-store=gnome-libsecret";
      icon = "signal-desktop";
      categories = ["Network" "InstantMessaging" "Chat"];
      mimeType = ["x-scheme-handler/sgnl" "x-scheme-handler/signalcaptcha"];
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/robbiev/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
