all: hack42 rb mch

.PHONY: hack42 rb mch

hack42:
	nix-build -I nixpkgs=/home/aengelen/nixpkgs-mastodon-bot-init-at-0.0.1 --arg config-edn ./hack42.edn

rb:
	nix-build -I nixpkgs=/home/aengelen/nixpkgs-mastodon-bot-init-at-0.0.1 --arg config-edn ./rb.edn

mch:
	nix-build -I nixpkgs=/home/aengelen/nixpkgs-mastodon-bot-init-at-0.0.1 --arg config-edn ./mch.edn
