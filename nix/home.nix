 { config, pkgs, lib, ... }:
let
  unstable = import <unstable> { };
  nixos = import <nixos> { };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "leet";
  home.homeDirectory = "/home/leet";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with unstable; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    unzip
    openssh
    git
    thefuck
    babashka
    rlwrap
    fira-code-nerdfont
    roswell
    go
    clojure
    leiningen
    gcc
    racket
    silver-searcher
    platinum-searcher
    fzf
    curl
    ripgrep
    tmux
    zig
    ocaml
    dune_3
    opam
    cmake
    kotlin
    julia-bin
    purescript
    # spago
    cookiecutter
    erlang_26
    lfe
    rebar3
    gnumake
    janet
    jpm
    nodejs_21
    nodePackages_latest.ts-node
    typescript
    bun
    aspell
    aspellDicts.ru
    aspellDicts.en
    aspellDicts.en-science
    aspellDicts.en-computers
    maxima
    wxmaxima
    nyxt
    idris2
    scala_3
    jdk21
    maven
    gradle
    luajit
    mermaid-cli
    svgbob
    gnuplot
    dbeaver
    insomnia
    visualvm
    htop
    ocamlPackages.utop
    tldr
    libtool
    libvterm
    bzip2
    moreutils
    jq
    jetbrains.idea-community
    rustup

    eza
    nnn
    btop
    neofetch
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ] ++ (with unstable; [
    vscode-langservers-extracted
    nodePackages_latest.typescript-language-server
    yaml-language-server
    nodePackages_latest.bash-language-server
    jdt-language-server
    zls
    ocamlPackages.lsp
    cmake-language-server
    clojure-lsp
    kotlin-language-server
    gopls
    marksman
    erlang-ls
    metals
    luajitPackages.lua-lsp
  ]);


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
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/leet/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.emacs = {
    enable = true;
    package = unstable.emacs; # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
  };

  programs.git = {
    enable = true;
    userName = "Victor Litvintsev";
    userEmail = "leetwinski@gmail.com";
  };

  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = true;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = false;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
    source ~/.bashrc.base

    alias ew="emacsclient -c"

    function e() {
        TERM=xterm-256color emacsclient -c -nw "$@"
    }

    function ff() {
        tmux new-window emacsclient -nw -c "$(fzf)"
    }

    function pp() {
        path="$(find ~/dev/projects/*/* -maxdepth 0  -type d -print | fzf)"
        if [ -z "$path" ]; then
            echo "project path is not specified"
            return 1
        fi
        new_name="$(echo $path | awk -F'/' '{print $NF}')"
        win_num="$(tmux list-windows -F '#I #W' | grep -m 1 "\[p\]$new_name\$" | awk '{print $1}')"
        if [ -z "$win_num" ]; then
            tmux neww -c "$path" -n "[p]$new_name" "emacsclient -nw -c $path" ';'\
                 splitw -l 14 -c '#{pane_current_path}' ';'\
                 select-pane -t 0 ';'\
                 resize-pane -Z
        else
            tmux select-window -t "$win_num"
        fi
    }

    eval "$(thefuck --alias)"
    eval "$(starship init bash)"

    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
    };
  };

  home.file.".emacs.d" = {
    recursive = true;
    source = ~/dotfiles/.emacs.d;
  };

  home.file.".tmux.conf" = {
    source = ~/dotfiles/.tmux.conf;
  };

  systemd.user.startServices = true;

  services.emacs.enable = true;
}
