//
//  Created on 2022/2/21.
//

import Foundation
import Sword

class Bot: Sword {
    /// 狀態
    enum Status: String {
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
    enum Command: String, CaseIterable {
        case 幫助
        case 測試
        case 分流列表
        case 分流
        case 赫敦
        case 骰子
        case 退坑
        /// 描述
        var description: String {
            switch self {
            case .幫助:
                return "顯示所有指令"
            case .測試:
                return "試錯階段指令"
            case .分流列表:
                return "顯示所有分流"
            case .分流:
                return "隨機挑選分流 (包含赫敦分流)"
            case .赫敦:
                return "隨機挑選赫敦分流"
            case .骰子:
                return "隨機挑選 1-28 的秒數"
            case .退坑:
                return "同指令「骰子」"
            }
        }
        /// 是否顯示
        var present: Bool {
            switch self {
            case .幫助, .測試:
                return false
            default:
                return true
            }
        }
    }
    
    init(token: String) {
        super.init(token: token)
        
        bind()
        loadData()
        
        App.log("is online and playing \(App.playing).")
    }
    /// 世界王日程表 model（未完成）
    private var bossScheduleModel: BossScheduleModel?
}

// 主體
extension Bot {
    /// 更變調整
    func status(to status: Status, playItem: String?) {
        guard let item = playItem else {
            editStatus(to: status.rawValue)
            return
        }
        
        editStatus(to: status.rawValue,
                   playing: item)
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
        
        on(.messageCreate) { [weak self] in
            let probability = Probability()
            
            guard let self = self,
                  let message = $0 as? Message,
                  let user = message.author,
                  let userName = user.username else { return }
            
            let isBot = user.isBot ?? false
            
            guard !isBot else { return }
            
            let content = message.content
            
            App.log("收到新訊息:「\(content)」來自「\(userName) (\(user.id))」於「\(message.timestamp)」。")
            
            guard content.hasPrefix(App.prefixString) else { return }
            
            let command = content.replacingOccurrences(of: App.prefixString, with: "")
            
            guard let botCommand = Command(rawValue: command) else { return }
            
            switch botCommand {
            case .幫助:
                let commandHelp = Command
                    .allCases
                    .filter { $0.present }
                    .map { ":bulb: `\(App.prefixString)\($0)` - `\($0.description)`" }
                
                message.reply(with: commandHelp.joined(separator: "\n"))
            case .測試:
                App.log("\(message)")
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
}
