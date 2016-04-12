import PackageDescription
#if os(OSX)
    let COpenSSLURL = "https://github.com/Zewo/COpenSSL-OSX.git"
#else
    let COpenSSLURL = "https://github.com/Zewo/COpenSSL.git"
#endif
let minor : Int = 3
let package = Package(
    name: "SwiftSlackBotter",
    dependencies: [
      .Package(url: "https://github.com/Zewo/WebSocket.git", majorVersion: 0, minor: minor),
      .Package(url: "https://github.com/Zewo/JSON.git", majorVersion: 0, minor: minor),
      .Package(url: "https://github.com/Zewo/CURIParser.git", majorVersion: 0, minor: 2),
      .Package(url: "https://github.com/Zewo/CHTTPParser.git", majorVersion: 0, minor: 2),
      .Package(url: "https://github.com/Zewo/CLibvenice.git", majorVersion: 0, minor: 2),
      .Package(url: COpenSSLURL, majorVersion: 0, minor: 2),
      .Package(url: "https://github.com/czechboy0/Environment.git", majorVersion: 0),
    ]
)
//.Package(url: "https://github.com/Zewo/Zewo.git", majorVersion: 0, minor: 4),
