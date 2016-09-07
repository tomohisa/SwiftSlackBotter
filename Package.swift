import PackageDescription
let package = Package(
    name: "SwiftSlackBotter",
    dependencies: [
      .Package(url: "https://github.com/Zewo/WebSocketClient.git", majorVersion: 0, minor: 1),
      .Package(url: "https://github.com/Zewo/JSON.git", majorVersion: 0, minor: 9),
      .Package(url: "https://github.com/czechboy0/Environment.git", majorVersion: 0, minor: 3),
      .Package(url: "https://github.com/Zewo/Log.git", majorVersion: 0, minor: 8),
    ]
)
