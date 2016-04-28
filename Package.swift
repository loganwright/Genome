import PackageDescription

let package = Package(
    name: "Genome",
    dependencies: [
      // .Package(url: "https://github.com/gfx/Swift-PureJsonSerializer.git", majorVersion: 1)
    ],
    exclude: [
        "Sources/Genome/CoreData",
        "Sources/Genome/Json"
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
        // Target(
        //     name: "Performance",
        //     dependencies: [
        //         .Target(name: "Vapor")
        //     ]
        // ),
        // Target(
        //     name: "Generator"
        // )
    ]
)

let lib = Product(name: "Genome", type: .Library(.Dynamic), modules: "Genome")
products.append(lib)
