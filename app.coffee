dbus             = require 'dbus-native'
{ EventEmitter } = require 'events'

#
# https://www.freedesktop.org/wiki/Software/systemd/dbus/
#

unitEvents = [ "UnitNew", "UnitRemoved", "JobNew", "JobRemoved", "StartupFinished" ]

class SystemdManager extends EventEmitter
	constructor: ({ dbusSocketAddress })->
		super()
		@serviceName = "org.freedesktop.systemd1"
		@objectPath  = "/org/freedesktop/systemd1"
		bus = dbus.systemBus busAddress: "unix:path=#{dbusSocketAddress}"
		throw new Error 'Could not connect to the DBus system bus.' unless bus

		@service = bus.getService @serviceName

	init: (cb) ->
		@service.getInterface @objectPath, "#{@serviceName}.Manager", (error, @manager) =>
			throw error if error
			unitEvents.forEach (event) =>
				@manager.on event, (things...) =>
					[ pid, path, serviceName, state ] = things
					@emit "unitEvent", { event, pid, path, serviceName, state }
			cb()

	destroy: ->
		unitEvents.forEach (event) => @manager.removeAllListeners event

module.exports = SystemdManager

