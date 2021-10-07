#!/bin/sh

set -e

ACCOUNT=hack42

lxc delete --force $(lxc ls | grep CONTAINER | cut -d " " -f 2)
lxc image delete $(lxc image list | grep CONTAIN | cut -d "|" -f 3)

echo $(nix-build --arg config-edn ./$ACCOUNT.edn --arg credentials-edn ./$ACCOUNT-credentials.edn)/tarball/nixos-system-x86_64-linux.tar.xz

lxc image import $(nix-build lxc-metadata.nix)/tarball/nixos-system-x86_64-linux.tar.xz $(nix-build --arg config-edn ./$ACCOUNT.edn --arg credentials-edn ./$ACCOUNT-credentials.edn)/tarball/mastodon-bot-$ACCOUNT.edn.tar.xz

lxc launch $(lxc image list | grep CONTAIN | cut -d "|" -f 3) -s pool1
sudo tail -f /var/log/lxd/$(lxc ls | grep CONTAINER | cut -d " " -f 2)/console.log
