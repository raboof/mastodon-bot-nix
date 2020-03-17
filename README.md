Resources to package a container running https://github.com/yogthos/mastodon-bot for NixOS

Status: not working yet.

Built by:
* Check out mastodon-bot
* edit package.json not to add lumo-cljs as a dependency
* edit package.json to add a `"bin": { "mastodon-bot": "mastodon_bot/main.cljs" }` section
* `node2nix --nodejs-12 ~/dev/mastodon-bot-clean/package.json`
* edit configuration.nix to add the lumo dependency and update the scripts' shebang

Generate your image by:
* Check out mastodon-bot
* Edit node-packages.nix to point 'src' to mastodon-bot
* ./nixos-generate -f lxc -c /tmp/mst/configuration.nix; ./nixos-generate -f lxc-metadata -c /tmp/mst/configuration.nix

Running the image:
* enable `virtualization.lxc.enable` and `virtualization.lxd.enable`
* (lxd fails to start for me, have to look into that)
* (untested) use lxc to start the image as documented in nixos-generators

TODO:
* make nix fetch mastodon-bot from github and patch
* Add wrapper that allows mastodon-bot to find its dependencies
  (or copy those dependencies to 'bin' as well if needed)
* Edit `configuration.nix` to run the bot with some configuration on image startup
* propose some of the changes to mastodon-bot upstream
* move some of the configuration from configration.nix to default.nix
* move mastodon-bot packaging to upstream nixpkgs?
