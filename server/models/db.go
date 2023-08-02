package models

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"log"
	"os"
	"strings"
	"sync"
	"time"

	"github.com/jmoiron/sqlx"
	_ "github.com/mattn/go-sqlite3"
)

var (
	ErrNameConflict            = errors.New("username exists")
	mut             sync.Mutex = sync.Mutex{}
	database        string     = "cg.db"
)

var schemas = `
CREATE TABLE IF NOT EXISTS leaderboard (
	id varchar(32) PRIMARY KEY UNIQUE NOT NULL,
	time text NOT NULL,
	name varchar(100) NOT NULL,
	score integer NOT NULL
);
`

// how many records you'd want to display
const TOP = 10

type Models interface {
	GetLeaderboard([]LeaderBoard) error
	NewLeaderboard([]LeaderBoard) error
}

type Database struct {
	*sqlx.DB
}

func (d *Database) GetLeaderboard() ([]LeaderBoard, error) {
	mut.Lock()
	defer mut.Unlock()

	sql := `
	SELECT 
		id,time,name,score
	FROM 
		'leaderboard'
	ORDER BY
		'score' ASC;`

	rows, err := d.Query(sql)
	defer rows.Close()
	if err != nil {
		return nil, err
	}

	leaderboard := make([]LeaderBoard, 0)
	for i := 0; i < TOP; i++ {
		if !rows.Next() {
			break
		}

		l := LeaderBoard{}
		if err := rows.Scan(&l.ID, &l.Time, &l.Name, &l.Score); err != nil {
			return nil, err
		}
		leaderboard = append(leaderboard, l)
	}

	return leaderboard, nil
}

func (d *Database) NewLeaderboard(leaderboard []LeaderBoard) error {
	if len(leaderboard) > TOP {
		leaderboard = leaderboard[:TOP]
	}

	var (
		err error = nil
		trx *sqlx.Tx
	)

	mut.Lock()
	defer mut.Unlock()

	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	trx, err = db.BeginTxx(ctx, &sql.TxOptions{})
	if err != nil {
		return err
	}

	defer func(trx *sqlx.Tx, err error) {
		p, ok := recover().(error)
		if !ok {
			return
		}
		if p != nil || err != nil {
			fmt.Fprintf(os.Stderr, "err [%v]\npanic [%v]\n", err, p)
			trx.Rollback()
		}
	}(trx, err)

	// clear leaderboard
	_, err = trx.Exec(`DELETE FROM 'leaderboard';`)
	if err != nil {
		return err
	}

	// update leaderboard
	stmt := `INSERT INTO 'leaderboard' ('id', 'time', 'name', 'score') VALUES`
	values := make([]string, len(leaderboard))
	data := make([]interface{}, 0, len(leaderboard)*4)

	for i, l := range leaderboard {
		values[i] = "(?, ?, ?, ?)"
		// bind data
		data = append(data, l.ID, l.Time, l.Name, l.Score)
	}
	stmt += " " + strings.Join(values, ",") + ";"

	_, err = trx.Exec(stmt, data...)
	if err != nil {
		return err
	}
	err = trx.Commit()
	if err != nil {
		return trx.Rollback()
	}
	return nil
}

var db *Database

func init() {
	conn, err := sqlx.Open("sqlite3", database)
	if err != nil {
		log.Fatal(err)
	}
	if err := conn.Ping(); err != nil {
		log.Fatal(err)
	}

	db = &Database{conn}
	migration()
}

func New() *Database {
	return db
}

func migration() {
	mut.Lock()
	defer mut.Unlock()
	_, err := db.Exec(schemas)
	if err != nil {
		fmt.Fprintf(os.Stderr, "[ERROR] migration failed: %v", err)
		return
	}
	log.Println("[OK] database migration")
}
