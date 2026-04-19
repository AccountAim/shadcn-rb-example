# Repo workflow

This repo is exactly 4 commits on `main`, plus one regenerable install commit in the middle. Each commit is one layer of "how a Rails app adopts shadcn-rb":

| Tag | Subject | Content |
|-----|---------|---------|
| `baseline` | Baseline Rails 8.1 app | Vanilla `rails new` + non-root Dockerfile + healthcheck + minimal justfile (`default` + `build`). `/` serves the Rails welcome page. |
| `harness` | Add dev harness | Adds the iteration recipes (`reinstall`, `replay`, `retag`) to the justfile. Nothing Rails-app-specific. |
| `adopt-patch` | Add shadcn-rb gem + dev compose mount | Gemfile pins shadcn-rb to `git: …, branch: "main"`. compose.yaml bind-mounts `../shadcn-rb:/shadcn-rb` and sets `BUNDLE_LOCAL__SHADCN___RB` so dev containers swap the git gem for the sibling repo at runtime — no Gemfile conditional, no lockfile churn. |
| *(untagged)* | Run shadcnrb:install + shadcnrb:components | Installer output — ejected `app/components/shadcnrb/`, importmap pin, initializer, etc. Regenerated from scratch every replay. |
| `demo-content` | Add demo content: docs site + blocks + playground | Everything this repo owns beyond the installer: docs pages, home, blocks, playground, extra icons, `rouge` + `method_source` in Gemfile, `Shadcnrb::Styles::Neobrutalism`. |

## Rebuilding after a gem change

```sh
just replay
```

Resets to `harness`, cherry-picks `adopt-patch`, rebuilds the image, runs the installer, commits it, cherry-picks `demo-content`, rebuilds once more so demo gems land in the bundle. After any replay run `just retag` — it matches commits by subject line and re-points all four tags.

## Conflict handling

`demo-content` is where gem refactors land cherry-pick conflicts (renamed identifiers in docs pages, renamed module paths in `application_controller.rb`). Flow:

1. Resolve the conflicted `.erb` / `.rb` files — take the new API.
2. For `Gemfile.lock` conflicts, `git checkout --ours Gemfile.lock && git add Gemfile.lock` — the final `just build` regenerates it with the new shadcn-rb SHA plus demo gems.
3. `git cherry-pick --continue`, then `just retag`.

## Rules

- **Never a 5th commit on `main`.** Squash into a tagged commit or push elsewhere.
- **Tags match subject lines.** `just retag` depends on it; don't rename commits without updating the recipe.
- **A `Gemfile.lock` diff after `docker compose up` means bundler re-resolved** — investigate before committing.
- **Edit generated files at the source.** Anything under `app/components/shadcnrb/` comes from the gem's `lib/shadcnrb/` + install templates. Edit there first; `just replay` regenerates the install commit. Copying into the ejected file is fine for quick testing but disappears on the next replay.

## Sanity checks

```sh
git show-ref --tags                 # all four tags moved together
git log --oneline main              # five commits, subjects match table above
curl -sf localhost:4000/ | head -1  # 200 + <!DOCTYPE html>
curl -sf localhost:4000/docs | head -1
```
