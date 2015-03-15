// Playground - noun: a place where people can play

//import Cocoa

var x: [Int] = [1,2,3,4]

extension Array {
    func find_first(predicate: T->Bool) -> (T,Int)? {
        for (i, x) in enumerate(self) {
            if predicate(x) {
                return (x, i)
            }
        }
        return nil
    }
}

var a = x.find_first { $0 > 1 }
a