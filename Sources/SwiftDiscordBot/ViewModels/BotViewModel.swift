//
// Created on 2022/4/6.
//

import Foundation

protocol BotViewModelInput {
    //
}

protocol BotViewModelOutput {
    //
}

protocol BotViewModelPrototype {
    var sets: BotViewModelInput { get }
    var gets: BotViewModelOutput { get }
}

class BotViewModel: BotViewModelPrototype {
    var sets: BotViewModelInput { self }
    var gets: BotViewModelOutput { self }
}

extension BotViewModel: BotViewModelInput {
    //
}

extension BotViewModel: BotViewModelOutput {
    //
}
