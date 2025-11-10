{
  config,
  pkgs,
  pkgs-unstable,
  ghostty,
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
    git-lfs
    tree
    broot

    jujutsu
    kakoune

    stow # dotfiles

    ungoogled-chromium
    firefox-wayland
    librewolf
    pkgs-unstable.yt-dlp
    ffmpeg
    vlc

    pkgs-unstable.obs-studio

    neovim
    universal-ctags
    lite-xl
    lite
    tracy
    vis

    lorien

    ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    # (writeShellScriptBin "command" ''
    #   # This exists to work around a bug in the ghostty fish shell SSH integration.
    #   # It runs "env TERM=... command" and fish shell doesn't like that
    #   echo "$@"
    #   exec "$@"
    # '')

    foot

    signal-desktop
    bitwarden-desktop
    pkgs-unstable.aseprite

    libreoffice
    hunspell
    hunspellDicts.en_GB-ise
    hunspellDicts.en_US
    hunspellDicts.nl_NL

    pkgs-unstable.odin
    pkgs-unstable.ols
    pkgs-unstable.zig_0_15
    pkgs-unstable.zls_0_15
    go
    gopls
    stylua
    alejandra
    nodePackages.prettier
    ruff
    rustfmt
    kdlfmt # niri config file
    pkgs-unstable.claude-code
    bun

    x11_ssh_askpass
    keychain # use this to manage the ssh agent
    fish
    fishPlugins.foreign-env # load home manager session vars
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  # Apps like Ghostty require a GTK theme for icons
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  programs.direnv.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_transparent_mono";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
      };
      editor.file-picker = {
        hidden = false;
      };
      editor.popup-border = "all";
      editor.gutters = ["diagnostics" "spacer" "diff"];
    };
    themes = {
      # https://github.com/helix-editor/helix/blob/master/runtime/themes/base16_transparent.toml
      base16_transparent_mono = {
        "inherits" = "base16_transparent";
        "comment" = "green";
        "ui.background" = {};
        "ui.selection" = {modifiers = ["reversed"];};
        "ui.virtual.whitespace" = {};
        "ui.statusline" = {modifiers = ["reversed"];};
        "variable" = {};
        "constant.numeric" = {};
        "constant" = {};
        "attribute" = {};
        "type" = {};
        "string" = {};
        "variable.other.member" = {};
        "constant.character.escape" = {};
        "function" = {};
        "constructor" = {};
        "special" = {};
        "keyword" = {};
        "label" = {};
        "namespace" = {};

        "markup.heading" = {modifiers = ["bold"];};
        "markup.list" = {};
        "markup.bold" = {};
        "markup.italic" = {};
        "markup.strikethrough" = {};
        "markup.link.url" = {};
        "markup.link.text" = {};
        "markup.quote" = {};
        "markup.raw" = {};
        "markup.normal" = {};
        "markup.insert" = {};
        "markup.select" = {};

        # "diff.plus" = {};
        # "diff.delta" = {};
        # "diff.delta.moved" = {};
        # "diff.minus" = {};

        # "ui.gutter" = {};
        # "info" = {};
        # "hint" = {};
        # "debug" = {};
        # "warning" = {};
        # "error" = {};

        # "diagnostic.info" = {};
        # "diagnostic.hint" = {};
        # "diagnostic.debug" = {};
        # "diagnostic.warning" = {};
        # "diagnostic.error" = {};
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.alejandra}/bin/alejandra";
      }
      {
        name = "kdl";
        auto-format = true;
        formatter.command = "${pkgs.kdlfmt}/bin/kdlfmt";
        formatter.args = ["format" "-"];
      }
    ];
  };

  # xdg.desktopEntries = {
  #   # Signal needs the tray icon to be able to show the window on Wayland
  #   # (niri), and Electron apps can't correctly infer the password store in
  #   # niri, as it hard codes allowed XDG_CURRENT_DESKTOP values. So I override
  #   # the Signal desktop shortcut to add the necessary command line flags.
  #   signal = {
  #     name = "Signal";
  #     type = "Application";
  #     exec = "${pkgs.signal-desktop}/bin/signal-desktop --use-tray-icon --password-store=gnome-libsecret";
  #     icon = "signal-desktop";
  #     categories = ["Network" "InstantMessaging" "Chat"];
  #     mimeType = ["x-scheme-handler/sgnl" "x-scheme-handler/signalcaptcha"];
  #   };
  # };

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

    #DISPLAY = ":0";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    MOZ_ENABLE_WAYLAND = "1";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland";
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";
    LITE_SCALE = "1.5";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
