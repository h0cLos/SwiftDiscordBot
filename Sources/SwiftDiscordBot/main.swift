import Foundation
import Sword
import SwiftBacktrace

setlinebuf(stdout)

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
App.bot.on(.messageCreate) { data in
    guard let message = data as? Message else { return }
    
    if message.content == "!ping" {
        message.reply(with: "Pong!")
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
