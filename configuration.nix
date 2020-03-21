{ config, pkgs, lib, ... }:

let
  mastodon-bot =
    ((pkgs.callPackage ./. { }).package.overrideAttrs (old: { 
      buildInputs = old.buildInputs ++ [ pkgs.lumo ];
      postInstall = ''
        patchShebangs $out/bin/mastodon-bot
      '';
    }));
  mastodon-bot-hack42 = pkgs.symlinkJoin {
    name = "mastodon-bot-hack42";
    paths = [ mastodon-bot ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = "wrapProgram $out/bin/mastodon-bot --set MASTODON_BOT_CONFIG ${./config.hack42.edn}";
  };
in
{
  environment.systemPackages = [
    mastodon-bot
  ];

  # This is too early: no network yet...
  # would be nice to set up the network 'manually' and drop systemd, but one step at a time
  # boot.postBootCommands = ''MASTODON_BOT_CONFIG=${./config.hack42.edn} ${mastodon-bot}/bin/mastodon-bot'';
  systemd.services."hack42-mastodon-bot" = {
    wantedBy = [ "multi-user.target" ];
    description = "mastodon-bot with the hack42 configuration";
    after = [ "network-online.target" ];
    unitConfig = {
      DefaultDependencies = false;
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
      ExecStart = "${mastodon-bot-hack42}/bin/mastodon-bot";
    };
  };
  #systemd.defaultUnit = "network-online.target";
}

