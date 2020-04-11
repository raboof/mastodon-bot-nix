{ config ? <config>, nixpkgs ? <nixpkgs> }:

let
  pkgs = import nixpkgs {}; 
  tb = pkgs.callPackage (nixpkgs + "/nixos/lib/make-system-tarball.nix") {
    contents = [{
      source = pkgs.writeText "metadata.yaml" ''
        architecture: x86_64
        creation_date: 1424284563
        properties:
          description: NixOS
          os: Nix
          release: snapshot
      '';
      target = "/metadata.yaml";
    }];
  };
in tb
