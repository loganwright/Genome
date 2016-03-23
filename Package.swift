import PackageDescription

let package = Package(
    name: "Genome",
    dependencies: [
      .Package(url: "https://github.com/gfx/Swift-PureJsonSerializer.git", majorVersion: 1)
    ]
)

let lib = Product(name: "Genome", type: .Library(.Dynamic), modules: "Genome")
products.append(lib)
