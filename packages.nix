{ pkgs, ... }:

let nerd-fonts = pkgs.callPackage ./nerdfonts { };

in {
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # Custom Fonts
    nerd-fonts

    # CLI Tools
    pkgs.topgrade
    pkgs.tmux # Terminal multiplexer
    pkgs.xdg-utils # cli tools for desktop stuff
    pkgs.eslint_d # linting, but with faster d

    pkgs.bottom # Like top but at the bottom
    pkgs.curl # it's curl.  I use this to demo NIX
    pkgs.devspace # local development against k8s
    pkgs.direnv # auto load .envrc file per dir
    pkgs.docker-compose # run multiple containers with docker
    pkgs.du-dust # find large files in a directory
    pkgs.eza # new ls command written in rust
    pkgs.fd # alternative to find written in rust
    pkgs.fluxcd # gitops cli
    pkgs.freerdp # remote desktop tool to connect to windows
    pkgs.frei # view free memory
    pkgs.fzf # general purpose fuzzy finder, used with many other tools
    pkgs.glab # command line client for gitlab
    pkgs.httpie # cli alternative for PostMAN
    pkgs.k6 # load tester which can run on k8s
    pkgs.k9s # tui to communicate with k8s
    pkgs.krew # k8s tool to install k8s packages
    #pkgs.kubectl # official cli to communicate with k8s
    pkgs.kubernetes-helm # helm package manager for k8s
    pkgs.kubie # tool to manage multiple k8s configs
    #pkgs.kubernetes
    pkgs.lazygit # tui for git
    pkgs.gitui # tui for git (but rustier)
    pkgs.mongosh # next gen cli for mongodb
    pkgs.mtr # my trace route...better than ping
    pkgs.nats-top # NATS top commands
    pkgs.natscli # official NATS cli
    pkgs.neofetch # General system information
    pkgs.neofetch # General system information
    pkgs.neovim # THE editor
    pkgs.nerd-font-patcher # add nerd fonts to your font
    pkgs.nitrogen # fast and lightweight desktop background browser
    pkgs.par # align paragraphs
    pkgs.procs # rust alternative to ps -- it's so so
    pkgs.rage # rust alternative to age encryption
    pkgs.ripgrep # rg -- a much better grep
    pkgs.socat # lib required to allow k8s port-forward to work
    pkgs.spicedb-zed # zed cli client
    pkgs.tokei # count your code quickly
    pkgs.trunk # rust web server
    pkgs.xclip # cli to communicate with the X11 clipboard
    pkgs.xsv # awesome tool to work with csv files
    pkgs.yarn # install node packages
    pkgs.yed # yed High-quaility graph diagrams

    # RUST Tools

    pkgs.cargo-cache # print size of dirs and remove dirs selectively
    pkgs.cargo-nextest # better testing cli -- drop in replacement for cargo test
    pkgs.cargo-update # update all rust packages installe with cargo
    pkgs.cargo-watch # watch files change and run command
    pkgs.rustup # the way to manage the rust language

    # .NET Tools NOTE: the languages don't play nicely together

    # pkgs.dotnet-sdk
    # pkgs.dotnet-sdk_7
    # pkgs.dotnet-sdk_8 # LTS dot net

    # Gnome Tools
    pkgs.gnomeExtensions.tray-icons-reloaded # Make sure tray icons appear -- seems like it's not working

    # Browsers

    # will override my username/history
    # TODO: may not need these. defaults are kinda good at updating
    pkgs.microsoft-edge # Edge
    pkgs.google-chrome # Google Chrome
    pkgs.brave # Brave Browser
    pkgs.firefox-devedition # dev firefox

    # Others
    #pkgs.blueman # bluetooth GUI
    pkgs.shutter # screenshotting tool
    pkgs.ffmpegthumbnailer # videos thumbnailer
    pkgs.font-manager # a font viewer
    pkgs.libreoffice # alternative to ms office suite
    pkgs.mongodb-compass # office mongodb GUI tool
    pkgs.mongodb-tools # several mongodb cli tools
    pkgs.policycoreutils # SELinux policy core utilities
    pkgs.poppler # pdf renderer
    pkgs.postgresql # pg database tools
    pkgs.slack # slack
    # pkgs.spotify # spotify
    pkgs.ueberzugpp # utility to allow drawing images in the terminal
    pkgs.unar # the unarchiver
    # pkgs.unityhub # download and manage Unity projects/installations
    pkgs.rofi # window switch / dmenu replacement
    pkgs.rofimoji # emoji selector
    # pkgs.gcc # gnu compilr collection
    # pkgs.openssl # secure communication (needed for making TUIs in rust)

    #pkgs.pgadmin #pg admin

    pkgs.nodejs # node :c
    pkgs.nodejs.pkgs.pnpm # better node package manager
    pkgs.git-open # easier git navigation
    pkgs.feh # a lightweight image viewer

    # LSP / Formatters

    pkgs.luajitPackages.luarocks # lua LSP
    pkgs.nixfmt # nix formatter
    pkgs.statix # nix lints & suggestions
    pkgs.nixpkgs-fmt # another nix formatter
    pkgs.nodePackages.prettier # code formatter
    pkgs.nodePackages.tailwindcss # css generator
    pkgs.nodePackages.typescript-language-server # javascript / typescript lsp
    pkgs.nodePackages.yaml-language-server # yaml lsp
    pkgs.omnisharp-roslyn # .NET lsp
    pkgs.python39Packages.autopep8 # python lsp
    pkgs.rnix-lsp # nix lsp
    pkgs.shfmt # shell script formatter
    pkgs.sqlfluff # sql formatter NOTE: pick your sql dialect
    pkgs.stylua # lua formater
    pkgs.uncrustify # .NET formatter
    pkgs.R # software environment for the statistical programming langauge
    pkgs.rstudio # tools/IDE for the R langauge
    # xpkgs.ocaml # functional programming langauge
    # pkgs.opam # pacakge manager for ocaml
    # pkgs.go # google lang
    pkgs.sqlfluff # sql formatter
    pkgs.yamllint # a linter for yaml
    pkgs.yaml-language-server # an lsp for yaml
    pkgs.yamlfmt # formatting for yaml
    pkgs.pgformatter # formatting for postgres

    # Environment Tools
    # pkgs.i3 # tiling window manager
    # pkgs.polybar # customizable status bar
  ];
}
