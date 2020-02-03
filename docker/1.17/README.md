# Drill 1.17 Docker Image

Provides support for running Drill 1.17 under Docker. The scripts will
likely work with prior versions as well.

The goal here is to use Drill scripts as they are in Drill 1.17.
Some aspects of Drill are a bit awkward when used in a container.
These issues may be addressed in Drill 1.18, and the Docker scripts
will change to match.

## Building the Images

There are three directories, each with a build.sh script. Build them
in order:

* `base` - Image with slightly-docktored Drill distribution.
* `drillbit` - Drill server image.
* `sqlline` - Client image meant to be run interactively.

For each, build the image using the script provided:

```
sudo build 1.17.0
```

`sudo` is needed of you are not a member of the Docker group.
`1.17.0` is Drill version to use.

The result are images of the form:

```
gaucho84/drill:1.17.0-<image>
```

The `gaucho84` is a temporary DockerHub account; we will use the
Drill account once the code becomes part of Drill itself.
