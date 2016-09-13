import PackageDescription

let package = Package(
    name: "Node",
    targets: [
        Target(
            name: "Node"
        ),
    ],
    dependencies: [
      .Package(url: "https://github.com/vapor/path-indexable.git", majorVersion: 0, minor: 4),
      .Package(url: "https://github.com/vapor/polymorphic.git", majorVersion: 0, minor: 4)
    ],
    exclude: [
        "Resources"
    ]
)
