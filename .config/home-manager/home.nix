{
  config,
  pkgs,
  pkgs-unstable,
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

    # Workaround for kernel 6.15.4
    # https://github.com/ghostty-org/ghostty/discussions/7720
    (ghostty.overrideAttrs (_: {
      preBuild = ''
        shopt -s globstar
        sed -i 's/^const xev = @import("xev");$/const xev = @import("xev").Epoll;/' **/*.zig
        shopt -u globstar
      '';
    }))
    foot

    signal-desktop
    bitwarden-desktop
    youtube-music

    libreoffice
    hunspell
    hunspellDicts.en_GB-ise
    hunspellDicts.en_US
    hunspellDicts.nl_NL

    zig
    zls
    go
    gopls
    stylua
    alejandra
    nodePackages.prettier
    ruff
    rustfmt
    pkgs-unstable.claude-code

    x11_ssh_askpass
    keychain # use this to manage the ssh agent
    fish
    fishPlugins.foreign-env
  ];

  # Apps like Ghostty require a GTK theme for icons
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  programs.direnv.enable = true;

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
    SSH_ASKPASS = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
