package endpoints

import (
	"fmt"
	"net/http"
)

func SetupHelloEndpoint() {
	http.HandleFunc("/hello", helloHandler)
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/hello" {
		http.Error(w, "404 What are you doing?", http.StatusNotFound)
		return
	}

	if r.Method != "GET" {
		http.Error(w, "Why are you trying to reach this as not a GET?", http.StatusNotFound)
		return
	}

	fmt.Fprintf(w, "Hello!")
}
