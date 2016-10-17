import PackageDescription
let package = Package(
    name: "SwiftSlackBotter",
    dependencies: [
      .Package(url: "https://github.com/Zewo/WebSocketClient.git", majorVersion: 0, minor: 14),
      .Package(url: "https://github.com/Zewo/Axis.git", majorVersion: 0, minor: 14),
      .Package(url: "https://github.com/Zewo/POSIX.git", majorVersion: 0, minor: 14),
    ]
)
