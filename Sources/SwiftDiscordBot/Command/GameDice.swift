//
// Created on 2022/8/15.
//

import Foundation
import Sword

extension BotViewModel {
    func gameDice(channel: TextChannel) {
        let secondsItem = Array(1...28).shuffled()
        let probabilityItem: [ProbabilityItem<String>] = secondsItem
            .map { .init(item: String(format: "%02d", $0), percent: 1) }
        
        guard let random = random(in: probabilityItem) else { return }
        
        send.accept(.init(channel: channel,
                          messageString: ":game_die:" + " `" + random.item + "` 秒"))
    }
}
