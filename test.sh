#!/bin/sh

set -e

lxc delete --force $(lxc ls | grep CONTAINER | cut -d " " -f 2)
lxc image delete $(lxc image list | grep CONTAIN | cut -d "|" -f 3)

# https://github.com/raboof/nixpkgs/tree/mastodon-bot-init-at-0.0.1
export NIX_PATH='nixpkgs=/home/aengelen/nixpkgs-mastodon-bot-init-at-0.0.1'

echo $(nix-build)/tarball/nixos-system-x86_64-linux.tar.xz

lxc image import $(nix-build lxc-metadata.nix)/tarball/nixos-system-x86_64-linux.tar.xz $(nix-build)/tarball/nixos-system-x86_64-linux.tar.xz 

lxc launch $(lxc image list | grep CONTAIN | cut -d "|" -f 3) -s pool1
sudo tail -f /var/log/lxd/$(lxc ls | grep CONTAINER | cut -d " " -f 2)/console.log
