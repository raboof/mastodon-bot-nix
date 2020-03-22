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
  systemd.targets."posted" = {};

  systemd.services."hack42-mastodon-bot" = {
    description = "mastodon-bot with the hack42 configuration";

    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];

    requiredBy = [ "posted.target" ];

    unitConfig = {
      DefaultDependencies = false;
    };

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
      # To give DNS time to actually initialize :/
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${mastodon-bot-hack42}/bin/mastodon-bot";
      # And wind down after running
      ExecStop = "${pkgs.systemd}/bin/shutdown -h";
    };
  };

  systemd.defaultUnit = "posted.target";
}
