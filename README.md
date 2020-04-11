Resources to package a container running https://github.com/yogthos/mastodon-bot for Nix

Status: works!

The image is 42MB (compressed)

## Usage

You will need the nixpkgs from https://github.com/raboof/nixpkgs/tree/mastodon-bot-init-at-2020-03-22

For further information on how to build and load into LXD, see test.sh

Running the image:
* enable `virtualization.lxc.enable` and `virtualization.lxd.enable`
* 'lxd init' to create the network device and storage pool
* use lxc to start the image (see test.sh)

Troubleshooting:
* check `/var/log/lxd/.../lcx.log` to check for output on problems
* check `/var/log/lxd/.../console.log` to check the console output
