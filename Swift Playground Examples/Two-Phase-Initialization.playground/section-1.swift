// Playground - noun: a place where people can play

import Cocoa

class Root {
    var rootA = "I am variable"
    let rootB : String = "I am constant"
}

class SubclassA: Root {
    var subA : String
    let subB : String
    
    override init() {
        self.subA = "Subclass A variable"
        self.subB = "Subclass A constant"
        
        super.init()
    }
    
    init(subA: String, subB: String) {
        self.subA = subA
        self.subB = subB
        
        super.init()
    }
    
    /*!
        Value types as arguments are always treated as constants inside the scope of the function.
        To modify the passed in value (still only a copy) prefix the local variable name with the 'var' keyword.
        Same rules apply for initializers.
     */
    convenience init(subA: String, subB: String, var repetiton: Int) {
        var concat = subB
        while repetiton > 1 {
            concat += subB
            repetiton -= 1
        }
        self.init(subA: subA, subB: concat)
    }
}

class SubSubclassA: SubclassA {
    let subsubA = "Constant Example 1"
    let subsubB = "Constant Example 2"
}

let root = Root()

let subclassA1 = SubclassA()
let subclassA2 = SubclassA(subA: "test", subB: "other")
let subclassA3 = SubclassA(subA: "Hi", subB: "You", repetiton: 3)


/*!
    All initializers are inherited from the superclass.
    This is possible, because the local properties already have a default value and no custom initializers are specified.
 */
let subsubclassA1 = SubSubclassA()
let subsubclassA2 = SubSubclassA(subA: "Yo", subB: "it works")
let subsubclassA3 = SubSubclassA(subA: "Hi", subB: "me", repetiton: 5)