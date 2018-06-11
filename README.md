# Systemd Manager

### About
Uses dbus-native to connect to the systemd.manager  

### Usage
```coffeescript

SystemdManager = require "systemd-manager"

systemd = new SystemdManager dbusSocket: "/var/run/dbus/system_bus_socket"

unitEvents = [ "UnitNew", "UnitRemoved", "JobNew", "JobRemoved", "StartupFinished" ]

# Systemd is an event emitter
unitEvent.forEach (event) ->
  systemd.on event, console.log

# Init systemd
systemd.init (error, manager) ->
  throw error if error
  manager.RestartUnit "NetworkManager.service", "replace", (error, info) ->
    throw error if error
    console.log('info', info)

```
