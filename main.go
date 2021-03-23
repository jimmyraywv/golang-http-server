package main

import (
	"log"
	"net/http"
	"os"
)

func main() {
	fs := http.FileServer(http.Dir("html"))
	http.Handle("/", fs)

	log.Println("Listening on port 8080...")

	f, err := os.OpenFile("/tmp/log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("error opening file: %v", err)
	}
	defer f.Close()

	log.SetOutput(f)

	log.Println("Listening on port 8080...")

	log.Println("This is a test log entry")

	http.ListenAndServe(":8080", nil)
}
