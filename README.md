# jreleaser no-trace repro

This is a minimal repro for a jreleaser gradle plugin bug that causes jrelaser
to not produce a trace log under certain circumstances.

This bug appears on 1.25.0, but not on 1.23.0.

## Reproduce

```bash
./repro.sh                              # jreleaserVersion=1.25.0 -> trace.log ABSENT (bug)
./repro.sh -PjreleaserVersion=1.23.0    # -> trace.log PRESENT (control)
```

`repro.sh` copies the project into a fresh, isolated git repo in a temp dir,
sets up the commit / `v1.0.0` tag / `origin` remote that JReleaser requires,
runs `jreleaserConfig`, and prints whether `trace.log` was produced. It
self-isolates on purpose because the reproduction is very fragile. I'm not
sure what state changes things, so this just keeps things clean.

The only variable between the two invocations is the plugin version.

## Observed Results

| plugin version | build result | `output.properties` | `trace.log` |
| --- | --- | --- | --- |
| 1.23.0 | SUCCESSFUL | present | **present** |
| 1.25.0 | SUCCESSFUL | present | **absent** |

This is both on macOS and Linux (a codebuild ubuntu docker container).
