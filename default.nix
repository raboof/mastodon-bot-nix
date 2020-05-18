{ nixpkgs ? <nixpkgs> }:
let
  pkgs = import nixpkgs {}; 
  mastodon-bot-compiled = pkgs.stdenv.mkDerivation {
    name = "mastodon-bot-compiled";
    unpackPhase = "true";
    buildInputs = [ pkgs.lumo ];
    buildPhase = ''
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

      # Clean up leftovers from compile phase
      find out -name '*.cljs' | xargs rm
      find out -name '*.json' | xargs rm
      find out -name '*.map' | xargs rm

      # Cut ties with the specific version of nodejs
      rm -r node_modules/acorn/bin
      rm -r node_modules/*/scripts
      rm -r node_modules/*/node_modules/*/bin
      grep -r ${pkgs.nodejs} node_modules/ | cut -d ":" -f 1 | sort | uniq | xargs rm
    '';
    installPhase = ''
      mkdir -p $out/lib
      cp -r out $out/lib

      # We're copying the node_modules so that we don't need a dependency on the 'fat' mastodon-bot
      cp -r node_modules $out/lib

      mkdir -p $out/bin
      cat > $out/bin/mastodon-bot <<EOF;
      #!/bin/sh
      cd $out/lib
      NODE_PATH=$out/lib/node_modules ${pkgs.nodejs-slim-12_x}/bin/node out/mastodon-bot.js "\$@"
EOF

      chmod a+x $out/bin/mastodon-bot
    '';
  };
  initScript = pkgs.writeScript "init" ''
    #!${pkgs.stdenv.shell}

    ${pkgs.dhcp}/bin/dhclient -v eth0

    export MASTODON_BOT_CONFIG=${./config.hack42.edn}
    exec ${mastodon-bot-compiled}/bin/mastodon-bot
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
  extraCommands = "mkdir -p proc sys dev etc var/db";
})
