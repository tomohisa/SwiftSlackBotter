import PackageDescription

let package = Package(
    name: "SwiftSlackBotter",
    dependencies: [
      .Package(url: "https://github.com/Zewo/WebSocket.git", majorVersion: 0, minor: 3),
      .Package(url: "https://github.com/Zewo/JSON.git", majorVersion: 0, minor: 3),
      .Package(url: "https://github.com/Zewo/CURIParser.git", majorVersion: 0, minor: 2),
      .Package(url: "https://github.com/Zewo/CHTTPParser.git", majorVersion: 0, minor: 2),
      .Package(url: "https://github.com/czechboy0/Environment.git", majorVersion: 0),
    ]
)
//.Package(url: "https://github.com/Zewo/Zewo.git", majorVersion: 0, minor: 4),
