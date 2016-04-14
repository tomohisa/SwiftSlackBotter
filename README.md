# SwiftSlackBotter
Slack Bot Framework for Swift Linux Command Line 
Created by J-Tech Creations, Inc.
---
SwiftSlackBotter is Bot framework made for swift. Currently using Swift Version DEVELOPMENT-SNAPSHOT-2016-02-08-a released by Apple. Using Zewo 0.3 Frameworks and Environment 0.1 Frameworks.

- [Zewo](https://github.com/Zewo/Zewo)
- [Environment](https://github.com/czechboy0/Environment)

# How to Setup Environment
On this Readme, it focues for OSX El Capitan, but please see each sofware explains how on linux as well (I still haven't try on linux)

## Install Homebrew (If you have not already done it)

[Homebrew](http://brew.sh/) is a package manager for OS X.

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## Install Swift Env
[SwiftEnv](https://github.com/kylef/swiftenv) is a swift version manager to select swift snapshot by user / folder. Since Swift Slack Botter uses DEVELOPMENT-SNAPSHOT-2016-02-08-a (Older Version), I reccomend you to use this to be able to choose specific Swift Runtime

You can install swiftenv using the [Homebrew](http://brew.sh/) package manager
on OS X.

1. Install swiftenv

    ```shell
    $ brew install kylef/formulae/swiftenv
    ```

2. Then configure the shims and completions by adding the following to your profile.

    For Bash:

    ```shell
    $ echo 'if which swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi' >> ~/.bash_profile
    ```

    **NOTE**: *On some platforms, you may need to modify `~/.bashrc` instead of `~/.bash_profile`.*

    For ZSH:

    ```shell
    $ echo 'if which swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi' >> ~/.zshrc
    ```

    For Fish:

    ```shell
    $ echo 'status --is-interactive; and . (swiftenv init -|psub)' >> ~/.config/fish/config.fish
    ```

## Install Apple Swift Package
Using SwiftEnv install Snapshot of Feb 8

```shell
$ swiftenv install 2.2-SNAPSHOT-2016-02-08-a
```

## Install Zewo Runtime
Zewo is web framework for swift, it is under development to adopt each latest swift snapshot. Currently Swift Slack Botter uses version 0.3. Please see how to install on their [Documents](https://github.com/Zewo/Zewo)

```sh
brew install zewo/tap/zewo
```

Now we should be ready to create your own bot.
# Create your first swift bot
First we need to create a directory for our app.

```sh
mkdir SwiftBotSample && cd SwiftBotSample
```

Then we install Swift Development Snapshot from **February 8, 2016**.

```sh
swiftenv install DEVELOPMENT-SNAPSHOT-2016-02-08-a
swiftenv local DEVELOPMENT-SNAPSHOT-2016-02-08-a
```

Now we initialize the project with Swift Package Manager (**SPM**).

```sh
$ swift build --init
Creating Package.swift
Creating .gitignore
Creating Sources/
Creating Sources/main.swift
Creating Tests/
```

This command will create the basic structure for our app.

```
.
├── Package.swift
├── Sources
│   └── main.swift
└── Tests
```

Open `Package.swift` with your favorite editor and add `HTTPServer`, `Router` as dependencies.

```swift
import PackageDescription

let package = Package(
    name: "SwiftBotSample",
    dependencies: [
      .Package(url: "https://github.com/tomohisa/SwiftSlackBotter.git", majorVersion: 0, minor: 1),
    ]
)
```

Now you can write code for your bot. Edit `Sources/main.swift` Simple Bot Server code would be like this.

```swift
import SwiftSlackBotter

do {
  let bot : Bot = try Bot()
  bot.addObserver(DefaultEventObserver(onMessage:{
    (message:MessageEvent,bot:Bot) in
    try bot.reply("hello - " + bot.botInfo.userRealNameFor(message.user),event:message)
  }))
  try bot.start()
} catch let error {
  print("Error Occured \(error)")
}
```

### This code:

- Connect  [rtm.start method | Slack ](https://api.slack.com/methods/rtm.start) method to retrieve websocket URL
- Connect Slack with WebSocket as Bot
- Receive message as bot
- If bot receive message, it reply hello - (name of user who commented)

Very simple bot eh.

### Slack Preperation 

- Create Bot User and Copy Tokens [Bot Users | Slack] (https://api.slack.com/bot-users) 
- Save Token in Environment Value (Add following code in `~/.bash_profile` file)

```sh
export SLACK_BOT_TOKEN=xoxb-YOUR_SLACK_TOKEN
```

- Restart Terminal would be required.

### Build and run

Now let's build the app.

```sh
swift build -Xcc -I/usr/local/include -Xlinker -L/usr/local/lib
```

As of 2016/4/14, command line output is following
```
Cloning https://github.com/tomohisa/SwiftSlackBotter.git
Using version 0.1.8 of package SwiftSlackBotter
Cloning https://github.com/Zewo/WebSocket.git
Using version 0.3.1 of package WebSocket
Cloning https://github.com/Zewo/HTTP.git
Using version 0.3.0 of package HTTP
Cloning https://github.com/Zewo/Stream.git
Using version 0.2.0 of package Stream
Cloning https://github.com/Zewo/Data.git
Using version 0.2.2 of package Data
Cloning https://github.com/Zewo/System.git
Using version 0.2.0 of package System
Cloning https://github.com/Zewo/MediaType.git
Using version 0.3.1 of package MediaType
Cloning https://github.com/Zewo/InterchangeData.git
Using version 0.3.0 of package InterchangeData
Cloning https://github.com/Zewo/URI.git
Using version 0.2.0 of package URI
Cloning https://github.com/Zewo/CURIParser.git
Using version 0.2.0 of package CURIParser
Cloning https://github.com/Zewo/String.git
Using version 0.2.6 of package String
Cloning https://github.com/Zewo/CHTTPParser.git
Using version 0.2.0 of package CHTTPParser
Cloning https://github.com/Zewo/HTTPClient.git
Using version 0.3.0 of package HTTPClient
Cloning https://github.com/Zewo/TCP.git
Using version 0.2.2 of package TCP
Cloning https://github.com/Zewo/IP.git
Using version 0.2.1 of package IP
Cloning https://github.com/Zewo/Venice.git
Using version 0.2.2 of package Venice
Cloning https://github.com/Zewo/CLibvenice.git
Using version 0.2.0 of package CLibvenice
Cloning https://github.com/Zewo/HTTPSClient.git
Using version 0.3.0 of package HTTPSClient
Cloning https://github.com/Zewo/TCPSSL.git
Using version 0.2.0 of package TCPSSL
Cloning https://github.com/Zewo/OpenSSL.git
Using version 0.2.4 of package OpenSSL
Cloning https://github.com/Zewo/COpenSSL-OSX.git
Using version 0.2.0 of package COpenSSL-OSX
Cloning https://github.com/Zewo/File.git
Using version 0.2.5 of package File
Cloning https://github.com/Zewo/Event.git
Using version 0.2.0 of package Event
Cloning https://github.com/Zewo/Base64.git
Using version 0.2.1 of package Base64
Cloning https://github.com/Zewo/JSON.git
Using version 0.3.1 of package JSON
Cloning https://github.com/czechboy0/Environment.git
Using version 0.1.0 of package Environment
Cloning https://github.com/Zewo/Log.git
Using version 0.3.0 of package Log
Compiling Swift Module 'System' (1 sources)
Linking Library:  .build/debug/System.a
Compiling Swift Module 'Data' (1 sources)
Linking Library:  .build/debug/Data.a
Compiling Swift Module 'Stream' (1 sources)
Linking Library:  .build/debug/Stream.a
Compiling Swift Module 'InterchangeData' (1 sources)
Linking Library:  .build/debug/InterchangeData.a
Compiling Swift Module 'MediaType' (1 sources)
Linking Library:  .build/debug/MediaType.a
Compiling Swift Module 'String' (1 sources)
Linking Library:  .build/debug/String.a
Compiling Swift Module 'URI' (1 sources)
Linking Library:  .build/debug/URI.a
Compiling Swift Module 'HTTP' (23 sources)
Linking Library:  .build/debug/HTTP.a
Compiling Swift Module 'Venice' (16 sources)
Linking Library:  .build/debug/Venice.a
Compiling Swift Module 'IP' (2 sources)
Linking Library:  .build/debug/IP.a
Compiling Swift Module 'TCP' (7 sources)
Linking Library:  .build/debug/TCP.a
Compiling Swift Module 'HTTPClient' (1 sources)
Linking Library:  .build/debug/HTTPClient.a
Compiling Swift Module 'File' (3 sources)
Linking Library:  .build/debug/File.a
Compiling Swift Module 'OpenSSL' (15 sources)
Linking Library:  .build/debug/OpenSSL.a
Compiling Swift Module 'TCPSSL' (2 sources)
Linking Library:  .build/debug/TCPSSL.a
Compiling Swift Module 'HTTPSClient' (1 sources)
Linking Library:  .build/debug/HTTPSClient.a
Compiling Swift Module 'Event' (2 sources)
Linking Library:  .build/debug/Event.a
Compiling Swift Module 'Base64' (1 sources)
Linking Library:  .build/debug/Base64.a
Compiling Swift Module 'WebSocket' (5 sources)
Linking Library:  .build/debug/WebSocket.a
Compiling Swift Module 'JSON' (5 sources)
Linking Library:  .build/debug/JSON.a
Compiling Swift Module 'Environment' (1 sources)
Linking Library:  .build/debug/Environment.a
Compiling Swift Module 'EnvironmentTests' (1 sources)
/Users/tomohisa/Desktop/SwiftBotSample/Packages/Environment-0.1.0/Sources/EnvironmentTests/main.swift:9:63: warning: __FUNCTION__ is deprecated and will be removed in Swift 3, please use #function
        guard let path = Environment().getVar("PATH") else { return (__FUNCTION__, false) }
                                                                     ^~~~~~~~~~~~
                                                                     #function
/Users/tomohisa/Desktop/SwiftBotSample/Packages/Environment-0.1.0/Sources/EnvironmentTests/main.swift:10:10: warning: __FUNCTION__ is deprecated and will be removed in Swift 3, please use #function
        return (__FUNCTION__, !path.isEmpty)
                ^~~~~~~~~~~~
                #function
/Users/tomohisa/Desktop/SwiftBotSample/Packages/Environment-0.1.0/Sources/EnvironmentTests/main.swift:16:10: warning: __FUNCTION__ is deprecated and will be removed in Swift 3, please use #function
        return (__FUNCTION__, val == "FUZZY")
                ^~~~~~~~~~~~
                #function
/Users/tomohisa/Desktop/SwiftBotSample/Packages/Environment-0.1.0/Sources/EnvironmentTests/main.swift:22:40: warning: __FUNCTION__ is deprecated and will be removed in Swift 3, please use #function
        guard val == "FUZZIER" else { return (__FUNCTION__, false) }
                                              ^~~~~~~~~~~~
                                              #function
/Users/tomohisa/Desktop/SwiftBotSample/Packages/Environment-0.1.0/Sources/EnvironmentTests/main.swift:25:10: warning: __FUNCTION__ is deprecated and will be removed in Swift 3, please use #function
        return (__FUNCTION__, valFinal == nil)
                ^~~~~~~~~~~~
                #function
Linking Executable:  .build/debug/EnvironmentTests
Compiling Swift Module 'Log' (1 sources)
Linking Library:  .build/debug/Log.a
Compiling Swift Module 'SwiftSlackBotter' (12 sources)
Linking Library:  .build/debug/SwiftSlackBotter.a
Compiling Swift Module 'SwiftBotSample' (1 sources)
Linking Executable:  .build/debug/SwiftBotSample
```



After it compiles, run it.

```sh
.build/debug/SwiftBotSample
```

Bot Start Running and bot user in Slack become Green. There are two way to talk to Bot.

- Direct Message to Bot (Select Bot user to talk)
- Invite Bot to Public or Private Channel

Now if you talk anything in channel or Direct Message bot can listen, Bot reply and call your name like following image.

!https://dl.dropboxusercontent.com/u/1157820/botsample.png

## Roadmap
This framework is building for specific project so it's not general-perpose use *Yet*. I am trying to make extensible and flexible using swift's closures and protocols. I want to make folloing feature if possible.

- conversation defenetion 
- timer actitity
- app support

Thanks to Apple Swift Team and Zero/OpenSwift Team for this super cool programing and server enviromental framework!
