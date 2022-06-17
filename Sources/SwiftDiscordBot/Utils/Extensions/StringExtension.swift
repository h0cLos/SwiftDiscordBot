//
// Created on 2022/6/17.
//

import Foundation

extension Int {
    var formatString: String {
        let (hour, minuteSecond) = quotientAndRemainder(dividingBy: 60 * 60)
        let (minute, _) = minuteSecond.quotientAndRemainder(dividingBy: 60)
        return String(format: "%02d:%02d", hour, minute)
    }
}
