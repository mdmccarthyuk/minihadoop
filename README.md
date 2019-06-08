# minihadoop
A hadoop cluster packed into a container for convenience of local testing.  This is a work in progress with an aim of giving a simple local development environment hadoop jobs can be tested against.

## Building and using
To build the image locally run
```
make build
```

To run it
```
make run
```

To build and run
```
make up
```

Initial Dockerfile adapted from the base image here https://github.com/big-data-europe/docker-hadoop

