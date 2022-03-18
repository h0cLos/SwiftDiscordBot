//
//  Created on 2022/2/21.
//

#if os(Linux)

import Foundation
import Sword
import Yams

struct App {
    static let prefixString = "!"
    static let nickname = environment["NICKNAME"] ?? "debugMode"
    static let playing = "弄壞玩家的裝備"
    static let bot = Bot(token: discordToken)
    
    // private
    private static let environment = ProcessInfo.processInfo.environment
    private static let discordToken = { () -> String in
        guard let discordToken = environment["DISCORD_TOKEN"],
              !discordToken.isEmpty else {
            fatalError("Can't find `DISCORD_TOKEN` environment variable!")
        }
        
        return discordToken
    }()
    
    static func log(_ message: String) {
        print("🤖 " + message)
    }
}

#else

import Foundation
import Sword

struct App {
    static let prefixString = "!"
    static let nickname = environment["NICKNAME"] ?? "debugMode"
    static let playing = "Xcode for macOS"
    static let bot = Bot(token: discordToken)
    
    // private
    private static let environment = ProcessInfo.processInfo.environment
    private static let discordToken = { () -> String in
        return "OTQ0NTk2MTQ2MzI2NzYxNDcy.YhD5tw.ZAMfQX482IbJzZCLk6bIiFODQyc"
    }()
    
    static func log(_ message: String) {
        print("🤖 " + message)
    }
}

#endif
