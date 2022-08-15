//
// Created on 2022/4/21.
//

import Foundation
import Sword
import RxSwift
import RxCocoa

protocol BotViewModelIntput {
    /// 機器人收到的新訊息
    func newMessage(_ message: Message, prefixString: String)
    /// 讀取世界王班表
    func bossSchedule()
}

protocol BotViewModelOutput {
    var send: PublishRelay<BotViewModel.messageContent> { get }
}

protocol BotViewModelPrototype {
    var sets: BotViewModelIntput { get }
    var gets: BotViewModelOutput { get }
}

class BotViewModel: BotViewModelPrototype {
    /// 隨機物件
    struct ProbabilityItem<T> {
        /// 物件
        let item: T
        /// 機率
        let percent: Int
    }
    /// 機器人回覆訊息
    struct messageContent {
        /// 傳送的頻道
        let channel: TextChannel
        /// 訊息內容
        let messageString: String
    }
    /// 訊息快取
    struct CacheMessage {
        /// 用戶 id
        let userId: UInt64
        /// 訊息內容
        let messageString: String
        /// 接收的訊息格式
        let commandMessage: Message
    }
    /// 世界王通知頻道
    struct BossNoticeChannel: TextChannel {
        let lastMessageId: Snowflake?
        let sword: Sword?
        let id: Snowflake
        let type: ChannelType
    }
    /// 世界王日行程
    struct BossDaySchedule {
        let boss: Boss
        let schedule: [ScheduleModel]
    }
    /// 世界王日行程 (梳理)
    struct BossSordDaySchedule {
        let boss: Boss
        let schedule: [ScheduleTimesModel]
    }
    /// 世界王當日時間行程
    struct BossTimeSchedule {
        let boss: [Boss]
        let times: Int
    }
    
    var sets: BotViewModelIntput { return self }
    var gets: BotViewModelOutput { return self }
    /// 世界王 model
    var bossScheduleModel: BossScheduleModel?
    /// 世界王通知快取訊息
    var bossNoticeCache: [CacheMessage] = []
    /// 運勢快取訊息
    var omikujiCache: [CacheMessage] = []
    
    let sword: Sword
    let send = PublishRelay<messageContent>()
    
    required init(_ sword: Sword) {
        self.sword = sword
    }
}

extension BotViewModel: BotViewModelIntput, BotViewModelOutput {
    func newMessage(_ message: Message, prefixString: String) {
        let messageContent = message.content
        
        // 檢查字首是否為指令符號
        guard messageContent.hasPrefix(prefixString) else { return }
        
        let messageContentArrays = messageContent
            .replacingOccurrences(of: prefixString, with: "")
            .split(separator: " ", maxSplits: 1)
            .map { String($0) }
        
        // 指令
        guard let messageCommand = messageContentArrays.first,
              let command = Bot.Command(rawValue: messageCommand.uppercased()) else {
            unknown(channel: message.channel)
            return
        }
        
        // 指令後帶的內容
        var messageBody: String? {
            guard messageContentArrays.count > 1,
                  let body = messageContentArrays.last else { return nil }
            
            return body
        }
        
        switch command {
        case .幫助:
            help(channel: message.channel)
        case .序號:
            serialNumber(messageBody: messageBody,
                         channel: message.channel)
        case .分流列表:
            serviceDiversionList(channel: message.channel)
        case .分流, .赫敦:
            serviceDiversion(command: command,
                             channel: message.channel)
        case .骰子, .退坑:
            gameDice(channel: message.channel)
        case .世界王, .世界王檢查:
            boss(messageBody: messageBody,
                 command: command,
                 message: message)
        case .運勢:
            omikuji(message: message)
        case .AP:
            bonusAP(messageBody: messageBody,
                    channel: message.channel)
        case .DP:
            bonusDP(messageBody: messageBody,
                    channel: message.channel)
        case .測試:
            App.log("\(message)")
        }
    }
    
    func bossSchedule() {
        guard let data = bossJson else { return }
        
        do {
            bossScheduleModel = try JSONDecoder().decode(BossScheduleModel.self, from: data)
        } catch {
            assert(false, "\(error)")
        }
    }
}

extension BotViewModel {
    /// 隨機列出一則內容
    func random<T>(in: [ProbabilityItem<T>]) -> ProbabilityItem<T>? {
        var percentSum = `in`
            .map { $0.percent }
            .reduce(0) { $0 + $1 }
        
        for item in `in` {
            let randNum = Int.random(in: 1 ..< percentSum)
            let percent = item.percent
            
            guard randNum <= percent else {
                percentSum -= percent
                continue
            }
            
            return item
        }
        
        return nil
    }
}
