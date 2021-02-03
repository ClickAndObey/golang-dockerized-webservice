module github.com/clickandobey/golang-dockerized-webservice

go 1.15

require (
	github.com/clickandobey/golang-dockerized-webservice/src/admin v0.0.0
	github.com/clickandobey/golang-dockerized-webservice/src/endpoints v0.0.0
	github.com/clickandobey/golang-dockerized-webservice/src/webservice v0.0.0
)

replace (
	github.com/clickandobey/golang-dockerized-webservice/src/admin => ./src/admin
	github.com/clickandobey/golang-dockerized-webservice/src/endpoints => ./src/endpoints
	github.com/clickandobey/golang-dockerized-webservice/src/webservice => ./src/webservice
)
