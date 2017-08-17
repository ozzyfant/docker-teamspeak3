docker-teamspeak3
=================

This docker image provides a TeamSpeak3 server that will automatically download the latest stable version at startup. You can also run/upgrade to any other specific version. See the *Versions* section below for more information.

Usage
-----

To simply use the latest stable version, run

    docker run -d -p 9987:9987/udp -p 10011:10011 -p 30033:30033 -p 41144:41144 --name=ts3-server ozzyfant/teamspeak3-server

where the default server ports will be exposed on your host machine. If you want to serve up multiple TeamSpeak3 servers or just use an alternate port, change the host-side port mapping such as

    docker run -d -p 9988:9987/udp -p 10012:10011 -p 30034:30033 -p 41144:41144 ...

will serve your TeamSpeak3 server on your host's port 9988/udp, 10011/tcp, 30033/tcp and TSDNS on 41144/tcp. The `-p` syntax is `host-port:container-port`.

Speaking of multiple servers, it's handy to give your containers ecplicit names using `--name` as seen above.

If there is no `ts3server.ini` present in the data directory, the server will be startet with `createinifile=1`. Subsequent runs will start with `inifile=/data/ts3server.ini`.

### First Run

If you are starting the server for the first time, you need the Admin-Token:

    docker run -d -p 9987:9987/udp -p 10011:10011 -p 30033:30033 -p 41144:41144 --name=ts3-server ozzyfant/teamspeak3-server
    docker logs -f ts3-server

There are two important sections in the logfiles:

    ------------------------------------------------------------------
                          I M P O R T A N T                           
    ------------------------------------------------------------------
                   Server Query Admin Account created                 
             loginname= "serveradmin", password= "qyF2d07R"
    ------------------------------------------------------------------

and:

    ------------------------------------------------------------------
                          I M P O R T A N T                           
    ------------------------------------------------------------------
          ServerAdmin privilege key created, please use it to gain 
          serveradmin rights for your virtualserver. please
          also check the doc/privilegekey_guide.txt for details.
    
           token=P5fO1Cbbv5DbM5kg9xR3LlfpYjlJe6cT9QeMhjY+
    ------------------------------------------------------------------

**COPY THEM FOR LATER USE!**

### Attaching the data directory to host filesystem

In order to readily access the TeamSpeak3 data, use the `-v` argument to map a directory on your host machine to the container's `/data` directory, such as:

    mkdir -p /path/on/host
    chown 9987:9987 /path/on/host
    docker run -d -v /path/on/host:/data ... --name=ts3-server ...

When attached in this way you can stop the server (`docker stop ts3-server`), edit the configuration under your attached `/path/on/host` and start the server again with `docker start ts3-server` to pick up the new configuration.

**NOTE**: The files in the attached directory will be owned by the host user with UID of 9987. Be sure to create that user (such as `adduser --uid 9987 ...`) if you don't already have one.

Versions
--------

To use a different TeamSpeak3 version, pass the `TS_VERSION` environment variable, which can have the value

* LATEST
* (or a specific version, such as "3.0.10.2")

For example, to use a specific version:

    docker run -d -e TS_VERSION=3.0.10.2 ... --name=ts3-server ...

Note: a list of valid versions is available [here](http://www.server-residenz.com/tools/ts3versions.json) or you may use [ts3version@github](https://github.com/andreasheil/ts3versions) by your self.

