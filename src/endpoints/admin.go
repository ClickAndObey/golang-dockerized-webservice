package endpoints

import (
	"encoding/json"
	"fmt"
	"github.com/clickandobey/golang-dockerized-webservice/src/admin"
	"log"
	"net/http"
)

func SetupAdminEndpoints() {
	http.HandleFunc("/admin/configuration", configurationHandler)
	http.HandleFunc("/admin/status", statusHandler)
}

func configurationHandler(w http.ResponseWriter, r *http.Request) {
	configAsString, err := json.MarshalIndent(admin.GetConfiguration(), "", "    ")
	if err != nil {
		log.Fatal(err)
	}
	_, _ = fmt.Fprintf(w, string(configAsString))
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	statusAsString, err := json.MarshalIndent(admin.GetStatus(), "", "    ")
	if err != nil {
		log.Fatal(err)
	}
	_, _ = fmt.Fprintf(w, string(statusAsString))
}
