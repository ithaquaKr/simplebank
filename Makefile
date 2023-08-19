# Makefile

# Environment variables for project
ENV := $(PWD)/.env
include $(ENV)

# Export all variable to sub-make
export 

# Internal variables
DB_URL=postgresql://${POSTGRES_DB_USER}:${POSTGRES_DB_PASSWORD}@${POSTGRES_DB_HOST}:${POSTGRES_DB_PORT}/${POSTGRES_DB}?sslmode=disable


#------------------------
# Database
#------------------------
postgresql:
	@echo "Running postgresql container..."
	docker run --name postgresql -p ${POSTGRES_DB_PORT}:${POSTGRES_DB_PORT} -e POSTGRES_USER=${POSTGRES_DB_USER} -e POSTGRES_PASSWORD=${POSTGRES_DB_PASSWORD} -d ${POSTGRES_IMAGE}

createdb:
	@echo "Creating database.."
	docker exec -it postgresql createdb --username=backend --owner=backend simple_bank

dropdb:
	@echo "Droping database..."
	docker exec -it postgresql dropdb simple_bank

migrateup:
	@echo "Migrate up schema for database..."
	migrate -path db/migrations -database "${DB_URL}" -verbose up

migratedown:
	@echo "Migrate down schema for database..."
	migrate -path db/migrations -database "${DB_URL}" -verbose down

sqlc:
	sqlc generate

.PHONY: postgresql createdb dropdb migrateup migratedown sqlc
