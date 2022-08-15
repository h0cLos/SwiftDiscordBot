//
// Created on 2022/8/15.
//

import Foundation
import Sword

extension BotViewModel {
    func unknown(channel: TextChannel) {
        send.accept(.init(channel: channel,
                          messageString: "<:thuunk:987231279063904286>" + " 找不到相關指令"))
    }
}
