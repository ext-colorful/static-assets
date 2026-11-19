#!/usr/bin/env bash
set -euo pipefail

readonly remote=origin
readonly branch=main

if ! repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  printf 'Error: run this script from inside the repository.\n' >&2
  exit 1
fi
cd "$repo_root"

if ! git remote get-url "$remote" >/dev/null 2>&1; then
  printf 'Error: Git remote "%s" is not configured.\n' "$remote" >&2
  exit 1
fi

printf 'This will replace origin/%s with a new empty root commit.\n' "$branch"
printf 'Existing commits will no longer be reachable from origin/%s.\n' "$branch"
if ! IFS= read -r -p 'Type "RESET main" to continue: ' confirmation; then
  printf '\nError: could not read confirmation.\n' >&2
  exit 1
fi
if [[ "$confirmation" != 'RESET main' ]]; then
  printf 'Cancelled.\n'
  exit 1
fi

if ! remote_ref="$(git ls-remote --heads "$remote" "refs/heads/$branch")"; then
  printf 'Error: could not read origin/%s.\n' "$branch" >&2
  exit 1
fi
if [[ -z "$remote_ref" ]]; then
  printf 'Error: remote branch origin/%s does not exist.\n' "$branch" >&2
  exit 1
fi
read -r expected_sha _ <<< "$remote_ref"

empty_tree="$(git mktree </dev/null)"
new_commit="$(printf 'Reset main history to an empty root commit\n' | git commit-tree "$empty_tree")"

git push \
  --force-with-lease="refs/heads/$branch:$expected_sha" \
  "$remote" \
  "$new_commit:refs/heads/$branch"

printf 'Updated origin/%s to empty root commit %s.\n' "$branch" "$new_commit"
