Sample init scripts and service configuration for danecoind
==========================================================

Sample scripts and configuration files for systemd, Upstart and OpenRC
can be found in the contrib/init folder.

    contrib/init/danecoind.service:    systemd service unit configuration
    contrib/init/danecoind.openrc:     OpenRC compatible SysV style init script
    contrib/init/danecoind.openrcconf: OpenRC conf.d file
    contrib/init/danecoind.conf:       Upstart service configuration file
    contrib/init/danecoind.init:       CentOS compatible SysV style init script

Service User
---------------------------------

All three Linux startup configurations assume the existence of a "danecoin" user
and group.  They must be created before attempting to use these scripts.
The macOS configuration assumes danecoind will be set up for the current user.

Configuration
---------------------------------

At a bare minimum, danecoind requires that the rpcpassword setting be set
when running as a daemon.  If the configuration file does not exist or this
setting is not set, danecoind will shutdown promptly after startup.

This password does not have to be remembered or typed as it is mostly used
as a fixed token that danecoind and client programs read from the configuration
file, however it is recommended that a strong and secure password be used
as this password is security critical to securing the wallet should the
wallet be enabled.

If danecoind is run with the "-server" flag (set by default), and no rpcpassword is set,
it will use a special cookie file for authentication. The cookie is generated with random
content when the daemon starts, and deleted when it exits. Read access to this file
controls who can access it through RPC.

By default the cookie is stored in the data directory, but it's location can be overridden
with the option '-rpccookiefile'.

This allows for running danecoind without having to do any manual configuration.

`conf`, `pid`, and `wallet` accept relative paths which are interpreted as
relative to the data directory. `wallet` *only* supports relative paths.

For an example configuration file that describes the configuration settings,
see `share/examples/danecoin.conf`.

Paths
---------------------------------

### Linux

All three configurations assume several paths that might need to be adjusted.

Binary:              `/usr/bin/danecoind`  
Configuration file:  `/etc/danecoin/danecoin.conf`  
Data directory:      `/var/lib/danecoind`  
PID file:            `/var/run/danecoind/danecoind.pid` (OpenRC and Upstart) or `/var/lib/danecoind/danecoind.pid` (systemd)  
Lock file:           `/var/lock/subsys/danecoind` (CentOS)  

The configuration file, PID directory (if applicable) and data directory
should all be owned by the danecoin user and group.  It is advised for security
reasons to make the configuration file and data directory only readable by the
danecoin user and group.  Access to danecoin-cli and other danecoind rpc clients
can then be controlled by group membership.

### macOS

Binary:              `/usr/local/bin/danecoind`  
Configuration file:  `~/Library/Application Support/Danecoin/danecoin.conf`  
Data directory:      `~/Library/Application Support/Danecoin`  
Lock file:           `~/Library/Application Support/Danecoin/.lock`  

Installing Service Configuration
-----------------------------------

### systemd

Installing this .service file consists of just copying it to
/usr/lib/systemd/system directory, followed by the command
`systemctl daemon-reload` in order to update running systemd configuration.

To test, run `systemctl start danecoind` and to enable for system startup run
`systemctl enable danecoind`

NOTE: When installing for systemd in Debian/Ubuntu the .service file needs to be copied to the /lib/systemd/system directory instead.

### OpenRC

Rename danecoind.openrc to danecoind and drop it in /etc/init.d.  Double
check ownership and permissions and make it executable.  Test it with
`/etc/init.d/danecoind start` and configure it to run on startup with
`rc-update add danecoind`

### Upstart (for Debian/Ubuntu based distributions)

Upstart is the default init system for Debian/Ubuntu versions older than 15.04. If you are using version 15.04 or newer and haven't manually configured upstart you should follow the systemd instructions instead.

Drop danecoind.conf in /etc/init.  Test by running `service danecoind start`
it will automatically start on reboot.

NOTE: This script is incompatible with CentOS 5 and Amazon Linux 2014 as they
use old versions of Upstart and do not supply the start-stop-daemon utility.

### CentOS

Copy danecoind.init to /etc/init.d/danecoind. Test by running `service danecoind start`.

Using this script, you can adjust the path and flags to the danecoind program by
setting the DANECOIND and FLAGS environment variables in the file
/etc/sysconfig/danecoind. You can also use the DAEMONOPTS environment variable here.

### macOS

Copy org.danecoin.danecoind.plist into ~/Library/LaunchAgents. Load the launch agent by
running `launchctl load ~/Library/LaunchAgents/org.danecoin.danecoind.plist`.

This Launch Agent will cause danecoind to start whenever the user logs in.

NOTE: This approach is intended for those wanting to run danecoind as the current user.
You will need to modify org.danecoin.danecoind.plist if you intend to use it as a
Launch Daemon with a dedicated danecoin user.

Auto-respawn
-----------------------------------

Auto respawning is currently only configured for Upstart and systemd.
Reasonable defaults have been chosen but YMMV.
