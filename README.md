# shadcn-rb example

A Rails 8 demo + docs site for the [`shadcn-rb`](https://github.com/accountaim/shadcn-rb) gem — a port of [shadcn/ui](https://ui.shadcn.com) components to Ruby/Rails as ActionView builders.

Browse the component catalog, see the ERB source for each example, and use it as a reference app when wiring `shadcn-rb` into your own project.

The header has two live pickers: **Theme** (color palette) and **Style** (structural look — default shadcn vs neobrutalism). The style picker sets a cookie and reloads; `ApplicationController` reads it and calls the matching `Shadcnrb::Styles::*.apply!`. See `app/components/shadcnrb/styles/neobrutalism.rb` for the reference style.

## Stack

- Ruby 3.3, Rails 8.1
- Propshaft + `tailwindcss-rails` (v4, Rust-backed standalone CLI — no Node required)
- Importmap + Turbo + Stimulus
- No database, no background jobs — it's a static docs/demo app

## Run it

Requires Docker, Docker Compose, and [`just`](https://github.com/casey/just). The `../shadcn-rb` sibling directory must exist (so the dev container can volume-mount it for live gem editing).

```bash
just build   # build the dev image + sync Gemfile.lock from the built bundle
just up      # start the container on http://localhost:4000
just down    # stop
just sh      # shell into the running container
just logs    # tail logs
```

`bin/rails server` runs on container port 3000, mapped to host port 4000. A second foreman process runs `tailwindcss:watch` for live CSS rebuilds. Page reload picks up Rails reloader changes automatically.

## Layout

- `app/components/shadcnrb/` — thin wrappers around the gem's builders, plus a few example-app-only components.
- `app/views/docs/` — the docs site itself (one view per component).
- `app/javascript/controllers/shadcnrb/` — Stimulus controllers for the interactive components.
- `compose.yaml`, `Dockerfile`, `justfile` — container workflow.

## Gem source

The Gemfile pulls `shadcn-rb` from [`https://github.com/accountaim/shadcn-rb`](https://github.com/accountaim/shadcn-rb). For local development, `compose.yaml` sets `BUNDLE_LOCAL__SHADCN__RB=/shadcn-rb` and mounts `../shadcn-rb` into the container, so edits in that sibling repo are live.

## License

MIT — see [LICENSE](./LICENSE).
