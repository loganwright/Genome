import PackageDescription

let package = Package(
    name: "Genome",
    dependencies: [
      .Package(url: "https://github.com/gfx/Swift-PureJsonSerializer.git", majorVersion: 1)
    ]
)
