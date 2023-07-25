#!/usr/bin/env bash
DEPS=(
  libsoup-3.0-dev libjavascriptcoregtk-4.1-dev libwebkit2gtk-4.1-dev libgtk-3-dev libglib2.0-dev
)
apt=$(which nala 2>/dev/null || which apt 2>/dev/null || which apt-get 2>/dev/null || printf '')

if [ -z "$apt" ]; then
  echo "Could not find apt" >&2
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  sudo=()
else
  # shellcheck disable=SC2206 # Splitting is intentional.
  sudo=(${SUDO:-sudo})
fi

first=${1:-install}
case "${first,,}" in
install) "${sudo[@]}" "$apt" install -- "${DEPS[@]}" ;;
remove)
  "${sudo[@]}" apt-mark auto -- "${DEPS[@]}"
  "${sudo[@]}" "$apt" autoremove
  ;;
*)
  printf '%s\n' "Unknown operation: ${first}" >&2
  exit 2
  ;;
esac
