{
  nixpkgs ? <nixpkgs>,
  config-edn,
  credentials-edn
}:

let
  pkgs = import nixpkgs {};
  initScript = pkgs.writeScript "init" ''
    #!${pkgs.stdenv.shell}

    ${pkgs.dhcp}/bin/dhclient -v eth0

    export MASTODON_BOT_CONFIG=${config-edn}
    export MASTODON_BOT_CREDENTIALS=${credentials-edn}
    exec ${pkgs.mastodon-bot}/bin/mastodon-bot
  '';
  lib = pkgs.stdenv.lib;
in lib.mkForce (pkgs.callPackage (nixpkgs + "/nixos/lib/make-system-tarball.nix") {
  fileName = "mastodon-bot-${builtins.baseNameOf config-edn}";
  storeContents = [
    {
      object = initScript;
      symlink = "/sbin/init";
    }
  ];
  contents = [
    { source = initScript; target = "/init"; }
  ];
  extraArgs = "--owner=0";
  extraCommands = "mkdir -p proc sys dev etc var/db";
})
