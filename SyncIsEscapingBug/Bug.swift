//
//  Bug.swift
//  SyncIsEscapingBug
//
//  Created by Robert Ryan on 7/1/20.
//  Copyright © 2020 Robert Ryan. All rights reserved.
//

import Foundation

class Bug {
    let foo = SynchronizedInt(42)
    
    func ok() {
        print("ok", foo.valueOk)        // works fine
    }

    func crash() {
        print("crash", foo.valueCrash)  // generates Swift runtime error
    }
}

// This is not complete implementation (original was generic, had setters, etc.), but
// I wanted to distill this down to the bare essentials to manifest the bug.

class SynchronizedInt {
    private let queue = DispatchQueue(label: "X")
    private var _value: Int
    
    init(_ value: Int) {
        _value = value
    }

    // computed variables (where it must not be escaping):
    //
    //  - first scenario, `valueOk`, works as expected; but
    //  - second scenario, `valueCrash`, generates Swift runtime error.
    
    // this is ok
    
    var valueOk: Int {
        return queue.sync() {
            return _value
        }
    }

    // this reports
    //
    // "Thread 1: closure argument passed as @noescape to Objective-C has escaped: file , line 56, column 56"
    
    var valueCrash: Int {
        return queue.sync(flags: .inheritQoS) {
            return _value
        }
    }
}
