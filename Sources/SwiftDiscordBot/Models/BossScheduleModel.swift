//
// Created on 2022/3/17.
//

import Foundation

struct BossScheduleModel: Codable {
    /// 世界王列表
    let boss: [BossModel]?
}

struct BossModel: Codable {
    /// 世界王名稱
    let name: Boss?
    /// 世界王出現排程
    let schedule: [ScheduleModel]?
}

struct ScheduleModel: Codable {
    /// 每週會出現的時間
    let week: Int
    /// 當天會出現的時間
    let times: [ScheduleTimesModel]?
}

struct ScheduleTimesModel: Codable {
    /// 時間
    let time: Int?
}
