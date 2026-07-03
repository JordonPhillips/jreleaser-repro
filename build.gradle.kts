plugins {
    base
    id("org.jreleaser")
}

version = "1.0.0"

// Minimal configuration sufficient for `jreleaserConfig` to run to completion.
jreleaser {
    release {
        github {
            repoOwner = "JordonPhillips"
            name = "jreleaser-repro"
            // Not used by `jreleaserConfig`; present only so the model validates.
            token = "dummy"
        }
    }
}
