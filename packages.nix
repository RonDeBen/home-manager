{ pkgs, ... }:

let
  nerd-fonts = pkgs.callPackage ./nerdfonts { };

  nixGL = import <nixgl> { };

  # Define the wrapper function for applications requiring nixGL
  nixGLWrap = pkg:
    let
      bin = "${pkg}/bin";
      executables = builtins.attrNames (builtins.readDir bin);
      wrappedPkg = pkgs.buildEnv {
        name = "nixGL-${pkg.name}";
        paths = [ pkg ] ++ map (name:
          pkgs.hiPrio (pkgs.writeShellScriptBin name ''
            exec -a "$0" ${nixGL.nixGLIntel}/bin/nixGLIntel ${bin}/${name} "$@"
          '')) executables;
      };
    in wrappedPkg // { inherit (pkg) version; };

in {
  nixpkgs.overlays = [ (import ./configs/overlays/gifine/gifine.nix) ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    vlc
    tree-sitter

    # gifsicle #for optimizing gifs
    # ffmpeg # for creating mp4 and recording desktop
    # graphicsmagick #for creating gifs
    # slop # needed to select an area for screen recording
    # gifine # make gifs from screen recordings
    # Custom Fonts
    nerd-fonts

    # CLI Tools
    qdirstat # like windirstat, but for linux
    minio-client # a client for minio (duh)
    miller # a jq-like utility for CSV files
    topgrade
    tmux # Terminal multiplexer
    xdg-utils # cli tools for desktop stuff
    tree # show directory tree
    keychain # password manager

    bottom # Like top but at the bottom
    curl # it's curl.  I use this to demo NIX
    devspace # local development against k8s
    direnv # auto load .envrc file per dir
    # docker-compose # run multiple containers with docker
    du-dust # find large files in a directory
    eza # new ls command written in rust
    fd # alternative to find written in rust
    # fluxcd # gitops cli
    # freerdp # remote desktop tool to connect to windows
    frei # view free memory
    fzf # general purpose fuzzy finder, used with many other tools
    glab # command line client for gitlab
    httpie # cli alternative for PostMAN
    #pkgs.k6 # load tester which can run on k8s
    #pkgs.k9s # tui to communicate with k8s
    #pkgs.krew # k8s tool to install k8s packages
    #pkgs.kubectl # official cli to communicate with k8s
    #pkgs.kubernetes-helm # helm package manager for k8s
    #pkgs.kubie # tool to manage multiple k8s configs
    #pkgs.kubernetes
    #pkgs.lazygit # tui for git
    gitui # tui for git (but rustier)
    mongosh # next gen cli for mongodb
    mtr # my trace route...better than ping
    nats-top # NATS top commands
    natscli # official NATS cli
    neofetch # General system information
    nerd-font-patcher # add nerd fonts to your font
    nitrogen # fast and lightweight desktop background browser
    par # align paragraphs
    procs # rust alternative to ps -- it's so so
    rage # rust alternative to age encryption
    ripgrep # rg -- a much better grep
    socat # lib required to allow k8s port-forward to work
    spicedb-zed # zed cli client
    tokei # count your code quickly
    trunk # rust web server
    xclip # cli to communicate with the X11 clipboard
    xsv # awesome tool to work with csv files
    yarn # install node packages
    yed # yed High-quaility graph diagrams

    # RUST Tools

    cargo-cache # print size of dirs and remove dirs selectively
    cargo-nextest # better testing cli -- drop in replacement for cargo test
    cargo-update # update all rust packages installe with cargo
    cargo-watch # watch files change and run command
    rustup # the way to manage the rust language

    # Browsers

    # will override my username/history
    # TODO: may not need these. defaults are kinda good at updating
    microsoft-edge # Edge
    (nixGLWrap pkgs.google-chrome)
    brave # Brave Browser
    (nixGLWrap pkgs.firefox-devedition)

    # Others
    shutter # screenshotting tool
    ffmpegthumbnailer # videos thumbnailer
    font-manager # a font viewer
    libreoffice # alternative to ms office suite
    mongodb-compass # office mongodb GUI tool
    mongodb-tools # several mongodb cli tools
    policycoreutils # SELinux policy core utilities
    poppler # pdf renderer
    postgresql # pg database tools
    slack # slack
    # pkgs.spotify # spotify
    ueberzugpp # utility to allow drawing images in the terminal
    unar # the unarchiver
    unityhub # download and manage Unity projects/installations
    rofi # window switch / dmenu replacement
    rofimoji # emoji selector
    # pkgs.gcc # gnu compilr collection
    # pkgs.openssl # secure communication (needed for making TUIs in rust)
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.tumbler # thunar thumbnails

    pgadmin4 # pg admin
    # pkgs.pgadmin4-desktopmode

    nodejs_20 # Explicitly use Node.js 20
    nodePackages.pnpm # Ensure pnpm is installed via Nixpkgs
    nodePackages.typescript-language-server # tsserver
    nodePackages.eslint_d # ESLint daemon
    nodePackages.prettier # Prettier for formatting
    nixpkgs-fmt # Nix file formatter
    #alejandra             # Alternative Nix formatter
    statix # Nix linting
    taplo # TOML formatter
    # nodejs_20 # node :c
    # nodejs.pkgs.pnpm # better node package manager
    # NOTE: you'll need to run: xdg-settings set default-web-browser firefox-devedition.pgadmin4-desktop
    # (or some variant), or else it defaults to brave
    git-open # easier git navigation
    http-server # run npm servers with this
    feh # a lightweight image viewer

    # LSP Tools
    luajitPackages.luarocks # Lua LSP
    nodePackages.typescript-language-server # JavaScript/TypeScript LSP
    nodePackages.yaml-language-server # YAML LSP
    efm-langserver # EFM language server for general formatting/linting
    omnisharp-roslyn # .NET LSP
    elixir-ls # Elixir Language Server
    nil # nix LSP

    # Formatters
    nixfmt-classic # Nix formatter
    taplo # TOML formatter
    nodePackages.prettier # Code formatter (technically a linter too :shrug:)
    nodePackages.tailwindcss # CSS formatter/generator
    stylua # Lua formatter
    uncrustify # .NET formatter
    sqlfluff # SQL formatter
    yamlfmt # YAML formatter
    pgformatter # Postgres SQL formatter
    shfmt # Shell script formatter

    # Linters
    luajitPackages.luacheck # Lua linter
    eslint_d # JavaScript/TypeScript linter (daemon version)
    yamllint # YAML linter
    sqlfluff # SQL linter (also doubles as a formatter)
    statix # Nix linting and suggestions

    # Dependencies for LSP/Tools
    elixir # Elixir runtime
    erlang # Required for Elixir tooling
    inotify-tools # File system monitoring (used by some tools)

    capnproto # protodef stuff

    gimp # like photoshop, but Linux and FOSS

    simplescreenrecorder # even simpler screen recording tool
  ];
}
