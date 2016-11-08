import PackageDescription

let package = Package(
    name: "Node",
    targets: [
        Target(
            name: "Node"
        ),
    ],
    dependencies: [
      .Package(url: "https://github.com/vapor/path-indexable.git", majorVersion: 1),
      .Package(url: "https://github.com/vapor/polymorphic.git", majorVersion: 1)
    ]
)
