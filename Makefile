all: hack42 rb mch

.PHONY: hack42 rb mch deploy

deploy:
	$(eval TICKET=$(shell curl -k -d "username=$(USER)@pam&password=$(PASS)"  https://127.0.0.1:8006/api2/json/access/ticket | jq --raw-output .data.ticket))
	$(eval TOKEN=$(shell curl -k -d "username=$(USER)@pam&password=$(PASS)"  https://127.0.0.1:8006/api2/json/access/ticket | jq --raw-output .data.CSRFPreventionToken))
	$(eval HACK42IMG=$(shell nix-build -I nixpkgs=/home/aengelen/nixpkgs-unstable --arg config-edn ./hack42.edn))
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' https://localhost:8006/api2/json/nodes/curie/storage/local/upload?content=vztmpl -F 'filename=@$(HACK42IMG)/tarball/mastodon-bot-hack42.edn.tar.xz' --trace-ascii out.txt
	$(eval MCHIMG=$(shell nix-build -I nixpkgs=/home/aengelen/nixpkgs-unstable --arg config-edn ./mch.edn))
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' https://localhost:8006/api2/json/nodes/curie/storage/local/upload?content=vztmpl -F 'filename=@$(MCHIMG)/tarball/mastodon-bot-mch.edn.tar.xz' --trace-ascii out.txt
	$(eval RBIMG=$(shell nix-build -I nixpkgs=/home/aengelen/nixpkgs-unstable --arg config-edn ./rb.edn))
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' https://localhost:8006/api2/json/nodes/curie/storage/local/upload?content=vztmpl -F 'filename=@$(RBIMG)/tarball/mastodon-bot-rb.edn.tar.xz' --trace-ascii out.txt

hack42:
	nix-build -I nixpkgs=/home/aengelen/nixpkgs-unstable --arg config-edn ./hack42.edn

rb:
	nix-build -I nixpkgs=/home/aengelen/nixpkgs-unstable --arg config-edn ./rb.edn

mch:
	nix-build -I nixpkgs=/home/aengelen/nixpkgs-unstable --arg config-edn ./mch.edn
