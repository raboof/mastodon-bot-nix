{ nixpkgs ? <nixpkgs> }:
let
  pkgs = import nixpkgs {}; 
  mastodon-bot-compiled = pkgs.stdenv.mkDerivation {
    name = "mastodon-bot-compiled";
    unpackPhase = "true";
    buildInputs = [ pkgs.lumo ];
    buildPhase = ''
      # where should the output go? I guess we can't write?
      cp -r ${pkgs.mastodon-bot}/lib/node_modules/mastodon-bot/* .
      chmod -R a+w *
      cat > build.cljs <<EOF;
      (require '[lumo.build.api :as b])

(b/build "mastodon_bot"
  {:main 'mastodon-bot.core
   :output-to "out/mastodon-bot.js"
   :target :nodejs
   })

EOF

      lumo -c mastodon_bot build.cljs
      rm out/mastodon_bot/*.cljs
    '';
    installPhase = ''
      mkdir -p $out/lib
      cp -r out $out/lib

      # We're copying the node_modules so we don't need a dependency on the 'fat' mastodon-bot
      cp -r node_modules $out/lib

      mkdir -p $out/bin
      cat > $out/bin/mastodon-bot <<EOF;
      #!/bin/sh
      cd $out/lib
      NODE_PATH=$out/lib/node_modules ${pkgs.nodejs}/bin/node out/mastodon-bot.js &>/tmp/logs
EOF

      chmod a+x $out/bin/mastodon-bot
    '';
  };
  mastodon-bot-hack42 = pkgs.symlinkJoin {
    name = "mastodon-bot-hack42";
    paths = [ mastodon-bot-compiled ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = "wrapProgram $out/bin/mastodon-bot --set MASTODON_BOT_CONFIG ${./config.hack42.edn}";
  };
  initScript = pkgs.writeScript "init" ''
    #!/bin/sh
    ${pkgs.dhcp}/bin/dhclient -v eth0
    exec ${mastodon-bot-hack42}/bin/mastodon-bot
  '';
  lib = pkgs.stdenv.lib;
in lib.mkForce (pkgs.callPackage (nixpkgs + "/nixos/lib/make-system-tarball.nix") {
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
  extraCommands = "mkdir -p proc sys dev";
})
