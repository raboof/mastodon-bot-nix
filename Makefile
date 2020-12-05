all: hack42 rb mch codefornl

.PHONY: hack42 rb mch codefornl deploy

deploy:
	# Manually:
	# export TICKET=`curl -k -d "username=$USER@pam&password=$PASS"  https://127.0.0.1:8006/api2/json/access/ticket | jq --raw-output .data.ticket`
	# export TOKEN=`curl -k -d "username=$USER@pam&password=$PASS"  https://127.0.0.1:8006/api2/json/access/ticket | jq --raw-output .data.CSRFPreventionToken`
	$(eval TICKET=$(shell curl -k -d "username=$(USER)@pam&password=$(PASS)"  https://127.0.0.1:8006/api2/json/access/ticket | jq --raw-output .data.ticket))
	$(eval TOKEN=$(shell curl -k -d "username=$(USER)@pam&password=$(PASS)"  https://127.0.0.1:8006/api2/json/access/ticket | jq --raw-output .data.CSRFPreventionToken))
	$(eval HACK42IMG=$(shell nix-build --arg config-edn ./hack42.edn --arg credentials-edn ./hack42-credentials.edn))
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' https://localhost:8006/api2/json/nodes/curie/storage/local/upload?content=vztmpl -F 'filename=@$(HACK42IMG)/tarball/mastodon-bot-hack42.edn.tar.xz' --trace-ascii out.txt
	$(eval MCHIMG=$(shell nix-build --arg config-edn ./mch.edn --arg credentials-edn ./mch-credentials.edn))
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' https://localhost:8006/api2/json/nodes/curie/storage/local/upload?content=vztmpl -F 'filename=@$(MCHIMG)/tarball/mastodon-bot-mch.edn.tar.xz' --trace-ascii out.txt
	$(eval RBIMG=$(shell nix-build --arg config-edn ./rb.edn --arg credentials-edn ./rb-credentials.edn))
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' https://localhost:8006/api2/json/nodes/curie/storage/local/upload?content=vztmpl -F 'filename=@$(RBIMG)/tarball/mastodon-bot-rb.edn.tar.xz' --trace-ascii out.txt
	$(eval NLIMG=$(shell nix-build --arg config-edn ./codefornl.edn --arg credentials-edn ./codefornl-credentials.edn))
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' https://localhost:8006/api2/json/nodes/curie/storage/local/upload?content=vztmpl -F 'filename=@$(NLIMG)/tarball/mastodon-bot-codefornl.edn.tar.xz' --trace-ascii out.txt
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' -X POST --data-urlencode ostemplate="local:vztmpl/mastodon-bot-hack42.edn.tar.xz" --data rootfs=vmdata:1 --data restore=1 --data hostname=mastodon-bot-hack42 --data-urlencode net0="bridge=vmbr0,name=eth0,firewall=1" --data force=1 --data vmid=104 https://localhost:8006/api2/json/nodes/curie/lxc
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' -X POST --data-urlencode ostemplate="local:vztmpl/mastodon-bot-mch.edn.tar.xz" --data rootfs=vmdata:1 --data restore=1 --data hostname=mastodon-bot-mch --data-urlencode net0="bridge=vmbr0,name=eth0,firewall=1" --data force=1 --data vmid=105 https://localhost:8006/api2/json/nodes/curie/lxc
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' -X POST --data-urlencode ostemplate="local:vztmpl/mastodon-bot-rb.edn.tar.xz" --data rootfs=vmdata:1 --data restore=1 --data hostname=mastodon-bot-rb --data-urlencode net0="bridge=vmbr0,name=eth0,firewall=1" --data force=1 --data vmid=106 https://localhost:8006/api2/json/nodes/curie/lxc
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' -X POST --data-urlencode ostemplate="local:vztmpl/mastodon-bot-codefornl.edn.tar.xz" --data rootfs=vmdata:1 --data restore=1 --data hostname=mastodon-bot-codefornl --data-urlencode net0="bridge=vmbr0,name=eth0,firewall=1" --data force=1 --data vmid=110 https://localhost:8006/api2/json/nodes/curie/lxc

run:
	$(eval TICKET=$(shell curl -k -d "username=$(USER)@pam&password=$(PASS)"  https://127.0.0.1:8006/api2/json/access/ticket | jq --raw-output .data.ticket))
	$(eval TOKEN=$(shell curl -k -d "username=$(USER)@pam&password=$(PASS)"  https://127.0.0.1:8006/api2/json/access/ticket | jq --raw-output .data.CSRFPreventionToken))
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' -X POST https://localhost:8006/api2/json/nodes/curie/lxc/104/status/start
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' -X POST https://localhost:8006/api2/json/nodes/curie/lxc/105/status/start
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' -X POST https://localhost:8006/api2/json/nodes/curie/lxc/106/status/start
	curl -k -b 'PVEAuthCookie=$(TICKET)' -H 'CSRFPreventionToken: $(TOKEN)' -X POST https://localhost:8006/api2/json/nodes/curie/lxc/110/status/start

hack42:
	nix-build --arg config-edn ./hack42.edn --arg credentials-edn ./hack42-credentials.edn

rb:
	nix-build --arg config-edn ./rb.edn --arg credentials-edn ./rb-credentials.edn

mch:
	nix-build --arg config-edn ./mch.edn --arg credentials-edn ./mch-credentials.edn

codefornl:
	nix-build --arg config-edn ./codefornl.edn --arg credentials-edn ./codefornl-credentials.edn
