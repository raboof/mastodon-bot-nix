#!/bin/sh

set -e

lxc delete --force $(lxc ls | grep CONTAINER | cut -d " " -f 2)
lxc image delete $(lxc image list | grep CONTAIN | cut -d "|" -f 3)

# https://github.com/raboof/nixpkgs/tree/mastodon-bot-init-at-2020-03-22
export NIX_PATH='nixpkgs=/home/aengelen/nixpkgs-mastodon-bot'

../nixos-generators/nixos-generate -f lxc -c configuration.nix
lxc image import $(../nixos-generators/nixos-generate -f lxc-metadata -c configuration.nix -I nixpkgs=/home/aengelen/nixpkgs-mastodon-bot) $(../nixos-generators/nixos-generate -f lxc -c configuration.nix -I nixpkgs=/home/aengelen/nixpkgs-mastodon-bot)

lxc launch $(lxc image list | grep CONTAIN | cut -d "|" -f 3) -s pool1
sudo tail -f /var/log/lxd/$(lxc ls | grep CONTAINER | cut -d " " -f 2)/console.log
