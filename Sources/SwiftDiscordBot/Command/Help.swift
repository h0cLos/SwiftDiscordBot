//
// Created on 2022/8/15.
//

import Foundation
import Sword

extension BotViewModel {
    func help(channel: TextChannel) {
        // 普通指令
        let commandHelp = Bot.Command
            .allCases
            .filter { $0.isPresent }
            .filter { !$0.isTest }
            .map { ":bulb: `\(App.prefixString)\($0)` - `\($0.description)`" }
        
        // 測試指令
        let commandTest = Bot.Command
            .allCases
            .filter { $0.isPresent }
            .filter { $0.isTest }
            .map { ":hammer_pick: `\(App.prefixString)\($0)` - `\($0.description)`" }
        
        send.accept(.init(channel: channel,
                          messageString: (commandHelp + commandTest).joined(separator: "\n")))
    }
}
