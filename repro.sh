#!/usr/bin/env bash
# The reproduction is very sensitive. This script therefore copies the project
# into a fresh, isolated git repo in a temp dir before running.
#
# Usage:
#   ./repro.sh                              # jreleaserVersion=1.25.0 -> trace.log ABSENT (bug)
#   ./repro.sh -PjreleaserVersion=1.23.0    # -> trace.log PRESENT (control)
set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
work="$(mktemp -d)"
trap 'echo; echo "(workspace kept at: $work)"' EXIT

# Copy the project (just the source files) into an isolated location.
cp -R "$here/gradle" "$work/"
cp "$here"/gradlew "$here"/gradlew.bat "$work/"
cp "$here"/settings.gradle.kts "$here"/build.gradle.kts "$here"/gradle.properties "$work/"
cd "$work"

# JReleaser needs a git repo with a commit, a semver tag, and an origin remote,
# with the project AT the git root.
git init -q
git config user.email repro@example.com
git config user.name  repro
git remote add origin https://github.com/example/jreleaser-tracelog-repro.git
git add -A && git commit -qm repro && git tag v1.0.0

chmod +x gradlew
./gradlew --no-daemon jreleaserConfig "$@" || true

echo
echo "--- build/jreleaser contents ---"
ls -la build/jreleaser 2>/dev/null || echo "(no build/jreleaser directory)"
echo
if [ -f build/jreleaser/output.properties ] && [ ! -f build/jreleaser/trace.log ]; then
  echo "RESULT: output.properties present but trace.log ABSENT -> bug reproduced"
elif [ -f build/jreleaser/trace.log ]; then
  echo "RESULT: trace.log PRESENT -> not reproduced (expected on 1.23.0)"
else
  echo "RESULT: inconclusive (jreleaserConfig did not reach the output stage)"
fi
