package models

import (
	"crypto/rand"
	"encoding/binary"
	"encoding/hex"
	"io"
	m "math/rand"
	"sync"
	"time"
)

var (
	idCounter uint16     = 0
	idMut     sync.Mutex = sync.Mutex{}
)

type LeaderBoard struct {
	ID    string `json:"id,omitempty"`
	Time  string `json:"time,omitempty"`
	Name  string `json:"name,omitempty"`
	Score uint8  `json:"score,omitempty"`
}

func RefreshCounter() {
	for {
		idMut.Lock()
		idCounter = 0
		idMut.Unlock()
		time.Sleep(time.Second)
	}

}

func (l *LeaderBoard) Serialize() error {
	var id [16]byte

	t := time.Now().UTC()
	binary.LittleEndian.PutUint32(id[:4], uint32(t.Unix()))
	binary.LittleEndian.PutUint16(id[4:6], uint16(l.Score))

	idMut.Lock()
	idCounter = idCounter + 1
	binary.LittleEndian.PutUint16(id[6:8], idCounter)
	idMut.Unlock()

	if _, err := io.ReadFull(rand.Reader, id[8:]); err != nil {
		return err
	}

	l.Time = time.Now().UTC().Format("Jan 01 2006 03:04:05 PM -07:00")
	l.ID = hex.EncodeToString(id[:])

	return nil
}

func (l *LeaderBoard) SurfixName() {
	numSet := "0123456789"
	l.Name += "#"
	for i := 0; i < 4; i++ {
		c := numSet[m.Intn(len(numSet))]
		l.Name += string(c)
	}
}
