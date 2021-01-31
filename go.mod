module github.com/clickandobey/golang-dockerized-webservice

go 1.15

require (
   github.com/clickandobey/golang-dockerized-webservice/admin v0.0.0
   github.com/clickandobey/golang-dockerized-webservice/endpoints v0.0.0
   github.com/clickandobey/golang-dockerized-webservice/webservice v0.0.0
)

replace (
   github.com/clickandobey/golang-dockerized-webservice/admin => ./admin
   github.com/clickandobey/golang-dockerized-webservice/endpoints => ./endpoints
   github.com/clickandobey/golang-dockerized-webservice/webservice => ./webservice
)