#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$DIR/spotify-player"
SRC="$DIR/spotify-player.swift"

if [ ! -x "$BIN" ] || [ "$SRC" -nt "$BIN" ]; then
  swiftc -O "$SRC" -o "$BIN" 2>/dev/null
  chmod +x "$BIN"
fi

exec "$BIN"
