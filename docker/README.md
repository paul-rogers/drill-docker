# Docker Images for Apache Drill

Creates two Docker images for Apache Drill:

* A "drillbit" image to run the Drill server.
* A "sqlline" image to run the Drill client which connects to the drillbit.

Both images are based on a common "drillbase" which provides:

* Alpine linux
* Openjdk (See https://hub.docker.com/_/openjdk)
* Selected Drill release

The images use Drill's default configuration, which you can change as
described below. Processes with the container run as user/group "drill".

### Feedback Please

This is a very early version of Drill Docker support. Please tell us
how it worked for you and how we can improve. Pull Requets welcome,
as a questions and Jira tickets.

### Build Images

You will primarily use pre-built images. To build the images yourself:

```
export DRILL_VERS=1.17.0
./build.sh
```

The build step creates a base image that holds Drill, as well as the
two application images: drillbit and sqlline.

## Zookeeper

Drill uses Apache Zookeeper to coordinate the Drill cluster. Launch one
(ideally three) ZK containers using the
[official ZK image](https://hub.docker.com/_/zookeeper/).

Example:

```
docker run --name my-zookeeper --restart always -d zookeeper
```

Obtain the ZK IP address:

```
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-zookeeper
```

You will need the address in the next steps.

(The ZK documentation suggests using the Docker `--link` option, but the Docker
documentation says that this options is deprecated.)

## Drillbit(s)

You can run one or more Drillbits which automatically (via ZK) form a
Drill cluster. You must tell Drill the host IP(s) of your ZK cluster.

Drill will run "out of the box" using reasonable defaults. We suggest
you try it this way first as a sanity check.

Start Drill with the
[Docker run command](https://docs.docker.com/engine/reference/run/):

```
docker run -d --name my-drillbit1 \
       -p 8047:8047 -p 31010:31010 -p 31011:31011 -p 31012:31012 \
       -e ZK_CONNECT="<zk1,zk2,zk3>" \
       gaucho84/drill:1.17.0-drillbit
```

Replace `<zk1,zk2,zk3>` with your actual ZK host names or IP addresses. 2181 is the
default ZK port.

The above exposes [Drill's ports](https://drill.apache.org/docs/ports-used-by-drill/)
on the host machine. This should be fine as there is no good reason to run
more than one Drillbit per physical host.

Verify that Drill runs by pointing your browser to
`http://<host>:8047`

### JDBC Clients

You can connect JDBC clients to the Drillbit by exporting the Zk ports,
then use the normal
[Drill JDBC connect string](https://drill.apache.org/docs/using-the-jdbc-driver/)
using the ZK hosts and ports.

```
jdbc:drill:zk=<zk1,zk2,zk3>
```

Again, replace `<zk1,zk2,zk3>` with your actual ZK host names or IP addresses.

### Configuration

You can configure Drill in a number of ways. The simplest is to pass
environment variables to the container using the `docker run -e` option.
You can use any variable described in the `drill-env.sh` file.

Alternatively, you can modify the `drill-env.sh` or `drill-override.conf`
files as described in the
[Drill documentation](https://drill.apache.org/docs/configure-drill-introduction/).
You can do this by creating your own custom image with the modifications, or mounting
custom versions from the host file system.

### Logs

Drill writes logs to `/var/log/drill` within the container. You may wish to
use a [host mount](https://docs.docker.com/storage/volumes/) to save the logs on
your host file system.

### Stop Drill

Shut down Drill using the
[Docker stop command](https://docs.docker.com/engine/reference/commandline/stop/):

```
docker stop my_container
```

This command sends a SIGTERM to Drill which intiates graceful shutdown: accept
no new queries, wait for any running queries to complete and exit.

If you have long-running queries, increase Docker's timeout with the `-t` option.
For example: `-t 30` for a 30-second timeout.

### Troubleshooting

Launching a new Docker service can be fiddly; many things can go wrong. Here are
some suggestions to track down problems.

#### Launch the Container as a Shell

Get started by launching the Drillbit container as a `bash` shell so you can
look around and see how things are set up:

```
export ZK_CONNECT=<your-zk>
docker run -it --name my-drillbit1 \
       -p 8047:8047 -p 31010:31010 -p 31011:31011 -p 31012:31012 \
       -e ZK_CONNECT=$ZK_CONNECT \
       --entrypoint /bin/bash \
       gaucho84/drill:1.17.0-drillbit
```

You can simulate a real launch by invoking:

```
$DRILL_HOME/bin/run-drill.sh
```

#### Logs

Drill 1.17 logs to a log file, the container has not yet been adjusted to
log to stdout.

The container image defines a volume mount for the `/var/log/drill` log
directory. To learn the log directory location on your host file system:

```
docker inspect --format='{{range .Mounts}}{{.Source}}{{end}}' my-drillbit1
```

## Sqlline

Drill also provides a Docker image to run SQLLine within a container. This
version uses ZK to locate a running Drillbit instance. Since SQLLine is a command
line application, you must run the container in interactive mode:

```
docker run -it -e ZK_CONNECT="<zk1:zk2:zk3>:2181" sqlline
```
