// Playground - noun: a place where people can play

//import Cocoa


var a = [1,2,3,4,5]
for (i,x) in enumerate(a) {
    "i = \(i), x = \(x)"
    if x == 2 {
        "deleting \(x)!"
        a.removeAtIndex(i)
    }
    "i = \(i), x = \(x)"
}
a
