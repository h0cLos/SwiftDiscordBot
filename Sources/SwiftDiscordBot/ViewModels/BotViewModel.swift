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
    var sendMessage: PublishRelay<BotViewModel.MessageContent> { get }
    var removeMessage: PublishRelay<BotViewModel.MessageContent> { get }
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
    struct MessageContent {
        /// 傳送的頻道
        let channel: TextChannel
        /// 訊息 Id
        let messageId: Snowflake?
        /// 訊息內容
        let messageString: String
    }
    /// 接收指令
    struct MessageCommand {
        /// 訊息本體
        let message: Message
        /// 指令
        let command: Bot.Command
        /// 指令 optional
        let optional: String?
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
    struct BossDaySchedule<T> {
        let boss: Boss
        let schedule: [T]
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
    let sendMessage = PublishRelay<MessageContent>()
    let removeMessage = PublishRelay<MessageContent>()
    
    required init(_ sword: Sword) {
        self.sword = sword
    }
}

extension BotViewModel: BotViewModelIntput, BotViewModelOutput {
    func newMessage(_ message: Message, prefixString: String) {
        let list = ChannelRemoveMessageList
            .allCases
            .map { $0.id }
        
        let messageContent = message.content
        let channelId = message.channel.id
        
        // 檢查字首是否為指令符號
        guard messageContent.hasPrefix(prefixString) else {
            // 檢查訊息是否為非機器人發送，非機器人 isBot 會是 nil
            guard !(message.author?.isBot ?? false) else { return }
            // 檢查該頻道是否在啟用名單內
            guard list.contains(channelId) else { return }
            // 刪除非指令文字
            removeMessage.accept(.init(channel: message.channel,
                                       messageId: message.id,
                                       messageString: messageContent))
            return
        }
        
        let messageContentArrays = messageContent
            .replacingOccurrences(of: prefixString, with: "")
            .split(separator: " ", maxSplits: 1)
            .map { String($0) }
        
        // 指令
        guard let messageContentPrefix = messageContentArrays.first,
              let command = Bot.Command(rawValue: messageContentPrefix.uppercased()) else {
            unknown(channel: message.channel)
            return
        }
        
        // 指令後帶的內容
        var messageBody: String? {
            guard messageContentArrays.count > 1,
                  let body = messageContentArrays.last else { return nil }
            
            return body
        }
        
        let messageCommand: MessageCommand = .init(message: message,
                                                   command: command,
                                                   optional: messageBody)
        
        switch command {
        case .幫助:
            help(message: messageCommand)
        case .序號:
            serialNumber(message: messageCommand)
        case .分流列表:
            serviceDiversionList(message: messageCommand)
        case .分流, .赫敦:
            serviceDiversion(message: messageCommand)
        case .骰子, .退坑:
            gameDice(message: messageCommand)
        case .世界王, .世界王檢查:
            boss(message: messageCommand)
        case .運勢:
            omikuji(message: messageCommand)
        case .AP, .DP:
            bonus(message: messageCommand)
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
