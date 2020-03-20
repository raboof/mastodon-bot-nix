{ config, pkgs, lib, ... }:

let
  mastodon-bot =
    ((pkgs.callPackage ./. { }).package.overrideAttrs (old: { 
      buildInputs = old.buildInputs ++ [ pkgs.lumo ];
      postInstall = ''
        patchShebangs $out/bin/mastodon-bot
      '';
    }));
in
{
  environment.systemPackages = [
    mastodon-bot
  ];
}

