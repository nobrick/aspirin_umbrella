# AspirinUmbrella

## Installation
The PingMonitor module requires root privileges for :procket to execute socket manipulation.

One solution is to set Linux capabilities for beam:

```
setcap cap_net_raw=ep /usr/lib/erlang/erts-8.0/bin/beam.smp
```

See https://github.com/msantos/procket#setuid-vs-sudo-vs-capabilities

