package controllers

import (
	"cg/models"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
)

func index(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		w.WriteHeader(http.StatusMethodNotAllowed)
		return
	}

	db := models.New()
	buf, err := db.GetLeaderboard()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(os.Stderr, err.Error())
		return
	}

	j, err := json.Marshal(&buf)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(os.Stderr, err.Error())
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Header().Add("content-type", "application/json")
	w.Header().Add("Cache-Control", "max-age=10")
	w.Write(j)
}
