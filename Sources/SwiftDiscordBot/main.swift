import Foundation
import Sword
import SwiftBacktrace

setlinebuf(stdout)

/// 指令
enum BotCommand: String {
    case 分流
}

/// 分流
enum ServiceDiversion: CaseIterable {
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
    case 阿勒沙
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
        switch self {
        case .梅迪亞_1:
            return "梅迪亞-1"
        case .梅迪亞_2:
            return "梅迪亞-2"
        case .梅迪亞_3:
            return "梅迪亞-3"
        case .卡爾佩恩_1:
            return "卡爾佩恩-1"
        case .卡爾佩恩_2:
            return "卡爾佩恩-2"
        case .卡爾佩恩_3:
            return "卡爾佩恩-3"
        case .卡瑪希爾比亞_1:
            return "卡瑪希爾比亞-1"
        case .卡瑪希爾比亞_2:
            return "卡瑪希爾比亞-2"
        case .卡瑪希爾比亞_3:
            return "卡瑪希爾比亞-3"
        case .巴雷諾斯_1:
            return "巴雷諾斯-1"
        case .巴雷諾斯_2:
            return "巴雷諾斯-2"
        case .巴雷諾斯_3:
            return "巴雷諾斯-3"
        case .璐璐飛_1:
            return "璐璐飛-1"
        case .璐璐飛_2:
            return "璐璐飛-2"
        case .阿勒沙:
            return "阿勒沙"
        case .瓦倫西亞_1:
            return "瓦倫西亞-1"
        case .瓦倫西亞_2:
            return "瓦倫西亞-2"
        case .瓦倫西亞_3:
            return "瓦倫西亞-3"
        case .賽林迪亞_1:
            return "賽林迪亞-1"
        case .賽林迪亞_2:
            return "賽林迪亞-2"
        case .賽林迪亞_3:
            return "賽林迪亞-3"
        case .艾裴莉雅_1:
            return "艾裴莉雅-1"
        case .艾裴莉雅_2:
            return "艾裴莉雅-2"
        case .艾裴莉雅_3:
            return "艾裴莉雅-3"
        }
    }
}

// MARK: - edit status
App.bot.editStatus(to: "online", playing: "Xcode")
App.log("is online and playing \(App.playing).")

// MARK: - update nickname
App.bot.on(.guildAvailable) { data in
    guard let guild = data as? Guild else { return }
    
    App.log("Guild Available: \(guild.name)")
    
    if guild.members[App.bot.user!.id]?.nick != App.nickname {
        guild.setNickname(to: App.nickname) { error in
            if let error = error {
                App.log("failed to change nickname in guild: \(guild.name), error: \(error)")
            }
        }
    }
}

// MARK: - MessageCreate
App.bot.on(.messageCreate) {
    let probability = Probability()
    
    guard let message = $0 as? Message else { return }
    
    let content = message.content
    
    guard content.hasPrefix(App.prefixString) else { return }
    
    let command = content.replacingOccurrences(of: App.prefixString, with: "")
    
    guard let botCommand = BotCommand(rawValue: command) else { return }
    
    switch botCommand {
    case .分流:
        let probabilityItem: [Probability.ProbabilityItem] = ServiceDiversion
            .allCases
            .map { .init(name: $0.name, percent: 1) }
        
        guard let item = probability.random(in: probabilityItem) else { return }
        
        message.reply(with: ":map:" + " `" + item.name + "`")
    }
}

// https://devcenter.heroku.com/articles/dynos#shutdown
SwiftBacktrace.setInterruptFunction { signo in
    App.bot.disconnect()
    
    fputs(backtrace().joined(separator: "\n") + "\nsignal: \(signo)", stderr)
    fflush(stderr)
    
    exit(128 + signo)
}

App.bot.connect()
