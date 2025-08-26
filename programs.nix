{ pkgs, nixgl, ... }:
let
  nixGL = nixgl.packages.${pkgs.system};

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
  programs = {
    # json parser
    jq.enable = true;
    # cat with syntax highlighting
    bat.enable = true;
    # terminal file browser
    yazi.enable = true;
  };

  # terminal multiplexer
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi"; # or "emacs", depending on your preference

    # Plugins
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.gruvbox;
        extraConfig = "set -g @tmux-gruvbox 'dark'";
      }
      # tmuxPlugins.dracula
    ];

    # Basic Tmux options
    extraConfig = ''
      # Nice defaults
      set -g focus-events on
      set -g status-style bg=default
      set -g status-left-length 90
      set -g status-right-length 90
      set -g status-justify centre

      # Key bindings
      bind-key '"' split-window -v -c '#{pane_current_path}'
      bind-key % split-window -h -c '#{pane_current_path}'
      bind-key c new-window -c '#{pane_current_path}'

      # Monokai Pro Color Scheme
      set -g status-style fg='#fcfcfa',bg='#2d2a2e'
      set -g status-left-style fg='#ffd866',bg='#727072'
      set -g status-right-style fg='#78dce8',bg='#727072'
      set -g window-status-style fg='#727072',bg='#2d2a2e'
      set -g window-status-current-style fg='#78dce8',bg='#2d2a2e'
      set -g pane-border-style fg='#727072',bg='#2d2a2e'
      set -g pane-active-border-style fg='#78dce8',bg='#2d2a2e'
      set -g message-style fg='#fcfcfa',bg='#2d2a2e'
      set -g message-command-style fg='#fcfcfa',bg='#2d2a2e'
    '';
  };

  # faster way to go to directory
  programs.zoxide.enable = true;

  # terminal better than gnome term
  # WARNING: at the time of writing this, the nix package was 0.12.3, but
  # the nixGL wrap will error out, unless you are at least version 0.13
  # install alacritty through cargo
  programs.alacritty = {
    enable = true;
    package = nixGLWrap pkgs.alacritty;
    settings = {
      window = {
        opacity = 1.0;
        padding = {
          x = 5;
          y = 5;
        };
      };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      font = {
        normal = {
          # family = "0xProto Nerd Font";
          family = "Noto SansM NF";
          style = "Regular";
        };
        size = 11.0;
        #draw_bold_text_with_bright_colors = true;
      };
      colors = {
        primary = {
          background = "0x2D2A2E";
          foreground = "0xfff1f3";
        };
        normal = {
          black = "0x2c2525";
          red = "0xfd6883";
          green = "0xadda78";
          yellow = "0xf9cc6c";
          blue = "0xf38d70";
          magenta = "0xa8a9eb";
          cyan = "0x85dacc";
          white = "0xfff1f3";
        };
        bright = {
          black = "0x72696a";
          red = "0xfd6883";
          green = "0xadda78";
          yellow = "0xf9cc6c";
          blue = "0xf38d70";
          magenta = "0xa8a9eb";
          cyan = "0x85dacc";
          white = "0xfff1f3";
        };
      };
      cursor = { style = { shape = "Beam"; }; };
      env = { WINIT_UNIX_BACKEND = "wayland"; };
    };
  };

  # create change logs from git commits
  programs.git-cliff.enable = true;

  # your git config
  programs.git = {
    enable = true;
    userName = "Ron DeBenedetti";
    userEmail = "ron.debenedetti@praeses.com";
    difftastic.enable = true;

    extraConfig = {
      commit = { gpgSign = "true"; };
      user = { signingKey = "F2B5049310B0CB9E"; };
      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red bold";
          new = "green bold";
          whitespace = "red reverse";
        };
        status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
        };
      };
      core = {
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      };
      merge = { tool = "meld"; };
      diff = { tool = "meld"; };
    };

    aliases = {
      st = "status";
      ci = "commit";
      br = "branch";
      co = "checkout";
      df = "diff";
      logs =
        "log --graph --decorate --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --date=relative --abbrev-commit --all";
      lg =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      lga =
        "log --graph --decorate --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --date=relative --abbrev-commit --all";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      ls = "ls-files";
      spull = "svn rebase";
      spush = "svn dcommit";
    };
  };

  # vscode using a different package
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };

  # update your entire system
  programs.topgrade = {
    enable = true;
    settings = {
      misc = {
        assume_yes = true;
        cleanup = true;
        disable = [ "firmware" "containers" ];
      };
    };
  };

  # like man, but just the examples
  programs.tealdeer = {
    enable = true;
    settings = { updates.auto_update = true; };
  };

  # better default prompt
  # put initializers in my fish command
  # side effect: may have put in env things
  # check here if terminal is weird
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./configs/starship.toml;
  };

  # rust helper
  programs.bacon = {
    enable = true;
    settings = {
      export.enabled = true;
      jobs = {
        default = {
          command = [ "cargo" "build" "--all-features" "--color" "always" ];
          need_stdout = true;
        };
      };
    };
  };

  # better than bash
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --group-directories-first";
      # røk = "rok";
      pn = "pnpm";
      vpn =
        "sudo openconnect --background --protocol=gp vpn.praeses.com; and echo 'restarting sssd'; and sudo systemctl restart sssd";
      tmux = "tmux -f ~/.config/tmux/tmux.conf";
      rook = "~/projects/rook/tools/rook";
    };
    shellInit = ''
          # Start ssh-agent if it's not already running
      if not pgrep -u $USER ssh-agent > /dev/null
          eval $(ssh-agent -s)
          set -x SSH_AUTH_SOCK $SSH_AUTH_SOCK
      end
      set -l bobbin $XDG_DATA_HOME/bob/nvim-bin

      # Add the key using keychain
      if test -z "$SSH_AUTH_SOCK"
          eval (keychain --eval --agents ssh ~/.ssh/id_ed25519)
      end


        set -gx PNPM_HOME /home/ron.debenedetti/.local/share/pnpm
        set -gx PATH $PNPM_HOME/bin $HOME/.local/bin $HOME/.yarn/bin $HOME/.cargo/bin $PATH
        set -gx SHELL ${pkgs.fish}/bin/fish
        set -gx PATH $HOME/.nix-profile/bin $PATH
        set -gx PATH /home/rondeben/.nix-profile/bin $PATH
        set -gx PATH /usr/bin $PATH

        # Monokai Fish shell theme
        set -g fish_color_normal F8F8F2 # the default color
        set -g fish_color_command A6E22E # the color for valid commands (changed to green)
        set -g fish_color_quote E6DB74 # the color for quoted blocks of text
        set -g fish_color_redirection AE81FF # the color for IO redirections
        set -g fish_color_end F8F8F2 # the color for process separators like ';' and '&'
        set -g fish_color_error F92672 --background=default # the color for errors (changed to red)
        set -g fish_color_param A6E22E # the color for regular command parameters
        set -g fish_color_comment 75715E # the color used for code comments
        set -g fish_color_match F8F8F2 # the color used to highlight matching parenthesis15
        set -g fish_color_search_match --background=49483E # the color used to highlight history search matches
        set -g fish_color_operator AE81FF # the color for parameter expansion operators like '*' and '~'
        set -g fish_color_escape 66D9EF # the color used to highlight character escapes like '\n' and '\x70'
        set -g fish_color_cwd 66D9EF # the color used for the current working directory in the default prompt

        # Completion Pager Colors
        set -g fish_pager_color_prefix F8F8F2 # the color of the prefix string, i.e. the string that is to be completed
        set -g fish_pager_color_completion 75715E # the color of the completion itself
        set -g fish_pager_color_description 49483E # the color of the completion description
        set -g fish_pager_color_progress F8F8F2 # the color of the progress bar at the bottom left corner
        set -g fish_pager_color_secondary F8F8F2 # the background color of the every second completion
    '';
    functions = { gi = "curl -sL https://www.gitignore.io/api/$argv"; };
  };

  # programs.neovim = {
  #     enable = true;
  #     plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammers];
  # };
}
