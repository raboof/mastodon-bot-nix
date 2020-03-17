{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [
    ((pkgs.callPackage ./. { }).package.overrideAttrs (old: { 
      buildInputs = old.buildInputs ++ [ pkgs.lumo ];
      postInstall = ''
        patchShebangs $out/bin/mastodon-bot
      '';
    }))
  ];
}

