import PackageDescription

let package = Package(
    name: "Genome",
    dependencies: [
    ],
    exclude: [
        "Sources/Genome/CoreData"
    ],
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
          Target(
            name: "GenomeSerialization",
            dependencies: [
                 .Target(name: "Genome")
              ]
            )
    ]
)
