package main

import (
	"database/sql"
	"log"

	"github.com/ithaquaKr/simplebank/api"
	db "github.com/ithaquaKr/simplebank/db/sqlc"
	"github.com/ithaquaKr/simplebank/utils"
	_ "github.com/lib/pq"
)

func main() {
	config, err := utils.LoadConfig(".")
	if err != nil {
		log.Fatal("Can not load config", err)
	}
	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("Cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	var serverAddress = config.AppHost + ":" + config.AppPort
	err = server.Start(serverAddress)
	if err != nil {
		log.Fatal("Cannot start server:", err)
	}
}
