{
  nixpkgs ? <nixpkgs>,
  config-edn,
  credentials-edn
}:

let
  pkgs = import nixpkgs {};
  mastodon-bot-slim = pkgs.runCommand "mastodon-bot-slim" {} ''
    cp -r ${pkgs.mastodon-bot} $out
    #find $out -type f -print0 | while IFS= read -r -d $'\0' f; do substituteInPlace $f --replace "${pkgs.nodejs}" "${pkgs.nodejs-slim}"; done
  '';
  initScript = pkgs.writeScript "init" ''
    #!${pkgs.stdenv.shell}

    ${pkgs.dhcp}/bin/dhclient -v eth0

    export MASTODON_BOT_CONFIG=${config-edn}
    export MASTODON_BOT_CREDENTIALS=${credentials-edn}
    exec ${mastodon-bot-slim}/bin/mastodon-bot
  '';
  lib = pkgs.lib;
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
