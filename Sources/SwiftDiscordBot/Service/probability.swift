//
//  Created on 2022/2/20.
//

import Foundation

class Probability {
    //
}

extension Probability {
    struct ProbabilityItem<T> {
        /// 物件
        let item: T
        /// 機率
        let percent: Int
    }
}

extension Probability {
    func random<T>(in: [ProbabilityItem<T>]) -> ProbabilityItem<T>? {
        var percentSum = `in`
            .map { $0.percent }
            .reduce(0) { $0 + $1 }
        
        for item in `in` {
            let randNum = Int.random(in: 1 ..< percentSum)
            let percent = item.percent
            
            guard randNum <= percent else {
                percentSum -= percent
                continue
            }
            
            return item
        }
        
        return nil
    }
}
