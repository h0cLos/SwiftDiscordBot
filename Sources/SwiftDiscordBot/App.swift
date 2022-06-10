//
//  Created on 2022/2/21.
//

import Foundation
import Sword
import Yams

struct App {
    static let prefixString = "!"
    static let nickname = environment["NICKNAME"] ?? "debugMode"
    static let playing = "弄壞玩家易碎的心"
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
