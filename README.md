Resources to package a container running https://github.com/yogthos/mastodon-bot for NixOS

Status: not working yet.

Built by:
* Check out mastodon-bot
* `node2nix --nodejs-12 ~/dev/mastodon-bot-clean/package.json`
* edit node-packages.nix to point 'src' at github, to a branch that removes lumo-cljs from package.json
* edit configuration.nix to add the lumo dependency and update the scripts' shebang
* edit node-env.nix to set `NODE_PATH` when running executables

Generate your image by:
* `nixos-generate -f lxc -c configuration.nix; ./nixos-generate -f lxc-metadata -c /tmp/mst/configuration.nix`
* import it into lxd in one command: `lxc image import $(nixos-generate -f lxc-metadata -c configuration.nix) $(nixos-generate -f lxc -c configuration.nix)`

Running the image:
* enable `virtualization.lxc.enable` and `virtualization.lxd.enable`
* 'lxd init' to create the network device and storage pool
* use lxc to start the image (documented further in nixos-generators)

Troubleshooting:
* check `/var/log/lxd/.../lcx.log` to check for output on problems
* check `/var/log/lxd/.../console.log` to check the console output
* use `lxc exec` to run `systemctl status hack42-mastodon-bot.service` to check bot output

TODO:
* move some of the configuration from configuration.nix to default.nix
* move mastodon-bot packaging to upstream nixpkgs
* patch packages.json from .nix instead of pointing to a branch
* edit `configuration.nix` initialize the network ourselves and avoid systemd
