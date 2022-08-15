//
// Created on 2022/8/15.
//

import Foundation
import Sword

extension BotViewModel {
    func bonusAP(message data: MessageCommand) {
        guard let messageBody = data.optional,
              let nowAP = Int(messageBody) else {
            sendMessage.accept(.init(channel: data.message.channel,
                                     messageString: ":mag_right:" + " 內容有誤，請再次確認"))
            return
        }
        
        let bonusList = BonusAP
            .allCases
            .filter { nowAP >= $0.rawValue }
        
        guard bonusList.isNotEmpty,
              let last = bonusList.last else {
            sendMessage.accept(.init(channel: data.message.channel,
                                     messageString: ":clipboard:" + " 沒有套用獎勵攻擊力"))
            return
        }
        
        let apScope = "(\(last.rawValue)~" + last.maxAP + ")"
        let apBonusAttack = "套用獎勵攻擊力 `\(last.bonusAttack)`"
        
        sendMessage.accept(.init(channel: data.message.channel,
                                 messageString: ":clipboard:" + " AP `" + messageBody + "` " + apScope + "，" + apBonusAttack))
    }
    
    func bonusDP(message data: MessageCommand) {
        guard let messageBody = data.optional,
              let nowDP = Int(messageBody) else {
            sendMessage.accept(.init(channel: data.message.channel,
                                     messageString: ":mag_right:" + " 內容有誤，請再次確認"))
            return
        }
        
        let bonusList = BonusDP
            .allCases
            .filter { nowDP >= $0.rawValue }
        
        guard bonusList.isNotEmpty,
              let last = bonusList.last else {
            sendMessage.accept(.init(channel: data.message.channel,
                                     messageString: ":clipboard:" + " 沒有套用追加傷害減少"))
            return
        }
        
        let dpScope = "(\(last.rawValue)~" + last.maxDP + ")"
        let dpBonusDefense = "套用追加傷害減少 `\(last.bonusDefense)` %"
        
        sendMessage.accept(.init(channel: data.message.channel,
                                 messageString: ":clipboard:" + " DP `" + messageBody + "` " + dpScope + "，" + dpBonusDefense))
    }
}
