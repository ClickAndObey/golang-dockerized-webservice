module github.com/clickandobey/golang-dockerized-webservice/endpoints

go 1.15

require (
	github.com/clickandobey/golang-dockerized-webservice/admin v0.0.0
)

replace (
	github.com/clickandobey/golang-dockerized-webservice/admin => ../admin
)