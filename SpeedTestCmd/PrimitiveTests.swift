import Foundation
import os

final class StateHolderLock {
    var lock = os_unfair_lock_s()

    init() {}

    var sum = 0

    var onNewValueReceived: ((Int) -> Void)!

    func handleValueRecieved(_ val: Int) {
        os_unfair_lock_lock(&lock)
        sum += val
        os_unfair_lock_unlock(&lock)
        onNewValueReceived(val)
    }
}

final actor StateHolderActor {
    init() {}

    var sum = 0

    nonisolated(unsafe) var onNewValueReceived: ((Int) -> Void)!

    func handleValueRecieved(_ val: Int) {
        sum += val
        onNewValueReceived(val)
    }
}

func measureSH(function: StaticString = #function) -> () -> Void {
    let start = Date()

    return {
        let end = Date()

        let diff = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate

        print("ASDF measure SH \(function) \(Int(diff * 1000)) ms")
    }
}

func testStateHolderActor() async {
    let e = measureSH()
    let actor = StateHolderActor()

    var sum = 0
    actor.onNewValueReceived = { val in
        sum += val
    }

    for i in 0 ..< iterations * 100 {
        await actor.handleValueRecieved(1)
    }

    e()
}

func testStateHolderLocked() {
    let e = measureSH()
    let actor = StateHolderLock()

    var sum = 0
    actor.onNewValueReceived = { val in
        sum += val
    }

    for i in 0 ..< iterations * 100 {
        actor.handleValueRecieved(1)
    }

    e()
}
