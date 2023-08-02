package controllers

import (
	"cg/models"
	"encoding/json"
	"net/http"
)

func newScore(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		w.WriteHeader(http.StatusMethodNotAllowed)
		return
	}

	defer r.Body.Close()
	var b models.LeaderBoard
	if err := json.NewDecoder(r.Body).Decode(&b); err != nil {
		serverError(w, err)
		return
	}

	if b.Name == "" || b.Score == 0 {
		w.WriteHeader(http.StatusBadRequest)
		w.Header().Add("content-type", "application/text")
		w.Write([]byte("invalid request body"))
		return
	}

	if err := b.Serialize(); err != nil {
		serverError(w, err)
		return
	}
	b.SurfixName()

	db := models.New()
	board, err := db.GetLeaderboard()
	if err != nil {
		serverError(w, err)
		return
	}

	board = insertBoard(board, b)
	err = db.NewLeaderboard(board)
	switch err {
	case nil:
		break

	case models.ErrNameConflict:
		w.WriteHeader(http.StatusConflict)
		w.Header().Add("content-typ", "application/text")
		w.Write([]byte(err.Error()))
		return

	default:
		serverError(w, err)
		return
	}

	j, err := json.Marshal(board)
	if err != nil {
		serverError(w, err)
		return
	}

	w.WriteHeader(http.StatusCreated)
	w.Header().Add("content-type", "application/json")
	w.Write(j)
}

func insertBoard(board []models.LeaderBoard, b models.LeaderBoard) []models.LeaderBoard {
	if len(board) == 0 {
		board = append(board, b)
		return board
	}

	left := 0
	right := len(board) - 1
	mid := (left + right) / 2
	boardMid := board[mid]
	for left < right {
		if boardMid.Score > b.Score {
			left = mid
		} else {
			right = mid
		}
		mid = (left + right) / 2
		boardMid = board[mid]
	}

	boardL := board[:mid]
	boardMid = board[mid]
	boardR := board[mid+1:]
	boardTmp := [2]models.LeaderBoard{b, boardMid}

	if boardMid.Score == b.Score || boardMid.Score > b.Score {
		boardTmp = [2]models.LeaderBoard{boardMid, b}
	}

	board = append(boardL, boardTmp[:]...)
	board = append(board, boardR...)
	if len(board) > models.TOP {
		board = board[:models.TOP]
	}
	return board
}
