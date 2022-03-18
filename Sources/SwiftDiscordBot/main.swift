import Foundation
import Sword
import SwiftBacktrace

setlinebuf(stdout)

// https://devcenter.heroku.com/articles/dynos#shutdown
SwiftBacktrace.setInterruptFunction { signo in
    App.bot.disconnect()
    
    fputs(backtrace().joined(separator: "\n") + "\nsignal: \(signo)", stderr)
    fflush(stderr)
    
    exit(128 + signo)
}

App.bot.status(to: .online, playItem: App.playing)
App.bot.connect()
