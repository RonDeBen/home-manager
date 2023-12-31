# Assumptions

You are using the default bash shell.  You might be using fish, zsh, or another shell.   If you run
bash first, then switch to your shell that'll be fine.

## Steps

1. Clone this repo into `~/.config/home-manager/` and tweak for your account
2. Install Nix
3. Add channels
4. Install Home Manager
5. Relogin (this will get desktop icons/fonts working)

## Details

### Clone Repo

Items you will want to change will be at least...

* your user name in the `home.nix` file.
* your git user name in the `programs.nix` file.

When the install runs it will try to copy configs for the programs to their default locations.
If you have any of them installed, it will not copy over the configs, but it will error out.
For the initial install, I would recommend take a backup of your configs (fish, alacritty, kitty, topgrade, etc.),
and let home-manager do the inital setup.  To find a full list of programes which will write configs see the `programs.nix` file.


### Nix Install

After you complete the configuration of your new repo, you will be ready to install nix and home manager.

#### Useful links
https://nixos.org/download.html
https://github.com/nix-community/nixGL
https://nix-community.github.io/home-manager/index.html#sec-install-standalone


I used the single user install.  The multi user install needs to be tested a bit more.  It seemed Chase had a few issues with it.

The following commands will install nix and all two channels, one for nixGL and another for home-manager.
Once this is complete, update the channels and install home-manager.  When the home-manager command runs, it will install
all the software defined in the repository.  Make sure you have updated the `home.nix` and `programs.nix` files!!!!

```sh
sh <(curl -L https://nixos.org/nix/install) --no-daemon
nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

# Setup devenv
```sh
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use devenv
nix-env -if https://install.devenv.sh/latest
```

At this point, home manager should be installed and the new environment setup.   The fonts will look really bad right now.
That is because your system does not know how to find the new font.   Log out and relogin (or reboot) to see the new fonts.

# Shell integration

Add this to the bottom of the .bashrc file.  If you don't want to use fish, then change it to your perfered shell.

```bash
exec fish --login
```


# How to work with home manager

Update the files in your new repo, then run the following command.

```sh
home-manager switch
```

If you not feeling so lucky run this first
```sh
home-manager build
```

# Other useful commands / scripts which are installed

All of theses are located in the `files.nix` file.

* `docker-install.sh` This will install docker if it is not installed
* `k3s-install.sh` This will install k3s and connect it to docker
* `vpn-connect.sh` This will connect/reconnect to our VPN
* `vpn-disconect.sh` This will connect to our VPN


