#  Sync is Escaping Swift Bug

Consider scenario where you call `sync` with non-empty `flags` parameter, in context where it must be non-escaping (in this example, in a computed property):

```swift
var value: Int {
    return queue.sync(flags: .inheritQoS) {
        return value
    }
}
```

This will result in Swift runtime error:

> Thread 1: closure argument passed as @noescape to Objective-C has escaped: file , line 56, column 56

The problem manifests itself when you call `sync`, supplying a non-empty `flags`. If you remove the flags, the problem goes away.

Looking at the stack trace, it’s failing in [`_syncHelper`](https://github.com/apple/swift-corelibs-libdispatch/blob/77216601cc50d27d284ecf46d30229a570968853/src/swift/Queue.swift#L311), which declares the closure as escaping when it’s not really, AFAICT. This rendition of `_syncHelper` is called when you supply `flags` and [it’s not empty](https://github.com/apple/swift-corelibs-libdispatch/blob/77216601cc50d27d284ecf46d30229a570968853/src/swift/Queue.swift#L363).

I believe that the closure in [`_syncHelper`](https://github.com/apple/swift-corelibs-libdispatch/blob/77216601cc50d27d284ecf46d30229a570968853/src/swift/Queue.swift#L311) should not be marked as `@escaping`.

For example of the above issue, see [Bug.swift](SyncIsEscapingBug/Bug.swift), which I've invoked from the [view controller](SyncIsEscapingBug/ViewController.swift).

---

I found this while researching this question on StackOverflow: https://stackoverflow.com/q/62660894/1271826

---

This was developed using Xcode 11.5 (11E608c). Both Xcode and app are running on macOS 10.15.5.

---

July 1, 2020

Copyright (c) 2020 Rob Ryan. All Rights Reserved.

See [License](LICENSE.md).
