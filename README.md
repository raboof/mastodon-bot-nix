Resources to package a container running https://github.com/yogthos/mastodon-bot for Nix

Status: master works, but is a bit heavyweight, with systemd and everything.

This branch does not work yet: lxc cannot find /sbin/init:

```
lxc stunning-shrew 20200411110938.535 WARN     initutils - initutils.c:setproctitle:314 - Invalid argument - Failed to set cmdline
lxc stunning-shrew 20200411110938.685 ERROR    cgfsng - cgroups/cgfsng.c:mkdir_eexist_on_last:1136 - File exists - Failed to create directory "/sys/fs/cgroup/cpuset//lxc.monitor.stunning-shrew"
lxc stunning-shrew 20200411110938.686 ERROR    cgfsng - cgroups/cgfsng.c:mkdir_eexist_on_last:1136 - File exists - Failed to create directory "/sys/fs/cgroup/cpuset//lxc.payload.stunning-shrew"
lxc stunning-shrew 20200411110938.687 WARN     cgfsng - cgroups/cgfsng.c:fchowmodat:1445 - No such file or directory - Failed to fchownat(17, memory.oom.group, 65536, 0, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW )
lxc stunning-shrew 20200411110938.710 ERROR    start - start.c:start:2039 - No such file or directory - Failed to exec "/sbin/init"
lxc stunning-shrew 20200411110938.710 ERROR    sync - sync.c:__sync_wait:40 - An error occurred in another process (expected sequence number 7)
lxc stunning-shrew 20200411110938.711 WARN     network - network.c:lxc_delete_network_priv:3211 - Failed to rename interface with index 0 from "eth0" to its initial name "vethaabae2d0"
lxc stunning-shrew 20200411110938.711 ERROR    lxccontainer - lxccontainer.c:wait_on_daemonized_start:851 - Received container state "ABORTING" instead of "RUNNING"
lxc stunning-shrew 20200411110938.711 ERROR    start - start.c:__lxc_start:1947 - Failed to spawn container "stunning-shrew"
lxc stunning-shrew 20200411110938.711 WARN     start - start.c:lxc_abort:1024 - No such process - Failed to send SIGKILL via pidfd 30 for process 17155
lxc stunning-shrew 20200411110938.801 WARN     cgfsng - cgroups/cgfsng.c:cgfsng_monitor_destroy:1103 - No space left on device - Failed to move monitor 17131 to "/sys/fs/cgroup/cpuset//lxc.pivot"
lxc 20200411110938.802 WARN     commands - commands.c:lxc_cmd_rsp_recv:120 - Connection reset by peer - Failed to receive response for command "get_state"
```

## Usage

You will need the nixpkgs from https://github.com/raboof/nixpkgs/tree/mastodon-bot-init-at-2020-03-22

See test.sh

Running the image:
* enable `virtualization.lxc.enable` and `virtualization.lxd.enable`
* 'lxd init' to create the network device and storage pool
* use lxc to start the image (documented further in nixos-generators)

Troubleshooting:
* check `/var/log/lxd/.../lcx.log` to check for output on problems
* check `/var/log/lxd/.../console.log` to check the console output
* use `lxc exec` to run `systemctl status hack42-mastodon-bot.service` to check bot output
