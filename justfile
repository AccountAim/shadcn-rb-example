# shellcheck disable=SC2148
default:
    @just --list

start:
    docker compose up

build:
    docker compose build
    docker compose run --rm web bundle install # syncs the lockfile

# Conservatively update one gem, or every gem with `all`, then rebuild against the new lockfile.
gem-upgrade name: && build
    docker compose run --rm --no-deps web bundle update \
      {{ if name == "all" { "" } else { "--conservative " + quote(name) } }}

# Re-eject shadcn-rb infra + every component into app/components/shadcnrb/.
# Run after gem updates or when the ejected files drift from the gem source.
reinstall:
    docker compose exec web bin/rails g shadcnrb:install --force
    docker compose exec web bin/rails g shadcnrb:components --force

# main is kept at exactly 4 commits so a developer can see, by diff, what
# each layer of adopting shadcn-rb actually changes in their own app:
#
#   1. baseline     — vanilla `rails new` (what you get before shadcnrb).
#   2. harness      — dev tooling we add; no shadcnrb yet.
#   3. adopt-patch  — the Gemfile / compose / installer diff (= "to adopt
#                     shadcnrb, apply this diff").
#   4. demo-content — this repo's docs site / blocks, not part of the
#                     adoption step.
#
# `just git-amend`, `just git-sort`, `just git-retag`, `just git-push`, and
# `just replay` exist to preserve that shape: each uncommitted file lands
# in its right layer; tags track the SHAs; CI re-creates the tree from the
# gem source (`just replay`). Never land a 5th commit on main.

# Replay the whole history from tags. `main` ends up as exactly 4 commits:
# baseline → harness → adopt-patch (gem + compose + installer output folded
# in via `--amend`) → demo-content.
#
# If the final cherry-pick conflicts, the gem refactored something the demo
# touches — fix, `git cherry-pick --continue`, then `just git-retag`.
replay:
    #!/usr/bin/env bash
    set -euo pipefail
    git switch main
    git reset --hard harness
    git cherry-pick refs/tags/adopt-patch
    just build
    docker compose up -d --wait --wait-timeout 90
    just reinstall
    # Fold installer output into adopt-patch so the commit is self-contained
    # ("adopt = add gem + install"). Keeps main at 4 commits total.
    git add -A
    git commit --amend --no-edit
    git cherry-pick refs/tags/demo-content
    # demo-content typically adds gems (rouge, method_source, …) — rebuild
    # the image so they land in the bundle before `just up`.
    just build
    docker compose up -d --wait --wait-timeout 90
    just git-retag

# --- Smoke tests ---------------------------------------------------------

# curl every GET route registered in `rails routes`; exit non-zero on any
# non-200. `:id` segments are expanded for `components#` (from view files)
# and `blocks#` (from `app/views/blocks/*.erb`); other dynamic routes are
# skipped. Internal routes (`rails/*`, `/up`, `/cable`) are filtered out.
quick-validate:
    #!/usr/bin/env bash
    set -uo pipefail
    BASE="${BASE:-http://localhost:4000}"

    mapfile -t raw < <(
      docker compose exec -T web bin/rails routes 2>/dev/null \
        | awk 'NR>1 && $2=="GET" {print $3}' \
        | sed 's/(\.:format)//' \
        | grep -vE '^/(rails/|up$|cable$)' \
        | sort -u
    )

    # Expand known dynamic segments from the filesystem.
    mapfile -t components < <(for f in app/views/docs/components/*.html.erb; do basename "$f" .html.erb; done | sort)
    mapfile -t blocks     < <(for f in app/views/blocks/*.html.erb;         do basename "$f" .html.erb; done | grep -vE '^(_|index$)' | sort)

    urls=()
    for u in "${raw[@]}"; do
      case "$u" in
        */components/:id) for c in "${components[@]}"; do urls+=("${u%:id}$c"); done ;;
        */blocks/:id)     for b in "${blocks[@]}";     do urls+=("${u%:id}$b"); done ;;
        *:*)              ;;  # other dynamic — skip
        *)                urls+=("$u") ;;
      esac
    done

    fail=0
    for url in "${urls[@]}"; do
      code=$(curl -s -o /dev/null -w '%{http_code}' "$BASE$url" || echo "---")
      if [ "$code" = "200" ]; then
        printf '  \033[32m%s\033[0m  %s\n' "$code" "$url"
      else
        printf '  \033[31m%s\033[0m  %s\n' "$code" "$url"
        fail=1
      fi
    done
    [ "$fail" = "0" ] && echo "all pages 200" || echo "failures above"
    exit $fail

# Browser smoke via agent-browser: loads key pages and checks for
# horizontal overflow (positive = content wider than viewport = bug) plus
# docs source-extraction fallbacks (any "source not available" = bug).
validate:
    #!/usr/bin/env bash
    set -uo pipefail
    BASE="${BASE:-http://localhost:4000}"
    pages=(
      /
      /docs/components/dialog
      /docs/components/sidebar
      /docs/components/sidebar/playground
      /docs/components/collapsible
      /docs/components/drawer
      /docs/components/dropdown_menu
      /docs/components/tabs
      /blocks/app_shell
      /blocks/nav_and_sidebar
    )
    agent-browser close >/dev/null 2>&1 || true
    fail=0
    for path in "${pages[@]}"; do
      if ! agent-browser open --headed "$BASE$path" >/dev/null 2>&1; then
        printf '  open-failed  %s\n' "$path"; fail=1; continue
      fi
      raw=$(agent-browser eval "(document.documentElement.scrollWidth - window.innerWidth) + '|' + ((document.body.innerText.match(/source not available/g) || []).length)" 2>/dev/null | tail -1 | tr -d '"')
      overflow="${raw%|*}"
      src="${raw#*|}"
      if [ "$overflow" -le 0 ] && [ "$src" = "0" ]; then
        printf '  ok    overflow=%-4s src-missing=%s  %s\n' "$overflow" "$src" "$path"
      else
        printf '  fail  overflow=%-4s src-missing=%s  %s\n' "$overflow" "$src" "$path"
        fail=1
      fi
    done
    [ "$fail" = "0" ] && echo "browser smoke passed" || echo "browser smoke failed"
    exit $fail

# --- 4-commit history management ----------------------------------------

# Amend all current changes into HEAD (demo-content) and retag. The common
# case — demo views, controllers, routes edits all belong there.
git-amend:
    git add -A
    git commit --amend --no-edit
    just git-retag

# Re-point every tag to the matching commit on the current branch, looked
# up by commit subject. Run after a replay that reshuffled SHAs (or after
# resolving a cherry-pick conflict during replay).
git-retag:
    #!/usr/bin/env bash
    set -euo pipefail
    find_sha() { git log --format='%H %s' main | grep -F -m1 -- "$1" | cut -d' ' -f1; }
    git tag -f baseline     "$(find_sha "Baseline Rails")"
    git tag -f harness      "$(find_sha "Add dev harness")"
    git tag -f adopt-patch  "$(find_sha "Add shadcn-rb gem")"
    git tag -f demo-content "$(find_sha "Add demo content")"

# Classify uncommitted paths by their target commit, create one fixup
# commit per target, and autosquash them back into place. Use when an edit
# spans layers (e.g. Gemfile.lock → adopt-patch + a view → demo-content).
# Errors out if any path is installer-generated; those must go through the
# gem + `just replay`.
git-sort:
    #!/usr/bin/env bash
    set -euo pipefail

    classify() {
        case "$1" in
            Dockerfile|.dockerignore|.rubocop.yml)                     echo baseline ;;
            justfile|AGENTS.md|CLAUDE.md)                              echo harness ;;
            Gemfile|Gemfile.lock|compose.yaml)                         echo adopt-patch ;;
            app/components/shadcnrb/*|config/initializers/shadcnrb.rb) echo GENERATED ;;
            app/assets/tailwind/*.css)                                 echo GENERATED ;;
            *)                                                         echo demo-content ;;
        esac
    }

    mapfile -t paths < <(git status --porcelain | awk '{ $1=""; sub(/^ /,""); print }')
    [ "${#paths[@]}" -eq 0 ] && { echo "no changes"; exit 0; }

    err=0
    for p in "${paths[@]}"; do
        [ "$(classify "$p")" = "GENERATED" ] || continue
        echo "ERROR: $p is installer-generated; edit in the gem and run 'just replay'"
        err=1
    done
    [ "$err" -eq 1 ] && exit 1

    group_for() {
        local target="$1"
        local p
        for p in "${paths[@]}"; do
            [ "$(classify "$p")" = "$target" ] && printf '%s\0' "$p"
        done
    }

    echo "Plan:"
    for t in baseline harness adopt-patch demo-content; do
        mapfile -d '' -t files < <(group_for "$t")
        [ "${#files[@]}" -eq 0 ] && continue
        echo "  → $t"
        printf '       %s\n' "${files[@]}"
    done
    read -n 1 -r -p "Proceed? [y/N] " ans; echo
    [[ "$ans" =~ ^[Yy]$ ]] || { echo "aborted"; exit 1; }

    for t in baseline harness adopt-patch demo-content; do
        mapfile -d '' -t files < <(group_for "$t")
        [ "${#files[@]}" -eq 0 ] && continue
        git add -- "${files[@]}"
        git commit --fixup="$t" > /dev/null
    done

    GIT_SEQUENCE_EDITOR=: git rebase --autosquash --interactive baseline
    just git-retag

# Force-push main + all tags to origin. Every `just replay` rewrites SHAs
# on main and moves the four tags, so a non-force push rejects. Prompts
# for a single-keystroke confirmation since this overwrites history on
# the remote.
git-push:
    #!/usr/bin/env bash
    set -euo pipefail
    read -n 1 -r -p "Force-push main + all tags to origin? [y/N] " ans
    echo
    [[ $ans =~ ^[Yy]$ ]] || { echo "aborted"; exit 1; }
    git push --force origin main
    git push --force --tags origin
