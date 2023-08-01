package controllers

import (
	"fmt"
	"net/http"
	"os"
)

var r *http.ServeMux

func New() *http.ServeMux {
	return r
}

func init() {
	r = http.NewServeMux()
	r.Handle("/leaderboard", http.HandlerFunc(index))
	r.Handle("/leaderboard/new", http.HandlerFunc(newScore))
}

func serverError(w http.ResponseWriter, err error) {
	w.WriteHeader(http.StatusInternalServerError)
	fmt.Fprintf(os.Stderr, "%v\n", err)
}
