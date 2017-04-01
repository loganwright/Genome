import PackageDescription

let package = Package(
    name: "Genome",
    targets: [
        Target(
            name: "Genome",
            dependencies: [
            ]
        ),
        Target(
            name: "GenomeFoundation",
            dependencies: [
                .Target(name: "Genome")
            ]
        ),
        Target(
            name: "GenomeCoreData",
            dependencies: [
                .Target(name: "GenomeFoundation"),
                .Target(name: "Genome")
            ]
        ),
    ],
    dependencies: [
        .Package(url: "https://github.com/couchdeveloper/node.git", majorVersion: 1)
    ],
    exclude: [
        "Sources/Genome/CoreData"
    ]
)
