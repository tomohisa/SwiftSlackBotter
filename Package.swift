import PackageDescription

let package = Package(
    name: "SwiftSlackBotter",
    dependencies: [
      .Package(url: "https://github.com/Zewo/WebSocket.git", majorVersion: 0, minor: 4),
      .Package(url: "https://github.com/Zewo/JSON.git", majorVersion: 0, minor: 4),
    ]
)
