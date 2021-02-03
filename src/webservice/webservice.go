package webservice

import (
	"fmt"
	"log"
	"net/http"

	"github.com/clickandobey/golang-dockerized-webservice/src/endpoints"
)

const (
	port = ":9001"
)

func Run() {
	endpoints.SetupAdminEndpoints()
	endpoints.SetupHelloEndpoint()

	fmt.Println("Running webservice...")
	if err := http.ListenAndServe(port, nil); err != nil {
		log.Fatal(err)
	}
}
