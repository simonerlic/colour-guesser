# Server

2 endpoints:

```http
### get all leaderboard scores
GET http://127.0.0.1:8080/leaderboard

### new leaderboard scores
POST http://127.0.0.1:8080/leaderboard/new
Content-type: application/json

{
    "name": "foo1",
    "score": 45
}
```

### GET
- returns 10 at max 10 items

```json
[
    {
        "id": "string",
        "time": "time utc",
        "name": "somename#1234",
        "score": "uint8"
    }
]
```

type LeaderBoard struct {
	ID    string `json:"id,omitempty"`
	Time  uint64 `json:"time,omitempty"`
	Name  string `json:"name,omitempty"`
	Score uint8  `json:"score,omitempty"`
}

