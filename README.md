# gor-demo
This is a demonstration how to implement a tool to duplicate production traffic (HTTP) into other environments using containers.

## Components
### Server
The server used for this demonstration it's just a web server with a simple 'Hello World' page which runs on port 80.
This demo is independent of the server used. We chose this because it fits for our purpose.

For our demonstration we will be using two containers acting like servers. One responding HTTP queries at port 80(serverA), and the other at port 81(serverB)

### Replaying traffic
We will use [Goreplay](https://goreplay.org/) for replay traffic from a production environment into a testing environment.

Goreplay (GOR) can be executed in different modes. You can either intercept traffic and redirect it or you can record it and replay it later.
In our demo , we will do the first. In our demonstration, GOR will be listening to HTTP request at port 80 (serverA) and will replay them in port 81 (serverB).

## Requirements
- [Docker](https://www.docker.com/)
- [Terraform](https://terraform.io) >= v0.10.6


## Running locally
Move into `docker` subfolder and run `docker-compose -f docker-compose.yml up`
After a few seconds, the two servers and gor container will be up and running. You can now test it by accessing `http://localhost` (web browser or Curl) and you will see how the very same query (inc. headers) will be executed in serverB (http://localhost:81)

NOTE : If you are using MacOS please refer to [Docker for Mac](https://github.com/cakesolutions/gor-demo#docker-for-mac)




## Caveats
### Docker for Mac
There are a few problems with the network driver used by Docker for Mac. So this solution will not work if you are trying to run it in your local environment and you use MacOS.

The only workaround available (at the moment) is spin-up a linux box (vagrant) with docker and execute it in that box.

Here's the issue created in docker's github page about the drama with networking [#68](https://github.com/docker/for-mac/issues/68)
