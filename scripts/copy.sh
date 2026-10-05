#!/usr/bin/env bash
# WSL only; native Windows callers use copy.ps1 directly.
set -euo pipefail
clipboard_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
clipboard_ps="$(command -v powershell.exe || true)"
if [[ -z "$clipboard_ps" ]]; then
    clipboard_ps=/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe
fi
if [[ ! -x "$clipboard_ps" ]] || ! command -v wslpath >/dev/null; then
    echo 'Clipboard helper requires WSL Windows interop, or native Windows PowerShell.' >&2
    exit 1
fi
clipboard_path="$(wslpath -w "$clipboard_dir/copy.ps1")"
exec "$clipboard_ps" -NoProfile -NonInteractive -File "$clipboard_path" -FromStdin "$@"
