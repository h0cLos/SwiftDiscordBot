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
        case 分流列表
        case 分流
        case 赫敦
        case 季節
        case 骰子
        case 退坑
        case 世界王
        case 世界王檢查
        case 測試
        /// 描述
        var description: String {
            switch self {
            case .幫助:
                return "顯示所有指令"
            case .分流列表:
                return "顯示所有分流"
            case .分流:
                return "隨機挑選分流 (包含赫敦分流)"
            case .赫敦:
                return "隨機挑選赫敦分流"
            case .季節:
                return "隨機挑選季節分流"
            case .骰子:
                return "隨機挑選 1-28 的秒數"
            case .退坑:
                return "同指令「骰子」"
            case .世界王:
                return "告知最接近當前時間的世界王"
            case .世界王檢查:
                return "由觸發機器人觸發的檢查指令"
            case .測試:
                return "試錯階段指令"
            }
        }
        /// 是否顯示
        var present: Bool {
            switch self {
            case .幫助, .測試, .世界王檢查:
                return false
            default:
                return true
            }
        }
        /// 是否為測試
        var test: Bool {
            switch self {
            case .測試:
                return true
            default:
                return false
            }
        }
    }
    
    struct BossDaySchedule {
        let boss: Boss
        let schedule: [ScheduleModel]
    }
    
    struct BossSordDaySchedule {
        let boss: Boss
        let schedule: [ScheduleTimesModel]
    }
    
    struct BossTimeSchedule {
        let boss: [Boss]
        let times: Int
    }
    
    struct BossNoticeChannel: TextChannel {
        let lastMessageId: Snowflake?
        let sword: Sword?
        let id: Snowflake
        let type: ChannelType
    }
    
    init(token: String) {
        super.init(token: token)
        
        // 讀取世界王排程
        loadData()
        
        bind()
        
        App.log("is online and playing \(App.playing).")
    }

    /// 世界王日程表 model
    private var bossScheduleModel: BossScheduleModel?
    
    private let dateFormatter = DateFormatter() --> {
        $0.dateFormat = "'T'hh:mm'Z'"
    }
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
            
            let content = message.content
            
            guard content.hasPrefix(App.prefixString) else { return }
            
            let command = content.replacingOccurrences(of: App.prefixString, with: "")
            
            guard let botCommand = Command(rawValue: command) else { return }
            
            switch botCommand {
            case .幫助:
                let commandHelp = Command
                    .allCases
                    .filter { $0.present }
                    .filter { !$0.test }
                    .map { ":bulb: `\(App.prefixString)\($0)` - `\($0.description)`" }
                
                let commandTest = Command
                    .allCases
                    .filter { $0.present }
                    .filter { $0.test }
                    .map { ":hammer_pick: `\(App.prefixString)\($0)` - `\($0.description)`" }
                
                message.reply(with: (commandHelp + commandTest).joined(separator: "\n"))
            case .分流, .赫敦, .季節:
                var isHutton: Bool {
                    guard case let command = botCommand, command == .赫敦 else {
                        return false
                    }
                    
                    return true
                }
                
                var isSeason: Bool {
                    guard case let command = botCommand, command == .季節 else {
                        return false
                    }
                    
                    return true
                }
                
                let probabilityItem: [Probability.ProbabilityItem<ServiceDiversion>] = ServiceDiversion
                    .allCases
                    .filter { isSeason ? $0.isSeason : true }
                    .filter { isHutton ? $0.isHutton : true }
                    .map { .init(item: $0, percent: 10) }
                
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
            case .世界王, .世界王檢查:
                func closestBoss(weekday: WeekDay, nowSecond: Int) -> BossTimeSchedule? {
                    let closestBossSchedule = self.weekdayBossSchedule(weekday: weekday)
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

                    return self.weekdayBossSchedule(weekday: newWeekday).first
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
                    guard case let command = botCommand, command == .世界王檢查 else {
                        return false
                    }
                    
                    return true
                }
                
                if isCheck {
                    let bossNoticeContent = ":alarm_clock:" + " 世界王提醒 " + "`\(bossTime)`" + " \(boss)"
                    let textChannel: BossNoticeChannel = .init(lastMessageId: nil,
                                                               sword: self,
                                                               id: BossNoticeList.textChannel.id,
                                                               type: .guildText)
                    
                    let isBot = user.isBot ?? false
                    
                    if !isBot {
                        textChannel.send(bossNoticeContent + " (手動觸發)")
                    }
                    
                    guard 120...150 ~= bossSchedule.times - nowSecond else {
                        return
                    }
                    
                    textChannel.send(bossNoticeContent)
                } else {
                    message.reply(with: ":stopwatch:" + " 下一批世界王 " + "`\(bossTime)`" + " \(boss)")
                }
           case .測試:
                App.log("\(message.channel.id)")
                App.log("\(message)")
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
        var replyMessage = ":map: `" + diversion.nickName + "`"
        
        guard !diversion.isSeason else {
            
            if diversion.isPvp {
                replyMessage += " :crossed_swords:"
            }
            
            return replyMessage
        }
        
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
}
