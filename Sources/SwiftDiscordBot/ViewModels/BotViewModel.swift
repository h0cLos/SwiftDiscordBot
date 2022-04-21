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
    func setBossSchedule()
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
    
    let send = PublishRelay<messageContent>()
    
    required init(_ sword: Sword) {
        self.sword = sword
    }

    /// 世界王 model
    private var bossScheduleModel: BossScheduleModel?
    /// 運勢快取訊息
    private var cacheOmikujiArrays: [CacheMessage] = []
    
    private let sword: Sword
}

extension BotViewModel: BotViewModelIntput {
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
              let command = Bot.Command(rawValue: messageCommand) else { return }
        
        // 指令後帶的內容
        var messageBody: String {
            guard messageContentArrays.count > 1,
                  let body = messageContentArrays.last else {
                      return .init()
                  }
            
            return body
        }
        
        switch command {
        case .幫助:
            helpCommand(channel: message.channel)
        case .分流列表:
            serviceDiversionListCommand(channel: message.channel)
        case .季節, .分流, .赫敦:
            serviceDiversionCommand(command: command,
                                    channel: message.channel)
        case .骰子, .退坑:
            gameDiceCommand(channel: message.channel)
        case .運勢:
            omikujiCommand(message: message)
        case .序號:
            serialNumberCommand(messageBody: messageBody,
                                channel: message.channel)
        case .世界王, .世界王檢查:
            bossCommand(command: command, channel: message.channel)
        case .測試:
            App.log("\(message)")
        }
    }
    
    func setBossSchedule() {
        guard let data = bossJson else { return }
        
        do {
            bossScheduleModel = try JSONDecoder().decode(BossScheduleModel.self, from: data)
        } catch {
            assert(false, "\(error)")
        }
    }
}

extension BotViewModel: BotViewModelOutput {
    //
}

private extension ServiceDiversion {
    /// 格式化名稱
    var formatName: String {
        var replyName = ":map: `" + nickName + "`"
        
        guard !isSeason else {
            if isPvp {
                replyName += " :crossed_swords:"
            }
            
            return replyName
        }
        
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

private extension BotViewModel {
    func helpCommand(channel: TextChannel) {
        // 普通指令
        let commandHelp = Bot.Command
            .allCases
            .filter { $0.present }
            .filter { !$0.test }
            .map { ":bulb: `\(App.prefixString)\($0)` - `\($0.description)`" }
        
        // 測試指令
        let commandTest = Bot.Command
            .allCases
            .filter { $0.present }
            .filter { $0.test }
            .map { ":hammer_pick: `\(App.prefixString)\($0)` - `\($0.description)`" }
        
        send.accept(.init(channel: channel,
                          messageString: (commandHelp + commandTest).joined(separator: "\n")))
    }
    
    func serviceDiversionListCommand(channel: TextChannel) {
        let serviceDiversionList = ServiceDiversion
            .allCases
            .map { $0.formatName }
        
        send.accept(.init(channel: channel,
                          messageString: serviceDiversionList.joined(separator: "\n")))
    }
    
    func serviceDiversionCommand(command: Bot.Command, channel: TextChannel) {
        var isHutton: Bool {
            guard case let command = command,
                  command == .赫敦 else {
                      return false
                  }
            
            return true
        }
        
        var isSeason: Bool {
            guard case let command = command,
                  command == .季節 else {
                      return false
                  }
            
            return true
        }
        
        let probabilityItem: [ProbabilityItem<ServiceDiversion>] = ServiceDiversion
            .allCases
            .filter { isSeason ? $0.isSeason : true }
            .filter { isHutton ? $0.isHutton : true }
            .map { .init(item: $0, percent: 10) }
        
        guard let random = random(in: probabilityItem) else { return }
        
        send.accept(.init(channel: channel,
                          messageString: random.item.formatName))
    }
    
    func gameDiceCommand(channel: TextChannel) {
        let secondsItem = Array(1...28).shuffled()
        let probabilityItem: [ProbabilityItem<String>] = secondsItem
            .map { .init(item: String(format: "%02d", $0), percent: 1) }
        
        guard let random = random(in: probabilityItem) else { return }
        
        send.accept(.init(channel: channel,
                          messageString: ":game_die:" + " `" + random.item + "` 秒"))
    }
    
    func omikujiCommand(message: Message) {
        guard let user = message.author else { return }
        
        let cacheItems = cacheOmikujiArrays
            .first { $0.userId == user.id.rawValue }
        
        if let item = cacheItems {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.second],
                                                     from: item.commandMessage.timestamp,
                                                     to: message.timestamp)
            
            // 快取一個小時
            guard let second = components.second, second > 3600 else {
                send.accept(.init(channel: message.channel,
                                  messageString: item.messageString))
                
                return
            }
            
            let cacheItemFirst = cacheOmikujiArrays
                .firstIndex { $0.userId == user.id.rawValue }
            
            guard let firstIndex = cacheItemFirst else { return }
            
            cacheOmikujiArrays.remove(at: firstIndex)
        }
        
        let probabilityItem: [ProbabilityItem<Omikuji>] = Omikuji
            .allCases
            .map { .init(item: $0, percent: $0.percent) }
        
        guard let random = random(in: probabilityItem) else { return }
        
        var emoji: String {
            switch random.item {
            case .大吉:
                return ":chart_with_upwards_trend:"
            case .大凶:
                return ":chart_with_downwards_trend:"
            default:
                return ":crystal_ball:"
            }
        }
        
        let sendMessage = emoji + " 當前運勢" + " `" + random.item.rawValue + "`"
        
        cacheOmikujiArrays.append(.init(userId: user.id.rawValue,
                                        messageString: sendMessage,
                                        commandMessage: message))
        
        send.accept(.init(channel: message.channel,
                          messageString: sendMessage))
    }
    
    func serialNumberCommand(messageBody: String, channel: TextChannel) {
        let bodyArrays = messageBody.components(separatedBy: ",")
        
        guard bodyArrays.count > 2 else {
            send.accept(.init(channel: channel,
                              messageString: ":mag_right:" + " 內容有誤，請再次確認"))
            
            return
        }
        
        let messageContent = bodyArrays
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
        
        send.accept(.init(channel: channel,
                          messageString: ":keyboard:" + " 序號內容：\n" + "```\ndiff\n\(messageContent)```"))
    }
    
    func bossCommand(command: Bot.Command, channel: TextChannel) {
        func weekdayBossSchedule(weekday: WeekDay) -> [BossTimeSchedule] {
            guard let model = bossScheduleModel else { return [] }
            
            // 列出今日的世界王
            let todaySchedule: [BossDaySchedule] = model
                .boss
                .map {
                    let schedule = $0
                        .schedule
                        .filter { $0.weekday == weekday }
                    
                    return .init(boss: $0.boss,
                                 schedule: schedule)
                }
                .filter { !$0.schedule.isEmpty }
            
            // 整理今日的世界王的出席時間
            let sordBoss = todaySchedule
                .map { $0.schedule }
                .flatMap { $0 }
                .map { $0.times }
                .flatMap { $0 }
            
            let sordBossSecond: [BossTimeSchedule] = sordBoss
                .map { $0.hour * 60 * 60 + $0.minute * 60 }
                .unique()
                .map {
                    let second = $0
                    let sordBoss: [BossSordDaySchedule] = todaySchedule
                        .map {
                            let dayTimeSchedule = $0.schedule
                                .map {
                                    $0.times
                                        .filter { $0.hour * 60 * 60 + $0.minute * 60 == second }
                                }
                                .flatMap { $0 }
                            
                            return .init(boss: $0.boss,
                                         schedule: dayTimeSchedule)
                        }
                        .filter { !$0.schedule.isEmpty }
                    
                    return .init(boss: sordBoss.map { $0.boss },
                                 times: $0)
                }
                .sorted { $0.times < $1.times }
            
            return sordBossSecond
        }
        
        func closestBoss(weekday: WeekDay, nowSecond: Int) -> BossTimeSchedule? {
            let closestBossSchedule = weekdayBossSchedule(weekday: weekday)
                .filter { $0.times > nowSecond }

            guard closestBossSchedule.isEmpty else {
                return closestBossSchedule.first
            }

            // 今日世界王已經出完，獲取隔一日的列表
            let maxWeekdayRawValue = WeekDay
                .allCases
                .filter { $0 != .unknown }
                .map { $0.rawValue }
                .sorted { $0 > $1 }
                .first ?? WeekDay.unknown.rawValue

            var newWeekday: WeekDay {
                let newRawValue = weekday.rawValue + 1

                guard newRawValue > maxWeekdayRawValue else {
                    return WeekDay(rawValue: newRawValue) ?? .unknown
                }

                return .sunday
            }

            return weekdayBossSchedule(weekday: newWeekday).first
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)!
        
        let date = Date()
        let weekday = calendar.component(.weekday, from: date)
        let hourAndMinute = calendar.dateComponents([.hour, .minute], from: date)
        let nowSecond = hourAndMinute.hour! * 60 * 60 + hourAndMinute.minute! * 60
        
        guard let nowWeekday = WeekDay(rawValue: weekday),
              let bossSchedule = closestBoss(weekday: nowWeekday, nowSecond: nowSecond) else { return }
        
        let (hour, minuteSecond) = bossSchedule.times.quotientAndRemainder(dividingBy: 60 * 60)
        let (minute, _) = minuteSecond.quotientAndRemainder(dividingBy: 60)
        let bossTime = String(format: "%02d:%02d", hour, minute)
        let boss = bossSchedule
            .boss
            .map { "`\($0.name)`" }
            .joined(separator: "、")
        
        var isCheck: Bool {
            guard case let command = command, command == .世界王檢查 else {
                return false
            }
            
            return true
        }
        
        if isCheck {
            let bossNoticeContent = ":alarm_clock:" + " 世界王提醒 " + "`\(bossTime)`" + " \(boss)"
            let textChannel: BossNoticeChannel = .init(lastMessageId: nil,
                                                       sword: sword,
                                                       id: BossNoticeList.textChannel.id,
                                                       type: .guildText)
            
            guard 120...150 ~= bossSchedule.times - nowSecond else {
                return
            }
            
            send.accept(.init(channel: textChannel,
                              messageString: bossNoticeContent))
        } else {
            send.accept(.init(channel: channel,
                              messageString: ":stopwatch:" + " 下一批世界王 " + "`\(bossTime)`" + " \(boss)"))
        }
    }
    
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
