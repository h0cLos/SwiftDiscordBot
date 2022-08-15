//
// Created on 2022/8/15.
//

import Foundation
import Sword

extension BotViewModel {
    func serialNumber(message data: MessageCommand) {
        guard let bodyArrays = data.optional?.components(separatedBy: ","), bodyArrays.count > 2 else {
            sendMessage.accept(.init(channel: data.message.channel,
                                     messageString: ":mag_right:" + " 內容有誤，請再次確認"))
            
            return
        }
        
        let messageString = bodyArrays
            .enumerated()
            .map {
                switch $0.offset {
                case 0:
                    return "- \($0.element)"
                case 1:
                    return "+ \($0.element)"
                default:
                    let itemContent = $0.element
                    
                    var item: String {
                        let itemArrays = itemContent.components(separatedBy: ":")
                        
                        guard itemArrays.count > 1,
                              let itemName = itemArrays.first,
                              let count = itemArrays.last else { return "" }
                        
                        guard count != "1" else { return itemName }
                        
                        return "\(itemName) *\(count)"
                    }
                    
                    return "└⎯⎯ \(item)"
                }
            }
            .joined(separator: "\n")
        
        sendMessage.accept(.init(channel: data.message.channel,
                                 messageString: ":keyboard:" + " 序號內容：\n" + "```\ndiff\n\(messageString)```"))
    }
}
