import PackageDescription

let package = Package(
    name: "Genome",
    dependencies: [
        // Using LoganWright until update core library
        .Package(url: "https://github.com/LoganWright/Swift-JsonSerializer", majorVersion: 2)
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
        // Target(
        //     name: "Generator"
        // )
    ]
)

let lib = Product(name: "Genome", type: .Library(.Dynamic), modules: "Genome")
products.append(lib)
