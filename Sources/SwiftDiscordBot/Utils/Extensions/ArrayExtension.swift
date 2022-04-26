//
// Created on 2022/4/7.
//

import Foundation

extension Array where Element: Hashable {
    func unique() -> Array {
        var hash = [Element : Bool]()
        
        return reduce([], { (array, element) in
            if hash[element] != nil { return array }
            hash[element] = true
            return array + [element]
        })
    }
}

extension Array {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
