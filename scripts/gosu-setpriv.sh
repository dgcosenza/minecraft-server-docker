#!/bin/sh
# Minimal zero-Go gosu-compatible privilege dropper using Debian util-linux setpriv.
# Used only when the container is explicitly started as root for custom UID/GID remapping.
set -eu

if [ "$#" -lt 2 ]; then
  echo "Usage: gosu user[:group] command [args...]" >&2
  exit 1
fi

spec="$1"
shift

user_part="${spec%%:*}"
if [ "$user_part" != "$spec" ]; then
  group_part="${spec#*:}"
else
  group_part=""
fi

if ! passwd_entry="$(getent passwd "$user_part")"; then
  case "$user_part" in
    ''|*[!0-9]*) echo "gosu: unknown user '$user_part'" >&2; exit 1 ;;
    *) uid="$user_part"; default_gid=""; home_dir="/data" ;;
  esac
else
  uid="$(printf '%s' "$passwd_entry" | cut -d: -f3)"
  default_gid="$(printf '%s' "$passwd_entry" | cut -d: -f4)"
  home_dir="$(printf '%s' "$passwd_entry" | cut -d: -f6)"
fi

if [ -n "$group_part" ]; then
  if group_entry="$(getent group "$group_part")"; then
    gid="$(printf '%s' "$group_entry" | cut -d: -f3)"
  else
    case "$group_part" in
      ''|*[!0-9]*) echo "gosu: unknown group '$group_part'" >&2; exit 1 ;;
      *) gid="$group_part" ;;
    esac
  fi
elif [ -n "$default_gid" ]; then
  gid="$default_gid"
else
  gid="$uid"
fi

if [ -n "$home_dir" ]; then
  export HOME="$home_dir"
fi

if [ -n "${passwd_entry:-}" ]; then
  exec setpriv --reuid="$uid" --regid="$gid" --init-groups -- "$@"
else
  exec setpriv --reuid="$uid" --regid="$gid" --clear-groups -- "$@"
fi
