#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
    echo 'Usage: bash tools/sync-robotspeak.sh <robotspeak-checkout>' >&2
    exit 1
fi
skill_repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
robotspeak_source_dir="$1"
robotspeak_commit="$(git -C "$robotspeak_source_dir" rev-parse HEAD)"
git -C "$robotspeak_source_dir" show HEAD:scripts/robot-voice.ps1 > "$skill_repo_dir/scripts/robot-voice.ps1"
git -C "$robotspeak_source_dir" show HEAD:LICENSE > "$skill_repo_dir/scripts/ROBOTSPEAK-LICENSE"
robotspeak_hash="$(sha256sum "$skill_repo_dir/scripts/robot-voice.ps1")"
robotspeak_hash="${robotspeak_hash%% *}"
printf '{\n  "repository": "https://github.com/oddradiocircle/robotspeak",\n  "commit": "%s",\n  "path": "scripts/robot-voice.ps1",\n  "sha256": "%s"\n}\n' "$robotspeak_commit" "$robotspeak_hash" > "$skill_repo_dir/robotspeak-source.json"
