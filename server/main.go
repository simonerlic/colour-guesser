package main

import (
	"cg/controllers"
	"fmt"
	"log"
	"net/http"
	"os"

	_ "cg/models"
)

var port string

func init() {
	port = os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

}

func main() {
	r := controllers.New()

	fmt.Println(`
  ___       _                         ___                              
 / __| ___ | | ___  _  _  _ _        / __| _  _  ___  ___ ___ ___  _ _ 
| (__ / _ \| |/ _ \| || || '_|      | (_ || || |/ -_)(_-/(_-// -_)| '_|
 \___|\___/|_|\___/ \_._||_|         \___| \_._|\___|/__//__/\___||_|  
	`)

	log.Printf("Listening on port %s", port)
	if err := http.ListenAndServe(":"+port, r); err != nil {
		log.Fatal(err)
	}
}
