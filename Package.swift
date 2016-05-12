import PackageDescription

let package = Package(
    name: "Genome",
    dependencies: [
        // using qutheory until update core library
        .Package(url: "https://github.com/qutheory/pure-json", majorVersion: 2, minor: 1)
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
             name: "GenomeJson",
             dependencies: [
                .Target(name: "Genome")
                //  .Package(url: "../Swift-PureJsonSerializer", majorVersion: 2)
             ]
         ),
          Target(
              name: "GenomeCoreData",
              dependencies: [
                 .Target(name: "GenomeFoundation"),
                 .Target(name: "Genome")
              ]
          ),
    ]
)
