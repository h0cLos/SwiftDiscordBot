//
// Created on 2022/8/15.
//

import Foundation
import Sword

extension BotViewModel {
    func bonus(message data: MessageCommand) {
        guard let optional = data.optional,
              let now = Int(optional) else {
            sendMessage.accept(.init(channel: data.message.channel,
                                     messageString: ":mag_right:" + " 內容有誤，請再次確認"))
            return
        }
        
        var bonusString: String? {
            switch data.command {
            case .AP:
                let list = BonusAP
                    .allCases
                    .filter { now >= $0.rawValue }
                
                guard list.isNotEmpty, let last = list.last else { return "沒有套用獎勵攻擊力" }
                
                let scope = "(\(last.rawValue)~" + last.maxAP + ")"
                let bonusAttack = "套用獎勵攻擊力 `\(last.bonusAttack)`"
                return "AP `" + optional + "` " + scope + "，" + bonusAttack
            case .DP:
                let list = BonusDP
                    .allCases
                    .filter { now >= $0.rawValue }
                
                guard list.isNotEmpty, let last = list.last else { return "沒有套用追加傷害減少" }
                
                let scope = "(\(last.rawValue)~" + last.maxDP + ")"
                let bonusDefense = "套用追加傷害減少 `\(last.bonusDefense)` %"
                return "DP `" + optional + "` " + scope + "，" + bonusDefense
            default:
                return nil
            }
        }
        
        guard let messageString = bonusString else { return }
        
        sendMessage.accept(.init(channel: data.message.channel,
                                 messageString: ":clipboard: " + messageString))
    }
}
