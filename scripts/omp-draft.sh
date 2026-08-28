#!/bin/bash
# omp prompt scratchpad — compose a prompt with full vim, copy it to the
# macOS clipboard on exit. Launched by a zellij keybind (Alt+e) as a split
# pane beside the omp chat, so the transcript stays visible while you type.
#
# Flow: type prompt -> :wq / ZZ (or any :q) -> buffer is copied to clipboard,
# pane auto-closes, focus returns to omp -> paste with Ctrl+V (or Alt+Shift+V).
f="${TMPDIR:-/tmp}/omp-draft.md"
: > "$f"   # start from an empty buffer each time
exec /opt/homebrew/bin/nvim \
  -c 'autocmd VimLeavePre * call system("pbcopy", join(getline(1,"$"), "\n"))' \
  "$f"
