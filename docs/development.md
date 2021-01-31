# Development

## Golang

This project uses [Golang](https://golang.org) to run a simple webserver.

## Docker

We dockerize the webservice to make it available to services like ECS (Elastic Container Service) and Kubernetes.
Dockerizing an application (or anything really) also helps with build consistency as docker is a silo-ed environment
that should be identical between whatever machine you are running on. Couple of caveats to that, but none you are likely
to ever run in to with general development.

## Basic Setup Information

* [How to manage modules](https://brokencode.io/how-to-use-local-go-modules-with-golang-with-examples/)
* [Creating a webserver](https://blog.logrocket.com/creating-a-web-server-with-golang/)