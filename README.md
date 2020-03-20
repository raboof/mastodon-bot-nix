Resources to package a container running https://github.com/yogthos/mastodon-bot for NixOS

Status: not working yet.

Built by:
* Check out mastodon-bot
* `node2nix --nodejs-12 ~/dev/mastodon-bot-clean/package.json`
* edit node-packages.nix to point 'src' at github, to a branch that removes lumo-cljs from package.json
* edit configuration.nix to add the lumo dependency and update the scripts' shebang

Generate your image by:
* ../nixos-generator/nixos-generate -f lxc -c configuration.nix; ./nixos-generate -f lxc-metadata -c /tmp/mst/configuration.nix

Running the image:
* enable `virtualization.lxc.enable` and `virtualization.lxd.enable`
* use lxc to start the image as documented in nixos-generators
* use 'lxc exec' to run '/nix/store/...-system-path/bin/mastodon-bot'
* check `/var/log/lxd/.../lcx.log` to check for output

TODO:
* Add wrapper that allows mastodon-bot to find its `node_modules`
* Edit `configuration.nix` to run the bot with some configuration on image startup
* move some of the configuration from configuration.nix to default.nix
* move mastodon-bot packaging to upstream nixpkgs
* patch packages.json from .nix instead of pointing to a branch
