//
// Created on 2022/8/15.
//

import Foundation
import Sword

extension BotViewModel {
    func bonusAP(messageBody: String?, channel: TextChannel) {
        guard let messageBody = messageBody,
              let nowAP = Int(messageBody) else {
            send.accept(.init(channel: channel,
                              messageString: ":mag_right:" + " 內容有誤，請再次確認"))
            return
        }
        
        let bonusList = BonusAP
            .allCases
            .filter { nowAP >= $0.rawValue }
        
        guard bonusList.isNotEmpty,
              let last = bonusList.last else {
            send.accept(.init(channel: channel,
                              messageString: ":clipboard:" + " 沒有套用獎勵攻擊力"))
            return
        }
        
        let apScope = "(\(last.rawValue)~" + last.maxAP + ")"
        let apBonusAttack = "套用獎勵攻擊力 `\(last.bonusAttack)`"
        
        send.accept(.init(channel: channel,
                          messageString: ":clipboard:" + " AP `" + messageBody + "` " + apScope + "，" + apBonusAttack))
    }
    
    func bonusDP(messageBody: String?, channel: TextChannel) {
        guard let messageBody = messageBody,
              let nowDP = Int(messageBody) else {
            send.accept(.init(channel: channel,
                              messageString: ":mag_right:" + " 內容有誤，請再次確認"))
            return
        }
        
        let bonusList = BonusDP
            .allCases
            .filter { nowDP >= $0.rawValue }
        
        guard bonusList.isNotEmpty,
              let last = bonusList.last else {
            send.accept(.init(channel: channel,
                              messageString: ":clipboard:" + " 沒有套用追加傷害減少"))
            return
        }
        
        let dpScope = "(\(last.rawValue)~" + last.maxDP + ")"
        let dpBonusDefense = "套用追加傷害減少 `\(last.bonusDefense)` %"
        
        send.accept(.init(channel: channel,
                          messageString: ":clipboard:" + " DP `" + messageBody + "` " + dpScope + "，" + dpBonusDefense))
    }
}
