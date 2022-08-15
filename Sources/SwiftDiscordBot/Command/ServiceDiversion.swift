//
// Created on 2022/8/15.
//

import Foundation
import Sword

extension BotViewModel {
    func serviceDiversionList(message data: MessageCommand) {
        let serviceDiversionList = ServiceDiversion
            .allCases
            .filter { $0.isActive }
            .map { $0.formatName }
        
        sendMessage.accept(.init(channel: data.message.channel,
                                 messageId: nil,
                                 messageString: serviceDiversionList.joined(separator: "\n")))
    }
    
    func serviceDiversion(message data: MessageCommand) {
        var isHutton: Bool {
            return data.command == .赫敦
        }
        
        let probabilityItem: [ProbabilityItem<ServiceDiversion>] = ServiceDiversion
            .allCases
            .filter { $0.isActive }
            .filter { isHutton ? $0.isHutton : true }
            .map { .init(item: $0, percent: 10) }
        
        guard let random = random(in: probabilityItem) else { return }
        
        sendMessage.accept(.init(channel: data.message.channel,
                                 messageId: nil,
                                 messageString: random.item.formatName))
    }
}

private extension ServiceDiversion {
    /// 格式化名稱
    var formatName: String {
        var replyName = ":map: `" + name + "`"
        
        guard isHutton else {
            return replyName
        }
        
        guard isPvp else {
            replyName += " :microbe:"
            return replyName
        }
        
        replyName += " :crossed_swords: :microbe:"
        return replyName
    }
}
