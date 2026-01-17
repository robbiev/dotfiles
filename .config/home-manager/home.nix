{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-25-05,
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
    tree
    broot

    stow # dotfiles

    ungoogled-chromium
    firefox
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
    emacs-pgtk

    git
    git-lfs
    jujutsu
    lazygit

    lorien

    ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    # (writeShellScriptBin "command" ''
    #   # This exists to work around a bug in the ghostty fish shell SSH integration.
    #   # It runs "env TERM=... command" and fish shell doesn't like that
    #   echo "$@"
    #   exec "$@"
    # '')

    foot

    pkgs-unstable.signal-desktop
    pkgs-unstable.bitwarden-desktop
    aseprite

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
    fish
    fishPlugins.foreign-env # load home manager session vars

    restic

    yubikey-manager
    pkgs-unstable.yubioath-flutter
    age
    age-plugin-yubikey
    pkgs-25-05.age-plugin-se # Failed to build on 25.11, see https://github.com/NixOS/nixpkgs/issues/462451
    passage
    qrencode

    syncthing
    syncthingtray
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

  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;

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

  xdg.desktopEntries = {
    # See https://nixos.wiki/wiki/Chromium and https://wiki.archlinux.org/title/Chromium#Hardware_video_acceleration
    # Important: AcceleratedVideoEncoder, VaapiVideoDecodeLinuxGL, AcceleratedVideoDecodeLinuxGL
    chromium-browser = {
      name = "Chromium";
      type = "Application";
      exec = "${pkgs.ungoogled-chromium}/bin/chromium --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder,Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,VaapiIgnoreDriverChecks,VaapiVideoDecoder,VaapiVideoEncoder,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo,WaylandWindowDecorations --disable-features=UseChromeOSDirectVideoDecoder --ignore-gpu-blocklist %U";
      icon = "chromium";
      categories = ["Network" "WebBrowser"];
      mimeType = ["text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https"];
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
