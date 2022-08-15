//
// Created on 2022/8/15.
//

import Foundation
import Sword

extension BotViewModel {
    func boss(messageBody: String?, command: Bot.Command, message: Message) {
        guard let user = message.author else { return }
        
        var isBossCheck: Bool {
            return command == .世界王檢查
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)!
        
        let date = Date()
        let optional = Bot.世界王指令選項(rawValue: messageBody ?? .init()) ?? .empty
        
        var weekday: Int {
            guard !isBossCheck, optional != .empty else {
                return calendar.component(.weekday, from: date)
            }
            
            let newDate = calendar.date(byAdding: .second, value: optional.second ?? 0, to: date)!
            return calendar.component(.weekday, from: newDate)
        }
        
        let hourAndMinute = calendar.dateComponents([.hour, .minute], from: date)
        
        var nowSecond: Int {
            guard !isBossCheck, optional != .empty else {
                return hourAndMinute.hour! * 60 * 60 + hourAndMinute.minute! * 60
            }
            
            return 0
        }
        
        guard let nowWeekday = WeekDay(rawValue: weekday),
              let bossSchedules = closestBosses(weekday: nowWeekday, filterSecond: nowSecond) else { return }
        
        if isBossCheck {
            guard let bossSchedule = bossSchedules.first else { return }
            
            let bossTime = bossSchedule.times.formatString
            let boss = bossSchedule
                .boss
                .map { "`\($0.name)`" }
                .joined(separator: "、")
            
            let sendMessage = ":alarm_clock:" + " 世界王提醒 " + "`\(bossTime)`" + " - " + " \(boss)"
            let textChannel: BossNoticeChannel = .init(lastMessageId: nil,
                                                       sword: sword,
                                                       id: BossNoticeList.textChannel.id,
                                                       type: .guildText)
            
            guard 120...150 ~= bossSchedule.times - nowSecond else {
                return
            }
            
            let cacheItems = bossNoticeCache
                .first { $0.userId == user.id.rawValue }
            
            if let item = cacheItems {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.second],
                                                         from: item.commandMessage.timestamp,
                                                         to: message.timestamp)
                
                // 凍結三分鐘的發言
                guard let second = components.second, second > 180 else {
                    return
                }
                
                let cacheItemFirst = bossNoticeCache
                    .firstIndex { $0.userId == user.id.rawValue }
                
                guard let firstIndex = cacheItemFirst else { return }
                
                bossNoticeCache.remove(at: firstIndex)
            }
            
            bossNoticeCache.append(.init(userId: user.id.rawValue,
                                         messageString: sendMessage,
                                         commandMessage: message))
            
            send.accept(.init(channel: textChannel,
                              messageString: sendMessage))
        } else {
            switch optional {
            case .今天, .明天:
                let bossScheduleList = bossSchedules
                    .map { schedule -> String in
                        let bossTime = schedule.times.formatString
                        let boss = schedule
                            .boss
                            .map { "`\($0.name)`" }
                            .joined(separator: "、")
                        
                        return ":stopwatch:" + " `\(bossTime)`" + " - " + " \(boss)"
                    }
                
                send.accept(.init(channel: message.channel,
                                  messageString: bossScheduleList.joined(separator: "\n")))
            case .empty:
                guard let bossSchedule = bossSchedules.first else { return }
                
                let bossTime = bossSchedule.times.formatString
                let boss = bossSchedule
                    .boss
                    .map { "`\($0.name)`" }
                    .joined(separator: "、")
                
                let sendMessage = ":stopwatch:" + " 下一批世界王 " + "`\(bossTime)`" + " - " + " \(boss)"
                
                send.accept(.init(channel: message.channel,
                                  messageString: sendMessage))
            }
        }
    }
}

private extension BotViewModel {
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
            .filter { $0.schedule.isNotEmpty }
        
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
                    .filter { $0.schedule.isNotEmpty }
                
                return .init(boss: sordBoss.map { $0.boss },
                             times: $0)
            }
            .sorted { $0.times < $1.times }
        
        return sordBossSecond
    }
    
    func closestBosses(weekday: WeekDay, filterSecond: Int) -> [BossTimeSchedule]? {
        let closestBossSchedule = weekdayBossSchedule(weekday: weekday)
            .filter { $0.times > filterSecond }
        
        guard closestBossSchedule.isEmpty else {
            return closestBossSchedule
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
        
        return weekdayBossSchedule(weekday: newWeekday)
    }
}
