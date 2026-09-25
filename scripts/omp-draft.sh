#!/bin/bash
# omp prompt scratchpad — compose a prompt with full vim, copy it to the
# system clipboard on exit. Launched by a zellij keybind (Alt+e) as a split
# pane beside the omp chat, so the transcript stays visible while you type.
#
# Flow: type prompt -> :wq / ZZ (or any :q) -> buffer is copied to clipboard,
# pane auto-closes, focus returns to omp -> paste with Ctrl+V (or Alt+Shift+V).

f="${TMPDIR:-/tmp}/omp-draft.md"
: > "$f" # start from an empty buffer each time

# Pick a clipboard command for the current platform.
if command -v pbcopy >/dev/null 2>&1; then
	clip='pbcopy'                     # macOS
elif command -v win32yank.exe >/dev/null 2>&1; then
	clip='win32yank.exe -i --crlf'    # WSL -> Windows clipboard
elif command -v wl-copy >/dev/null 2>&1; then
	clip='wl-copy'                    # Wayland
elif command -v xclip >/dev/null 2>&1; then
	clip='xclip -selection clipboard' # X11
else
	clip='cat >/dev/null'             # no clipboard available; drop silently
fi

autocmd="autocmd VimLeavePre * call system('${clip}', join(getline(1,'\$'), \"\n\"))"
exec nvim -c "$autocmd" "$f"
