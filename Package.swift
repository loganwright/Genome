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
             name: "GenomeJSON",
             dependencies: [
                .Target(name: "Genome")
                //  .Package(url: "../Swift-PureJSONSerializer", majorVersion: 2)
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
        .Package(url: "https://github.com/qutheory/json", majorVersion: 0, minor: 2)
    ],
    exclude: [
        "Sources/Genome/CoreData"
    ]
)
