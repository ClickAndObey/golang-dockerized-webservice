module github.com/clickandobey/golang-dockerized-webservice/webservice

go 1.15

require (
	github.com/clickandobey/golang-dockerized-webservice/endpoints v0.0.0
)

replace (
	github.com/clickandobey/golang-dockerized-webservice/endpoints => ../endpoints
)