//
// Created on 2022/4/1.
//

import Foundation
import Sword

/// UserDefaults Key 值
enum UserDefaultKey: String {
    case id
    case lastMessageId
}

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
