pluginManagement {
    val jreleaserVersion: String by settings
    plugins {
        id("org.jreleaser") version jreleaserVersion
    }
}

rootProject.name = "jreleaser-tracelog-repro"
