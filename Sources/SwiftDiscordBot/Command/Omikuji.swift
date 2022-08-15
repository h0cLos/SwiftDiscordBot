//
// Created on 2022/8/15.
//

import Foundation
import Sword

extension BotViewModel {
    func omikuji(message: Message) {
        guard let user = message.author else { return }
        
        let cacheItems = omikujiCache
            .first { $0.userId == user.id.rawValue }
        
        if let item = cacheItems {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.second],
                                                     from: item.commandMessage.timestamp,
                                                     to: message.timestamp)
            
            // 快取十五分鐘
            guard let second = components.second, second > 900 else {
                sendMessage.accept(.init(channel: message.channel,
                                         messageString: item.messageString))
                
                return
            }
            
            let cacheItemFirst = omikujiCache
                .firstIndex { $0.userId == user.id.rawValue }
            
            guard let firstIndex = cacheItemFirst else { return }
            
            omikujiCache.remove(at: firstIndex)
        }
        
        let probabilityItem: [ProbabilityItem<Omikuji>] = Omikuji
            .allCases
            .map { .init(item: $0, percent: $0.percent) }
        
        guard let random = random(in: probabilityItem) else { return }
        
        var emoji: String {
            switch random.item {
            case .超級大吉:
                return ":chart_with_upwards_trend:"
            case .大凶:
                return ":chart_with_downwards_trend:"
            default:
                return ":crystal_ball:"
            }
        }
        
        let messageString = emoji + " 當前運勢" + " `" + random.item.rawValue + "`"
        
        omikujiCache.append(.init(userId: user.id.rawValue,
                                  messageString: messageString,
                                  commandMessage: message))
        
        sendMessage.accept(.init(channel: message.channel,
                                 messageString: messageString))
    }
}
