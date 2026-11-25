#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

clang++ -x c++ -std=c++17 "$repo_dir/src/filter-by-min-age.c" -o "$tmp_dir/filter-by-min-age"

actual="$(printf 'Ada,22\nBo,17\n' | "$tmp_dir/filter-by-min-age" 18)"
if [[ "$actual" != "Ada, 22" ]]; then
  printf 'Unexpected output for valid rows: %s\n' "$actual" >&2
  exit 1
fi

printf 'Ada\nBo,20\n' | "$tmp_dir/filter-by-min-age" 18 \
  >"$tmp_dir/missing-age.out" 2>"$tmp_dir/missing-age.err"
if [[ "$(<"$tmp_dir/missing-age.out")" != "Bo, 20" ]] ||
   ! grep -Fqx 'Line 1: Age missing.' "$tmp_dir/missing-age.err"; then
  printf 'Missing-age row was not handled as expected.\n' >&2
  exit 1
fi

printf '\nAda,22\n' | "$tmp_dir/filter-by-min-age" 18 \
  >"$tmp_dir/blank-line.out" 2>"$tmp_dir/blank-line.err"
if [[ "$(<"$tmp_dir/blank-line.out")" != "Ada, 22" ]] ||
   ! grep -Fqx 'Line 1: Whole line missing.' "$tmp_dir/blank-line.err"; then
  printf 'Blank row was not handled as expected.\n' >&2
  exit 1
fi

printf 'Filter tests passed.\n'
