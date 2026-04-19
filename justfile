default:
    @just --list

build:
    docker compose build    # copy lockfile out of the built image so host stays in sync
    docker cp $(docker create --rm shadcnrb-example:dev):/rails/Gemfile.lock ./Gemfile.lock
