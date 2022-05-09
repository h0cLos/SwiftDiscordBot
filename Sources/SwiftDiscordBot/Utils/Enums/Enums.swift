//
// Created on 2022/4/1.
//

import Foundation
import Sword

/// 指令白名單
enum PermissionList: UInt64, CaseIterable {
    case ck = 348320085565243394
}

/// 世界王通知推送頻道
enum BossNoticeList: UInt64 {
    case testChannel = 937307583537102940
    case textChannel = 960960062724137040
    /// id
    var id: Snowflake {
        return .init(rawValue: rawValue)
    }
}

/// 分流
enum ServiceDiversion: String, CaseIterable {
    case 季節伺服器_1
    case 季節伺服器_2
    case 季節阿勒沙
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
    /// 別名
    var nickName: String {
        let name = self.name
        
        switch self {
        case .季節阿勒沙:
            return name + "(PVP)"
        case .卡爾佩恩_3:
            return name + " (奶綠線)"
        default:
            return name
        }
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
        case .阿勒沙, .季節阿勒沙:
            return true
        default:
            return false
        }
    }
    /// 是否為季節分流
    var isSeason: Bool {
        switch self {
        case .季節伺服器_1, .季節伺服器_2, .季節阿勒沙:
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
    /// 名稱
    var name: String {
        return rawValue.replacingOccurrences(of: "_", with: "/")
    }
}

/// 星期
enum WeekDay: Int, Codable, CaseIterable {
    /// 星期日
    case sunday = 1
    /// 星期一
    case monday
    /// 星期二
    case tuesday
    /// 星期三
    case wednesday
    /// 星期四
    case thursday
    /// 星期五
    case friday
    /// 星期六
    case saturday
    /// 未知
    case unknown
}

/// 運勢
enum Omikuji: String, CaseIterable {
    case 超級大吉
    case 大吉
    case 小吉
    case 吉
    case 半吉
    case 末吉
    case 末小吉
    case 凶
    case 大凶
    /// 機率
    var percent: Int {
        switch self {
        case .超級大吉:
            return 5
        case .大吉:
            return 75
        case .小吉:
            return 40
        case .吉:
            return 60
        case .半吉:
            return 50
        case .末吉:
            return 60
        case .末小吉:
            return 30
        case .凶:
            return 150
        case .大凶:
            return 10
        }
    }
}

/// 面板獎勵: AP
enum BonusAP: Int, CaseIterable {
    case lv1 = 249
    case lv2 = 253
    case lv3 = 257
    case lv4 = 261
    case lv5 = 265
    case lv6 = 269
    case lv7 = 273
    case lv8 = 277
    case lv9 = 281
    case lv10 = 285
    case lv11 = 289
    case lv12 = 293
    case lv13 = 297
    case lv14 = 301
    case lv15 = 305
    case lv16 = 309
    case lv17 = 316
    case lv18 = 323
    case lv19 = 330
    case lv20 = 340
    /// 門檻上限
    var maxAP: String {
        switch self {
        case .lv1:
            return "252"
        case .lv2:
            return "256"
        case .lv3:
            return "260"
        case .lv4:
            return "264"
        case .lv5:
            return "268"
        case .lv6:
            return "272"
        case .lv7:
            return "276"
        case .lv8:
            return "280"
        case .lv9:
            return "284"
        case .lv10:
            return "288"
        case .lv11:
            return "292"
        case .lv12:
            return "296"
        case .lv13:
            return "300"
        case .lv14:
            return "304"
        case .lv15:
            return "308"
        case .lv16:
            return "315"
        case .lv17:
            return "322"
        case .lv18:
            return "329"
        case .lv19:
            return "339"
        case .lv20:
            return ""
        }
    }
    /// 獎勵攻擊力
    var bonusAttack: String {
        switch self {
        case .lv1:
            return "57"
        case .lv2:
            return "69"
        case .lv3:
            return "83"
        case .lv4:
            return "101"
        case .lv5:
            return "122"
        case .lv6:
            return "137"
        case .lv7:
            return "142"
        case .lv8:
            return "148"
        case .lv9:
            return "154"
        case .lv10:
            return "160"
        case .lv11:
            return "167"
        case .lv12:
            return "174"
        case .lv13:
            return "181"
        case .lv14:
            return "188"
        case .lv15:
            return "196"
        case .lv16:
            return "200"
        case .lv17:
            return "203"
        case .lv18:
            return "205"
        case .lv19:
            return "207"
        case .lv20:
            return "210"
        }
    }
}

/// 面板獎勵: DP
enum BonusDP: Int, CaseIterable {
    case lv1 = 301
    case lv2 = 308
    case lv3 = 315
    case lv4 = 322
    case lv5 = 329
    case lv6 = 335
    case lv7 = 341
    case lv8 = 347
    case lv9 = 353
    case lv10 = 359
    case lv11 = 365
    case lv12 = 371
    case lv13 = 377
    case lv14 = 383
    case lv15 = 389
    case lv16 = 395
    case lv17 = 401
    /// 門檻上限
    var maxDP: String {
        switch self {
        case .lv1:
            return "307"
        case .lv2:
            return "314"
        case .lv3:
            return "321"
        case .lv4:
            return "328"
        case .lv5:
            return "334"
        case .lv6:
            return "340"
        case .lv7:
            return "346"
        case .lv8:
            return "352"
        case .lv9:
            return "358"
        case .lv10:
            return "364"
        case .lv11:
            return "370"
        case .lv12:
            return "376"
        case .lv13:
            return "382"
        case .lv14:
            return "388"
        case .lv15:
            return "394"
        case .lv16:
            return "400"
        case .lv17:
            return ""
        }
    }
    /// 獎勵攻擊力
    var bonusDefense: String {
        switch self {
        case .lv1:
            return "14"
        case .lv2:
            return "15"
        case .lv3:
            return "16"
        case .lv4:
            return "17"
        case .lv5:
            return "18"
        case .lv6:
            return "19"
        case .lv7:
            return "20"
        case .lv8:
            return "21"
        case .lv9:
            return "22"
        case .lv10:
            return "23"
        case .lv11:
            return "24"
        case .lv12:
            return "25"
        case .lv13:
            return "26"
        case .lv14:
            return "27"
        case .lv15:
            return "28"
        case .lv16:
            return "29"
        case .lv17:
            return "30"
        }
    }
}
