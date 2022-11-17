#!/usr/bin/env bash
set -euo pipefail

source dependencies.sh

mkdir -p ~/.byond/bin
wget -O ~/.byond/bin/libdflib.so "https://github.com/Dwarf-Fortress-13/DFLib/releases/download/$DFLIB_VERSION/libdflib.so"
chmod +x ~/.byond/bin/libdflib.so
ldd ~/.byond/bin/libdflib.so
