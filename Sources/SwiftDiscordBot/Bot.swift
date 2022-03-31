//
//  Created on 2022/2/21.
//

import Foundation
import Sword

class Bot: Sword {
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
        /// 查詢指令
        case help
        case 分流
        case 分流列表
        case 赫敦
        case 骰子
        case 退坑
    }
    /// 分流
    enum ServiceDiversion: String, CaseIterable {
        case 阿勒沙
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
        case 璐璐飛_3
        case 璐璐飛_4
        case 璐璐飛_5
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
        /// 是否為赫敦分流
        var isHutton: Bool {
            switch self {
            case .阿勒沙:
                fallthrough
            case .梅迪亞_2, .梅迪亞_3:
                fallthrough
            case .卡爾佩恩_2:
                fallthrough
            case .卡瑪希爾比亞_2, .卡瑪希爾比亞_3:
                fallthrough
            case .巴雷諾斯_2, .巴雷諾斯_3:
                fallthrough
            case .瓦倫西亞_2:
                fallthrough
            case .賽林迪亞_2, .賽林迪亞_3:
                return true
            default:
                return false
            }
        }
        /// 是否為 PVP 分流
        var isPvp: Bool {
            switch self {
            case .阿勒沙:
                return true
            default:
                return false
            }
        }
    }
    /// 世界王
    enum Boss: String, Codable {
        case 克價卡
        case 庫屯
        case 卡嵐達
        case 羅裴勒
        case 奧平
        case 貝爾
        case 卡莫斯
        case 肯恩特_木拉卡
    }
    
    init(token: String) {
        super.init(token: token)
        
        bind()
        
        loadData()
        
        App.log("is online and playing \(App.playing).")
    }
    
    /// 世界王日程表 model
    private var bossScheduleModel: BossScheduleModel?
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
    func loadData() {
        guard let data = bossJson else { return }
        
        do {
            bossScheduleModel = try JSONDecoder().decode(BossScheduleModel.self, from: data)
        } catch {
            assert(false, "\(error)")
        }
    }
    
    func serviceDiversionNameFormat(_ diversion: ServiceDiversion) -> String {
        var replyMessage = ":map: `" + diversion.name + "`"
        
        guard diversion.isHutton else {
            return replyMessage
        }

        guard diversion.isPvp else {
            replyMessage += " :microbe:"
            return replyMessage
        }

        replyMessage += " :crossed_swords: :microbe:"
        return replyMessage
    }
    
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
        
        on(.messageCreate) { [weak self] in
            let probability = Probability()
            
            guard let self = self,
                  let message = $0 as? Message else { return }
            
            let content = message.content
            
            guard content.hasPrefix(App.prefixString) else { return }
            
            let command = content.replacingOccurrences(of: App.prefixString, with: "")
            
            guard let botCommand = BotCommand(rawValue: command) else { return }
            
            switch botCommand {
            case .help:
                let helpMessage = """
                    ```
                    目前開放指令
                    隨機分流: !分流
                    隨機赫敦分流: !赫敦
                    隨機秒數: !骰子、!退坑
                    ```
                    """
                
                message.reply(with: helpMessage)
            case .分流, .赫敦:
                var isHutton: Bool {
                    guard case let command = botCommand, command == .赫敦 else {
                        return false
                    }
                    
                    return true
                }
                
                let probabilityItem: [Probability.ProbabilityItem<ServiceDiversion>] = ServiceDiversion
                    .allCases
                    .filter { isHutton ? $0.isHutton : true }
                    .map { .init(item: $0, percent: 1) }
                
                guard let random = probability.random(in: probabilityItem) else { return }
                
                message.reply(with: self.serviceDiversionNameFormat(random.item))
            case .分流列表:
                let diversionList = ServiceDiversion
                    .allCases
                    .map { [weak self] item -> String in
                        self?.serviceDiversionNameFormat(item) ?? .init()
                    }
                
                message.reply(with: diversionList.joined(separator: "\n"))
            case .骰子, .退坑:
                let secondsItem = Array(1...28).shuffled()
                let probabilityItem: [Probability.ProbabilityItem<String>] = secondsItem
                    .map { .init(item: String($0), percent: 1) }
                
                guard let random = probability.random(in: probabilityItem) else { return }
                
                message.reply(with: ":game_die:" + " `" + random.item + "秒`")
            }
        }
    }
}
