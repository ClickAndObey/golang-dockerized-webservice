module github.com/clickandobey/golang-dockerized-webservice/src/endpoints

go 1.15

require (
	github.com/clickandobey/golang-dockerized-webservice/src/admin v0.0.0
)

replace (
	github.com/clickandobey/golang-dockerized-webservice/src/admin => ../admin
)