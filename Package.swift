import PackageDescription
let package = Package(
    name: "SwiftSlackBotter",
    dependencies: [
      .Package(url: "https://github.com/Zewo/WebSocketClient.git", majorVersion: 0, minor: 0),
      .Package(url: "https://github.com/Zewo/JSON.git", majorVersion: 0, minor: 7),
      .Package(url: "https://github.com/czechboy0/Environment.git", majorVersion: 0, minor: 3),
      .Package(url: "https://github.com/Zewo/Log.git", majorVersion: 0, minor: 6),
      .Package(url: "https://github.com/Zewo/StandardOutputAppender.git", majorVersion: 0, minor: 6),
    ]
)
