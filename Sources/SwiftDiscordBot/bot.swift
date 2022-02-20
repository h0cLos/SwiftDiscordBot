//
//  Created on 2022/2/21.
//

import Foundation
import Sword

class Bot: Sword {
    init(token: String) {
        super.init(token: token)
        
        bind()
        
        App.log("is online and playing \(App.playing).")
    }
}

extension Bot {
    /// 狀態
    enum BotStatus: String {
        /// 在線
        case online
        /// 閒置
        case idle
        /// 請勿打擾
        case dnd
        /// 隱形
        case invisible
    }
    /// 指令
    enum BotCommand: String {
        case 分流
        case 赫敦
    }
}

extension Bot {
    /// 分流
    enum ServiceDiversion: String, CaseIterable {
        case 梅迪亞_1
        case 梅迪亞_2
        case 梅迪亞_3
        case 卡爾佩恩_1
        case 卡爾佩恩_2
        case 卡爾佩恩_3
        case 卡瑪希爾比亞_1
        case 卡瑪希爾比亞_2
        case 卡瑪希爾比亞_3
        case 巴雷諾斯_1
        case 巴雷諾斯_2
        case 巴雷諾斯_3
        case 璐璐飛_1
        case 璐璐飛_2
        case 阿勒沙
        case 瓦倫西亞_1
        case 瓦倫西亞_2
        case 瓦倫西亞_3
        case 賽林迪亞_1
        case 賽林迪亞_2
        case 賽林迪亞_3
        case 艾裴莉雅_1
        case 艾裴莉雅_2
        case 艾裴莉雅_3
        /// 名稱
        var name: String {
            return rawValue.replacingOccurrences(of: "_", with: "-")
        }
        /// 赫敦
        var hutton: Bool {
            switch self {
            case .梅迪亞_2, .梅迪亞_3,
                 .卡爾佩恩_2,
                 .卡瑪希爾比亞_2, .卡瑪希爾比亞_3,
                 .巴雷諾斯_2, .巴雷諾斯_3,
                 .阿勒沙,
                 .瓦倫西亞_2,
                 .賽林迪亞_2, .賽林迪亞_3:
                return true
            default:
                return false
            }
        }
    }
}

// 主體
extension Bot {
    /// 更變調整
    func status(to status: BotStatus, playItem: String?) {
        if let item = playItem {
            editStatus(to: status.rawValue, playing: item)
        } else {
            editStatus(to: status.rawValue)
        }
    }
}

private extension Bot {
    func bind() {
        on(.guildAvailable) { [weak self] in
            guard let self = self,
                  let guild = $0 as? Guild else { return }
            
            App.log("Guild Available: \(guild.name)")
            
            if guild.members[self.user!.id]?.nick != App.nickname {
                guild.setNickname(to: App.nickname) { error in
                    if let error = error {
                        App.log("failed to change nickname in guild: \(guild.name), error: \(error)")
                    }
                }
            }
        }
        
        on(.messageCreate) {
            let probability = Probability()
            
            guard let message = $0 as? Message else { return }
            
            let content = message.content
            
            guard content.hasPrefix(App.prefixString) else { return }
            
            let command = content.replacingOccurrences(of: App.prefixString, with: "")
            
            guard let botCommand = BotCommand(rawValue: command) else { return }
            
            switch botCommand {
            case .分流:
                let probabilityItem: [Probability.ProbabilityItem] = ServiceDiversion
                    .allCases
                    .map { .init(name: $0.name, percent: 1) }
                
                guard let item = probability.random(in: probabilityItem) else { return }
                
                message.reply(with: ":map:" + " `" + item.name + "`")
            case .赫敦:
                let probabilityItem: [Probability.ProbabilityItem] = ServiceDiversion
                    .allCases
                    .filter { $0.hutton }
                    .map { .init(name: $0.name, percent: 1) }
                
                guard let item = probability.random(in: probabilityItem) else { return }
                
                message.reply(with: ":microbe:" + " `" + item.name + "`")
            }
        }
    }
}
